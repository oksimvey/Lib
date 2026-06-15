local module = {}

local AssetService = game:GetService("AssetService")

-- Ajustes da esfera
local radius = 5
local rings = 16      -- latitude
local segments = 32   -- longitude

local editableMesh = AssetService:CreateEditableMesh()

-- Polos
local topPole = editableMesh:AddVertex(Vector3.new(0, radius, 0))
local bottomPole = editableMesh:AddVertex(Vector3.new(0, -radius, 0))

-- Guarda os vértices dos anéis
local ringVertices = {}

-- Cria os anéis intermediários
for i = 1, rings - 1 do
	local phi = math.pi * i / rings
	local y = math.cos(phi) * radius
	local ringRadius = math.sin(phi) * radius

	ringVertices[i] = {}

	for j = 0, segments - 1 do
		local theta = 2 * math.pi * j / segments
		local x = math.cos(theta) * ringRadius
		local z = math.sin(theta) * ringRadius

		ringVertices[i][j] = editableMesh:AddVertex(Vector3.new(x, y, z))
	end
end

-- Tampa de cima
for j = 0, segments - 1 do
	local a = ringVertices[1][j]
	local b = ringVertices[1][(j + 1) % segments]
	editableMesh:AddTriangle(topPole, b, a)
end

-- Corpo
for i = 1, rings - 2 do
	for j = 0, segments - 1 do
		local a = ringVertices[i][j]
		local b = ringVertices[i][(j + 1) % segments]
		local c = ringVertices[i + 1][(j + 1) % segments]
		local d = ringVertices[i + 1][j]

		editableMesh:AddTriangle(a, b, c)
		editableMesh:AddTriangle(a, c, d)
	end
end

-- Tampa de baixo
for j = 0, segments - 1 do
	local a = ringVertices[rings - 1][j]
	local b = ringVertices[rings - 1][(j + 1) % segments]
	editableMesh:AddTriangle(a, bottomPole, b)
end

-- Converte a malha em MeshPart
local meshPart = AssetService:CreateMeshPartAsync(Content.fromObject(editableMesh))
meshPart.Anchored = true
meshPart.Position = Vector3.new(0, 5, 0)
meshPart.Parent = workspace

return module
