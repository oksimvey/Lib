local TweenService = game:GetService("TweenService")

local PhysicsUtils = require(game.ReplicatedStorage.Lib.Physics.PhysicsUtils)

local player = game.Players:WaitForChild("MonkeyD_Robson")

local char = player.Character or player.CharacterAdded:Wait()

for _, obj in ipairs(char:GetDescendants()) do
	if obj:IsA("BasePart") then
		obj.Anchored = true
	end
end

local info = TweenInfo.new(
	10,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.InOut
)




char:PivotTo(PhysicsUtils.rotateX(char, 90))



local start = char:GetPivot()

local goal = PhysicsUtils.moveRelativeY(char, -100)

local value = Instance.new("NumberValue")

local tween = TweenService:Create(
	value,
	info,
	{Value = 1}
)

value:GetPropertyChangedSignal("Value"):Connect(function()
	char:PivotTo(start:Lerp(goal, value.Value))
end)

tween:Play()

