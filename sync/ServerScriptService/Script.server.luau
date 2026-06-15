local Workspace = game:GetService("Workspace")

local part = Workspace.Part

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ms = game:GetService("MaterialService")

local counter = 0

local water = Workspace.water

local defaultWaterSize = Workspace.water.Size

local defaultWaterPos = water.Position

local initialpos = part.Position + Vector3.new(0, 3, 0)
local missile = Workspace.Missile


local function rotateVector(vector, angle)
	local cos = math.cos(angle)
	local sin = math.sin(angle)
	return Vector3.new(vector.X * cos - vector.Z * sin, vector.Y, vector.X * sin + vector.Z * cos)
end

local counter = 0
local r = 2
local stepstoExecute = 3
local currentSteps = 0

local function cycle()
	local i, j = 0, 0

	local stepTheta = 10
	local stepPhi = 10
	
	RunService.Heartbeat:Connect(function(dt)
		
		currentSteps = currentSteps + 1
	

		local Players = game:GetService("Players")

		
			local closestPlayer = nil
			local shortestDistance = math.huge

			for _, player in ipairs(Players:GetPlayers()) do
				local character = player.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					local hrp = character.HumanoidRootPart
					local distance = (hrp.Position - missile.Position).Magnitude

					if distance < shortestDistance then
						shortestDistance = distance
						closestPlayer = player
					end
				end
			end
			
			if closestPlayer then
				local hrp = closestPlayer.Character.HumanoidRootPart
			
				
			local direction = (hrp.Position - missile.Position).Unit
			missile.CFrame = CFrame.lookAt(missile.Position, hrp.Position)
			if shortestDistance > 5 then
				
			
			end
			end
			
		
		
		
		if (currentSteps > stepstoExecute) then
			local vec = Vector3.new(math.random(0,1), 0, math.random(0, 1))
	
			water.Size = defaultWaterSize + vec
			currentSteps = 0
		end
		
	
		
		
		
		
		
		
		j += stepPhi * dt * 50

		if j >= 180 then
			j = 0
			i += stepTheta
		end

		if i >= 360 then
			i = 0
		end

		local theta = math.rad(i)
		local phi = math.rad(j)
		local r = 2

		part.Position = initialpos + Vector3.new(
			r * math.cos(theta) * math.sin(phi),
			r * math.cos(phi),
			r * math.sin(theta) * math.sin(phi)
		)
	end)
end
cycle()
