local module = {}

local AssetService = game:GetService("AssetService")

local mesh = AssetService:CreateEditableMesh()

local curveSteps = 100
local circleSegments = 12
local tubeRadius = 0.2

local rings = {}

local function curve(t)
	return Vector3.new(
		math.cos(t),
		t / 2,
		math.sin(t)
	)
end

for i = 0, curveSteps do
	local t = i / curveSteps * math.pi * 8

	local center = curve(t)

	-- aproxima tangente
	local nextCenter = curve(t + 0.01)
	local tangent = (nextCenter - center).Unit

	local up = Vector3.yAxis

	if math.abs(tangent:Dot(up)) > 0.99 then
		up = Vector3.xAxis
	end

	local right = tangent:Cross(up).Unit
	local forward = right:Cross(tangent)

	rings[i] = {}

	for j = 0, circleSegments - 1 do
		local angle = j / circleSegments * math.pi * 2

		local offset =
			right * math.cos(angle) * tubeRadius +
			forward * math.sin(angle) * tubeRadius

		rings[i][j] =
			mesh:AddVertex(center + offset)
	end
end

-- conecta anéis
for i = 0, curveSteps - 1 do
	for j = 0, circleSegments - 1 do

		local a = rings[i][j]
		local b = rings[i][(j+1)%circleSegments]

		local c = rings[i+1][(j+1)%circleSegments]
		local d = rings[i+1][j]

		mesh:AddTriangle(a,b,c)
		mesh:AddTriangle(a,c,d)
	end
end

local part =
	AssetService:CreateMeshPartAsync(
		Content.fromObject(mesh)
	)

part.Anchored = true
part.Parent = workspace

return module
