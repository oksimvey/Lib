const ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage") :: ReplicatedStorage
const TweenService: TweenService = game:GetService("TweenService") :: TweenService

const Lib: Folder = ReplicatedStorage:WaitForChild("Lib") :: Folder


local ClientPacketHandler = require(game.ReplicatedStorage.Lib.Network.ClientPacketHandler)
local PhysicalStateUtils = require(game.ReplicatedStorage.Lib.Physics.PhysicalStateUtils)

local CameraUtils = require(game.ReplicatedStorage.Lib.Camera.CameraUtils)

ClientPacketHandler.sendEvent("Test", 5)

local Players = game:GetService("Players")

local player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer

local camera : Camera= workspace.CurrentCamera or workspace:GetPropertyChangedSignal("CurrentCamera"):Wait() and workspace.CurrentCamera

player.CharacterAdded:Wait()

camera.CameraType = Enum.CameraType.Scriptable
camera.CameraSubject = nil

camera.CFrame = CFrame.new(0, 20, 0) * CFrame.fromEulerAngles(0, math.rad(-90), 0)


local targetCframe = CFrame.new(30, 10, 50) * CFrame.fromEulerAngles(0, math.rad(-60), 0)

local info : TweenInfo = TweenInfo.new(5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

local tween = TweenService:Create(camera, info, {CFrame = targetCframe})

tween:Play()

tween.Completed:Connect(
	function()
		task.wait(2.5)
		camera.CameraType = Enum.CameraType.Custom
	end
)



