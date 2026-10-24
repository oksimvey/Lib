# Lib — validated GitHub -> Azul Live Sync

On trusted master pushes or workflow_dispatch, the existing Windows self-hosted runner validates Rojo and compiles **the Luau files selected by deploy.project.json**, then performs a verified fast-forward pull in a **persistent** clone. No Place is published.

## One-time Windows setup
- Clone this repository at C:\Roblox\Lib (or set GitHub Actions variable AZUL_PROJECT_DIR to a different absolute clone path). Use master.
- This repository uses dedicated port **8104** (or set AZUL_PORT). Do not share that port or persistent clone with another project.
- Install Azul CLI and Azul Companion; from the persistent clone start: azul --sync-dir ./.azul-managed --port 8104
- Connect the **correct existing Studio Place** to ws://localhost:8104. Verify individual managed scripts before enabling automatic sync. Never use --destructive, full-Place build, or automatic Publish.
- To seed the initial managed scripts, use explicitly targeted non-destructive Azul pushes into their exact service locations (consult deploy.project.json), while the live daemon is stopped. Reconnect the live daemon after that. Never push an entire Place.

The bridge uses deploy.project.json to project **only managed Luau scripts** into .azul-managed/. Existing source paths stay untouched; sync/Workspace and other external exports cannot be projected inadvertently. This projection is local to the clone and need not be committed. Deleted scripts are not automatically deleted from Studio.

Local managed changes are saved into a verified local Git commit under refs/azul-backups/ before any tracked files are restored for git pull --ff-only. Backups are never automatically reapplied; inspect with git show <ref> or git ls-tree -r <ref>, then reconcile manually. No git stash or git reset --hard.

CI success means validation, pull, and file projection succeeded, **not** proof that the Studio plugin received updates or that a Place was saved. Azul's TCP listener alone cannot prove a Studio connection. Run Studio and Azul in a usable interactive Windows session.

Old Studio/Open Cloud deployment scripts remain for historical reference but are not executed by this workflow.
