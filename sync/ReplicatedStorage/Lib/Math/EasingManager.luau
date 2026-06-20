const MathUtils = require("./MathUtils")

local EasingManager = {}

local TweenService = game:GetService("TweenService")

local PhysicalInstanceManager = require(game.ReplicatedStorage.Lib.Physics.PhysicalInstanceManager)

type Transformable =  PhysicalInstanceManager.Transformable


export type EaseTask = (value : NumberValue) -> ()


function EasingManager.createCustomTween(info : TweenInfo, task : EaseTask) : Tween

	local value = Instance.new("NumberValue")
	local tween = TweenService:Create(value, info, {Value = 1})

	local connection
	connection = value:GetPropertyChangedSignal("Value"):Connect(function()
		task(value)
	end)

	tween.Completed:Connect(function()
		if connection then
			connection:Disconnect()
		end
		value:Destroy()
	end)

	return tween
end

-- Assumes TweenService is already required elsewhere in your module.
-- Uncomment if this file is standalone:
-- local TweenService = game:GetService("TweenService")

--// CFrame tweens

function EasingManager.createCFrameTweenForModel(
	part: Model,
	goal: CFrame,
	info: TweenInfo
): Tween

	local start = part:GetPivot() -- fix: was missing "start" initialization

	local task : (value : NumberValue) -> () = function(value : NumberValue)
		part:PivotTo(start:Lerp(goal, value.Value))
	end

	return EasingManager.createCustomTween(info, task)
end

function EasingManager.createCFrameTweenForPart(
	part: BasePart,
	goal: CFrame,
	info: TweenInfo
): Tween
	return TweenService:Create(part, info, {CFrame = goal})
end

function EasingManager.createCFrameTweenForCamera(
	camera: Camera,
	goal: CFrame,
	info: TweenInfo
): Tween
	return TweenService:Create(camera, info, {CFrame = goal})
end




--// Position-only tweens

function EasingManager.createPositionTweenForModel(
	part: Model,
	goal: Vector3,
	info: TweenInfo
): Tween
	local rotation = part:GetPivot() - part:GetPivot().Position -- isolate rotation, zero translation
	local start = part:GetPivot().Position -- keep the model's current position

	local task : (value : NumberValue) -> () = function(value : NumberValue)
		part:PivotTo(CFrame.new(start:Lerp(goal, value.Value)) * rotation)
	end

	return EasingManager.createCustomTween(info, task)
end

function EasingManager.createPositionTweenForPart(
	part: BasePart,
	goal: Vector3,
	info: TweenInfo
): Tween
	return TweenService:Create(part, info, {Position = goal})
end

function EasingManager.createPositionTweenForCamera(
	camera: Camera,
	goal: Vector3,
	info: TweenInfo
): Tween
	
	return TweenService:Create(
		camera,
		info,
		{ CFrame = CFrame.new(goal) * camera.CFrame.Rotation}
	)
end


--// Rotation-only tweens

-- start/goal should be rotation-only CFrames (e.g. CFrame.Angles(...)); any
-- position component on them is discarded, the model's current position is kept fixed.
function EasingManager.createRotationTweenForModel(
	part: Model,
	goal: CFrame,
	info: TweenInfo
): Tween


	local position = part:GetPivot().Position

	local start = part:GetPivot() - position -- zero out the position component, keep rotation

	local value = Instance.new("NumberValue")
	local tween = TweenService:Create(value, info, {Value = 1})

	local connection
	connection = value:GetPropertyChangedSignal("Value"):Connect(function()
		part:PivotTo(start:Lerp(goal, value.Value) + position)
	end)

	tween.Completed:Connect(function()
		if connection then
			connection:Disconnect()
		end
		value:Destroy()
	end)

	return tween
end

-- start/goal are Euler angles in degrees (matches BasePart.Orientation).
function EasingManager.createRotationTweenForPart(
	part: BasePart,
	goal: CFrame,
	info: TweenInfo
): Tween
	return TweenService:Create(part, info, {Orientation = goal})
end

function EasingManager.createRotationTweenForCamera(
	camera: Camera,
	goal: CFrame,
	info: TweenInfo
): Tween

	return TweenService:Create(camera, info, {CFrame = CFrame.new(camera.CFrame.Position) * goal})
end


function EasingManager.easeCFrame(part : Transformable | Camera, goal : CFrame, info : TweenInfo)

	local tween : Tween

	if part:IsA("Model") then

		tween = EasingManager.createCFrameTweenForModel(part,  goal, info)

	elseif part:IsA("BasePart") then

		tween = EasingManager.createCFrameTweenForPart(part, goal, info)

	elseif part:IsA("Camera") then

			tween = EasingManager.createCFrameTweenForCamera(part, goal, info)

			if part.CameraType ~= Enum.CameraType.Scriptable then

				local origtype = part.CameraType
				part.CameraType = Enum.CameraType.Scriptable
				tween.Completed:Once(function()
					part.CameraType = origtype
				end)

			end

	end

	tween:Play()
end

function EasingManager.easePosition(part : Transformable | Camera, goal : Vector3, info : TweenInfo)

		local tween : Tween

		if part:IsA("Model") then

			tween = EasingManager.createPositionTweenForModel(part, goal, info)

		elseif part:IsA("BasePart") then

			tween = EasingManager.createPositionTweenForPart(part, goal, info)

		elseif part:IsA("Camera") then

			tween = EasingManager.createPositionTweenForCamera(part, goal, info)

			if part.CameraType ~= Enum.CameraType.Scriptable then

				local origtype = part.CameraType
				part.CameraType = Enum.CameraType.Scriptable
				tween.Completed:Once(function()
					part.CameraType = origtype
				end)

			end

		end

		tween:Play()
end

function EasingManager.easeRotation(part : Transformable | Camera, goal : CFrame, info : TweenInfo)

		local tween : Tween

		if part:IsA("Model") then

			tween = EasingManager.createRotationTweenForModel(part,goal, info)

		elseif part:IsA("BasePart") then

			tween = EasingManager.createRotationTweenForPart(part, goal, info)

		elseif part:IsA("Camera") then

			tween = EasingManager.createRotationTweenForCamera(part, goal, info)

			if part.CameraType ~= Enum.CameraType.Scriptable then

				local origtype = part.CameraType
				part.CameraType = Enum.CameraType.Scriptable
				tween.Completed:Once(function()
					part.CameraType = origtype
				end)

			end

		end

		tween:Play()
end

function EasingManager.easeRotationAngles(part : Transformable | Camera, goal : Vector3, info : TweenInfo)
		EasingManager.easeRotation(
			part,
			MathUtils.eulerAnglesToCFrame(goal),
			info
		)
end

function EasingManager.EaseScale(part : Transformable, goal : Vector3, info : TweenInfo)

end

function EasingManager.EaseSpeed(part : Transformable, goal : Vector3, info : TweenInfo)

end

function EasingManager.EaseAcceleration(part : Transformable, goal : Vector3, info : TweenInfo)

end

function EasingManager.EaseTransparency(part : BasePart, goal : number, info : TweenInfo)

end

function EasingManager.EaseColor(part : BasePart, goal : Color3, info : TweenInfo)

end


return EasingManager
