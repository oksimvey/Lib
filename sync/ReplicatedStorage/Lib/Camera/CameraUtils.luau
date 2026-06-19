local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MathUtils = require(ReplicatedStorage.Lib.Math.MathUtils)
local CameraUtils = {}

function CameraUtils.getCameraCFrame(cam : Camera) : CFrame
    return cam.CFrame
end

function CameraUtils.getCameraRotation(cam : Camera) : CFrame
    return cam.CFrame.Rotation
end

function CameraUtils.getCameraRotationAngles(cam : Camera) : Vector3
    return MathUtils.cframeToEulerAngles(cam.CFrame)
end

function CameraUtils.getCameraPosition(cam : Camera) : Vector3
    return cam.CFrame.Position
end

function CameraUtils.setCameraCFrame(cam : Camera, cframe : CFrame)
    cam.CFrame = cframe
end

--CameraRotation

function CameraUtils.setRotation(cam : Camera, rotation : CFrame)
    cam.CFrame = CFrame.new(cam.CFrame.Position) * rotation
end

function CameraUtils.setRotationEased(cam : Camera, rotation : CFrame)
    
end

function CameraUtils.setRotationAngles(cam : Camera, angles : Vector3)
    local anglesAsCFrame = MathUtils.EulerAnglesToRotation(angles)
    cam.CFrame = CFrame.new(cam.CFrame.Position) * anglesAsCFrame
end



-- Camera Position

function CameraUtils.setPosition(cam : Camera, position : Vector3)
    cam.CFrame.Position = position
end

function CameraUtils.incrementPosition(cam : Camera, increment : Vector3)
    cam.CFrame.Position += increment
end





return CameraUtils
