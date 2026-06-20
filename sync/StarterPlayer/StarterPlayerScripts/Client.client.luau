const ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage") :: ReplicatedStorage
const TweenService: TweenService = game:GetService("TweenService") :: TweenService

local CameraUtils = require(game.ReplicatedStorage.Lib.Camera.CameraUtils)

local MathUtils = require(game.ReplicatedStorage.Lib.Math.MathUtils)


local Players = game:GetService("Players")

local player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() and Players.LocalPlayer


local camera : Camera= workspace.CurrentCamera or workspace:GetPropertyChangedSignal("CurrentCamera"):Wait() and workspace.CurrentCamera

player.CharacterAdded:Wait()


camera.CameraType = Enum.CameraType.Scriptable
camera.CameraSubject = nil


local CameraUtils = require(game.ReplicatedStorage.Lib.Camera.CameraUtils)

CameraUtils.setPosition(camera, Vector3.new(-60, 0, 0))

CameraUtils.setRotationAngles(camera, Vector3.new(0, 0, 0))

local info = TweenInfo.new(10, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

local targetcframe = MathUtils.CFrameFromPosAndRotNumber(60, 0, 0, 0, 90, 0)

CameraUtils.setCFrameEased(camera, targetcframe, info)