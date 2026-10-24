# Non-destructive, allowlisted GitHub -> Azul bridge. No stash, reset --hard, or Place publishing.
[CmdletBinding()]
param([switch]$ValidateOnly, [string]$ProjectDir, [int]$Port)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Get-ManagedMappings {
    param([string]$Root)
    $spec = Get-Content -LiteralPath (Join-Path $Root 'deploy.project.json') -Raw | ConvertFrom-Json
    $script:found = New-Object System.Collections.Generic.List[object]
    function Walk {
        param($Node, [string[]]$Parts)
        if ($null -eq $Node) { return }
        $pathProp = $Node.PSObject.Properties['$path']
        if ($null -ne $pathProp) {
            $sourcePath = [string]$pathProp.Value
            if ([IO.Path]::IsPathRooted($sourcePath) -or $sourcePath -match '(^|[\\/])\.\.([\\/]|$)') {
                throw "Unsafe deploy source path: $sourcePath"
            }
            $full = [IO.Path]::GetFullPath((Join-Path $Root $sourcePath))
            if (-not $full.StartsWith(([IO.Path]::GetFullPath($Root).TrimEnd('\','/') + [IO.Path]::DirectorySeparatorChar), [StringComparison]::OrdinalIgnoreCase)) {
                throw "Deploy source escapes repository: $sourcePath"
            }
            if (-not (Test-Path -LiteralPath $full)) { throw "Missing managed source: $sourcePath" }
            $destParts = @($Parts)
            if ($destParts.Count -gt 0 -and $destParts[0] -eq 'StarterPlayerScripts') {
                $destParts = @('StarterPlayer','StarterPlayerScripts') + @($destParts | Select-Object -Skip 1)
            } elseif ($destParts.Count -gt 0 -and $destParts[0] -eq 'StarterCharacterScripts') {
                $destParts = @('StarterPlayer','StarterCharacterScripts') + @($destParts | Select-Object -Skip 1)
            }
            if ($destParts.Count -eq 0 -or $destParts[0] -notin @('ReplicatedStorage','ServerScriptService','StarterPlayer','ReplicatedFirst','ServerStorage','Lighting','Workspace')) {
                throw "Unexpected destination for $sourcePath"
            }
            if ($destParts[0] -eq 'Workspace' -and $destParts.Count -lt 2) {
                throw 'Cannot sync the entire Workspace.'
            }
            $files = if (Test-Path -LiteralPath $full -PathType Leaf) { @(Get-Item -LiteralPath $full) }
                     else { @(Get-ChildItem -LiteralPath $full -Recurse -File -Filter '*.luau') }
            foreach ($file in $files) {
                if ($file.Extension -ne '.luau') { continue }
                if (Test-Path -LiteralPath $full -PathType Leaf) {
                    $targetParts = @($destParts | Select-Object -SkipLast 1) + @($file.Name)
                } else {
                    $rel = $file.FullName.Substring($full.Length).TrimStart('\','/')
                    $targetParts = @($destParts) + @($rel)
                }
                $target = ($targetParts -join '/').Replace('\','/')
                $sourceRel = $file.FullName.Substring($Root.TrimEnd('\','/').Length).TrimStart('\','/').Replace('\','/')
                $script:found.Add([pscustomobject]@{ Source = $sourceRel; Target = $target })
            }
            return
        }
        foreach ($item in $Node.PSObject.Properties) {
            if (-not $item.Name.StartsWith('$') -and $null -ne $item.Value) {
                Walk -Node $item.Value -Parts ($Parts + @($item.Name))
            }
        }
    }
    Walk -Node $spec.tree -Parts @()
    if ($script:found.Count -eq 0) { throw 'No Luau files in managed deploy paths.' }
    return @($script:found | Sort-Object Target -Unique)
}

function Invoke-Git {
    param([string[]]$GitArgs)
    # Git for Windows writes harmless progress to stderr; check exit code, not stderr.
    $ErrorActionPreference = 'Continue'
    $out = @(& git -C $script:repoRoot @GitArgs 2>&1)
    if ($LASTEXITCODE -ne 0) {
        throw ("git " + ($GitArgs -join ' ') + ": " + ($out -join [Environment]::NewLine))
    }
    return ($out -join [Environment]::NewLine).Trim()
}

if ($ValidateOnly) {
    $root = (Resolve-Path '.').Path
    $mappings = @(Get-ManagedMappings -Root $root)
    $sources = @($mappings | Select-Object -ExpandProperty Source -Unique)
    foreach ($source in $sources) {
        & luau-compile.exe (Join-Path $root $source) | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "Luau syntax failed: $source" }
    }
    Write-Host "Validated $($sources.Count) managed Luau files."
    return
}

if ([string]::IsNullOrWhiteSpace($ProjectDir) -or -not [IO.Path]::IsPathRooted($ProjectDir)) {
    throw 'AZUL_PROJECT_DIR must be an existing, absolute persistent clone directory.'
}
if ($Port -lt 1 -or $Port -gt 65535) { throw 'AZUL_PORT must be a valid, dedicated TCP port.' }
$script:repoRoot = (Resolve-Path -LiteralPath $ProjectDir).Path
$expectedRepo = [string]$env:GITHUB_REPOSITORY
if ($expectedRepo -notmatch '^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$') { throw 'Missing or invalid GITHUB_REPOSITORY.' }
$expectedBranch = [string]$env:AZUL_EXPECTED_BRANCH
if (-not $expectedBranch) { throw 'Missing AZUL_EXPECTED_BRANCH.' }
$actualRoot = Invoke-Git -GitArgs @('rev-parse','--show-toplevel')
if ([IO.Path]::GetFullPath($actualRoot).TrimEnd('\','/') -ine [IO.Path]::GetFullPath($script:repoRoot).TrimEnd('\','/')) {
    throw 'AZUL_PROJECT_DIR must point to the clone repository root.'
}
if ((Invoke-Git -GitArgs @('branch','--show-current')) -cne $expectedBranch) {
    throw "Persistent clone is not on expected branch $expectedBranch."
}
$remote = Invoke-Git -GitArgs @('remote','get-url','origin')
if ($remote -notmatch ("(?i)github\.com[:/]" + [regex]::Escape($expectedRepo) + "(\.git)?/?$")) {
    throw "Unexpected origin: $remote"
}

# This is a connectivity check, not a guarantee that the Studio plugin is connected.
$tcp = New-Object System.Net.Sockets.TcpClient
try {
    $pending = $tcp.BeginConnect('127.0.0.1', $Port, $null, $null)
    if (-not $pending.AsyncWaitHandle.WaitOne(1500)) { throw "No listener on port $Port" }
    $tcp.EndConnect($pending)
} finally { $tcp.Close() }

$before = @(Get-ManagedMappings -Root $script:repoRoot)
if (-not $env:AZUL_PULL_TOKEN) { throw 'Missing ephemeral GitHub Actions token.' }
$credential = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("x-access-token:$($env:AZUL_PULL_TOKEN)"))
$env:GIT_CONFIG_COUNT = '1'
$env:GIT_CONFIG_KEY_0 = 'http.https://github.com/.extraheader'
$env:GIT_CONFIG_VALUE_0 = 'AUTHORIZATION: basic ' + $credential
$env:GIT_TERMINAL_PROMPT = '0'
try {
    Invoke-Git -GitArgs @('fetch','origin',$expectedBranch) | Out-Null
    $incoming = Invoke-Git -GitArgs @('rev-parse','FETCH_HEAD')
    if ($env:GITHUB_SHA -and $incoming -cne $env:GITHUB_SHA) {
        throw "Remote advanced since validation ($incoming != $env:GITHUB_SHA); refusing unvalidated sync."
    }
    Invoke-Git -GitArgs @('merge-base','--is-ancestor','HEAD','FETCH_HEAD') | Out-Null

    # Use an independent temporary index: original index/working files are untouched.
    # Snapshot all current managed files and their previously projected Studio copies,
    # including untracked files. Anchor the object under refs/azul-backups and VERIFY it
    # before restoring any tracked sources for the ff-only pull.
    $tempBase = if ($env:RUNNER_TEMP) { $env:RUNNER_TEMP } else { [IO.Path]::GetTempPath() }
    $indexFile = Join-Path $tempBase ("azul-index-" + [guid]::NewGuid().ToString('N'))
    $env:GIT_INDEX_FILE = $indexFile
    $env:GIT_AUTHOR_NAME = 'Azul Local Backup'
    $env:GIT_AUTHOR_EMAIL = 'azul-backup@localhost'
    $env:GIT_COMMITTER_NAME = 'Azul Local Backup'
    $env:GIT_COMMITTER_EMAIL = 'azul-backup@localhost'
    try {
        $baseHead = Invoke-Git -GitArgs @('rev-parse','HEAD')
        Invoke-Git -GitArgs @('read-tree','HEAD') | Out-Null
        foreach ($m in $before) {
            Invoke-Git -GitArgs @('add','-A','--',$m.Source) | Out-Null
            $mirrorRel = '.azul-managed/' + $m.Target
            if (Test-Path -LiteralPath (Join-Path $script:repoRoot $mirrorRel) -PathType Leaf) {
                Invoke-Git -GitArgs @('add','-f','--',$mirrorRel) | Out-Null
            }
        }
        $tree = Invoke-Git -GitArgs @('write-tree')
        $commit = Invoke-Git -GitArgs @('commit-tree',$tree,'-p',$baseHead,'-m',"Azul local backup before $incoming")
        if ($commit -notmatch '^[0-9a-f]{40,64}$') { throw 'Could not create local Git backup commit.' }
        $ref = 'refs/azul-backups/' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N')
        Invoke-Git -GitArgs @('update-ref',$ref,$commit) | Out-Null
        if ((Invoke-Git -GitArgs @('rev-parse',$ref)) -cne $commit) { throw 'Backup ref verification failed.' }
        if ((Invoke-Git -GitArgs @('rev-parse',"$ref^{tree}")) -cne $tree) { throw 'Backup tree verification failed.' }
        if ((Invoke-Git -GitArgs @('cat-file','-t',$commit)) -cne 'commit') { throw 'Backup object verification failed.' }
        Write-Host "Verified local backup $ref ($commit)."
    } finally {
        Remove-Item Env:GIT_INDEX_FILE,Env:GIT_AUTHOR_NAME,Env:GIT_AUTHOR_EMAIL,Env:GIT_COMMITTER_NAME,Env:GIT_COMMITTER_EMAIL -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $indexFile -Force -ErrorAction SilentlyContinue
    }

    # Only the allowlisted tracked managed source files are restored.
    # Unknown files (including untracked files) are never deleted.
    foreach ($source in @($before | Select-Object -ExpandProperty Source -Unique)) {
        if ((Invoke-Git -GitArgs @('ls-files','--',$source))) {
            Invoke-Git -GitArgs @('restore','--source=HEAD','--staged','--worktree','--',$source) | Out-Null
        }
    }
    Invoke-Git -GitArgs @('pull','--ff-only','origin',$expectedBranch) | Write-Host
    if ((Invoke-Git -GitArgs @('rev-parse','HEAD')) -cne $incoming) { throw 'Pulled HEAD does not match validated revision.' }
} finally {
    Remove-Item Env:GIT_CONFIG_COUNT,Env:GIT_CONFIG_KEY_0,Env:GIT_CONFIG_VALUE_0,Env:GIT_TERMINAL_PROMPT -ErrorAction SilentlyContinue
}

# Projected sync root prevents unrelated exports (especially Workspace) being sent to Studio.
# No removals: deleted managed scripts require explicit manual reconciliation.
$after = @(Get-ManagedMappings -Root $script:repoRoot)
foreach ($m in $after) {
    $src = Join-Path $script:repoRoot $m.Source
    $dest = Join-Path $script:repoRoot ('.azul-managed/' + $m.Target)
    $parent = Split-Path -Parent $dest
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    if ((Test-Path -LiteralPath $dest -PathType Leaf) -and
        (Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash -eq (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash) {
        continue
    }
    Copy-Item -LiteralPath $src -Destination $dest -Force
}
Write-Host "Updated validated sources at $incoming; projected $($after.Count) Luau files to .azul-managed."
Write-Host 'Azul daemon must be watching .azul-managed; Studio plugin receipt requires confirmation.'
