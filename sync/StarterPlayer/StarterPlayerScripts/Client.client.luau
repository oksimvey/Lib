const ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage") :: ReplicatedStorage
const AssetService: AssetService = game:GetService("AssetService") :: AssetService

const Lib: Folder = ReplicatedStorage:WaitForChild("Lib") :: Folder

const Rendering: Folder = Lib:WaitForChild("Rendering") :: Folder

const MathUtil = require(game.ReplicatedStorage.Lib.Math.MathUtils)


local condition : boolean = false

condition = true


local function buildParametricMesh(f, uSteps, vSteps, uMin, uMax, vMin, vMax, closeU, closeV)
	local mesh = AssetService:CreateEditableMesh()
	
	-- create a reusable color ID
	local red = mesh:AddColor(Color3.fromRGB(255, 0, 0), 0)

	-- create a reusable color ID
	local green = mesh:AddColor(Color3.fromRGB(0, 255, 0), 1)

	-- create a reusable color ID
	local blue = mesh:AddColor(Color3.fromRGB(0, 0, 255), 2)


	local verts = {}
	for i = 0, uSteps do
		verts[i] = {}
		local u = uMin + (uMax - uMin) * i / uSteps
		for j = 0, vSteps do
			local v = vMin + (vMax - vMin) * j / vSteps
			if closeU and i == uSteps then
				verts[i][j] = verts[0][j]
			elseif closeV and j == vSteps then
				verts[i][j] = verts[i][0]
			else
				verts[i][j] = mesh:AddVertex(f(u, v))
			end
		end
	end

	for i = 0, uSteps - 1 do
		for j = 0, vSteps - 1 do
			local ni = closeU and (i + 1) % uSteps or (i + 1)
			local nj = closeV and (j + 1) % vSteps or (j + 1)

			local a = verts[i][j]
			local b = verts[ni][j]
			local c = verts[ni][nj]
			local d = verts[i][nj]
			
		

			local f1 = mesh:AddTriangle(a, b, c)
			mesh:SetFaceColors(f1, {red,green, blue})

			local f2 = mesh:AddTriangle(a, c,d)
			mesh:SetFaceColors(f2, {red, green, blue})
		end
	end

	return mesh
end

-- Helpers ----------------------------------------------------------------

local function spawnMesh(editableMesh, position)
	local part = AssetService:CreateMeshPartAsync(Content.fromObject(editableMesh))
	
	part.Position = position
	part.Parent = workspace
	return part
end

-- Exemplos ---------------------------------------------------------------

local pi = math.pi

-- Esfera (equivalente ao seu código original)

local sphere : MeshPart = spawnMesh(buildParametricMesh(
	function(u, v )
		return Vector3.new(
			math.cos(u) * math.sin(v),
			math.sin(u)*math.sin(v),
			math.cos(v)
		) * 5 
	end,
	32, 16,       -- uSteps, vSteps
	0, 2*pi,      -- u: longitude
	0, pi,        -- v: latitude
	true, false   -- fecha U, não fecha V (polos)
	), Vector3.new(0,0, 0))










