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
	start: CFrame,
	goal: CFrame,
	info: TweenInfo
): Tween
	
	part:PivotTo(start) -- fix: snap to start immediately (handles DelayTime correctly)

	local task : (value : NumberValue) -> () = function(value : NumberValue)
		part:PivotTo(start:Lerp(goal, value.Value))
	end

	return EasingManager.createCustomTween(info, task)
end

function EasingManager.createCFrameTweenForPart(
	part: BasePart,
	start: CFrame,
	goal: CFrame,
	info: TweenInfo
): Tween
	part.CFrame = start -- fix: "start" was previously ignored; tween used part's current CFrame
	return TweenService:Create(part, info, {CFrame = goal})
end

--// Position-only tweens

function EasingManager.createPositionTweenForModel(
	part: Model,
	start: Vector3,
	goal: Vector3,
	info: TweenInfo
): Tween
	local rotation = part:GetPivot() - part:GetPivot().Position -- isolate rotation, zero translation
	part:PivotTo(CFrame.new(start) * rotation)
	
	local task : (value : NumberValue) -> () = function(value : NumberValue)
		part:PivotTo(CFrame.new(start:Lerp(goal, value.Value)) * rotation)
	end
	
	return EasingManager.createCustomTween(info, task)
end

function EasingManager.createPositionTweenForPart(
	part: BasePart,
	start: Vector3,
	goal: Vector3,
	info: TweenInfo
): Tween
	part.Position = start
	return TweenService:Create(part, info, {Position = goal})
end

--// Rotation-only tweens

-- start/goal should be rotation-only CFrames (e.g. CFrame.Angles(...)); any
-- position component on them is discarded, the model's current position is kept fixed.
function EasingManager.createRotationTweenForModel(
	part: Model,
	start: CFrame,
	goal: CFrame,
	info: TweenInfo
): Tween
	
	local position = part:GetPivot().Position
	part:PivotTo(start + position)

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
	start: CFrame,
	goal: CFrame,
	info: TweenInfo
): Tween
	return TweenService:Create(part, info, {Orientation = goal})
end


function EasingManager.easeCFrame(part : Transformable, goal : CFrame, info : TweenInfo)

	local start : CFrame

	local tween : Tween

	if part:IsA("Model") then

		start = part:GetPivot()
		tween = EasingManager.createCFrameTweenForModel(part, start, goal, info)

	else 
		start = part.CFrame
		tween = EasingManager.createCFrameTweenForPart(part, start, goal, info)

	end

	tween:Play()
end

function EasingManager.easePosition(part : Transformable, goal : Vector3, info : TweenInfo)
	
	local start : Vector3
	
	local tween : Tween
	
	if part:IsA("Model") then
		
		start = part:GetPivot().Position
		tween = EasingManager.createPositionTweenForModel(part, start, goal, info)
		
	else 
		start = part.Position
		tween = EasingManager.createPositionTweenForPart(part, start, goal, info)
		
	end
	
	tween:Play()
end

function EasingManager.easeRotation(part : Transformable, goal : CFrame, info : TweenInfo)

	local start : CFrame
	
	local tween : Tween
	
	if part:IsA("Model") then
		
		start = part:GetPivot().Rotation
		tween = EasingManager.createRotationTweenForModel(part, start, goal, info)
		
	else 
		start = part.CFrame.Rotation
		tween = EasingManager.createRotationTweenForPart(part, start, goal, info)
		
	end
	
	tween:Play()
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
