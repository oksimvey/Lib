local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EasingManager = require(ReplicatedStorage.Lib.Math.EasingManager)
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

function CameraUtils.setCFrameEased(cam : Camera, cframe:CFrame, info : TweenInfo)
	EasingManager.easeCFrame(cam, cframe, info)
end

--CameraRotation

function CameraUtils.setRotation(cam : Camera, rotation : CFrame)
    cam.CFrame = CFrame.new(cam.CFrame.Position) * rotation
end

function CameraUtils.setRotationEased(cam : Camera, rotation : CFrame, info : TweenInfo)
    EasingManager.easeRotation(cam, rotation, info)
end

function CameraUtils.rotate(cam : Camera, rotation : CFrame)
    cam.CFrame = cam.CFrame * rotation
end

function CameraUtils.rotateEased(cam : Camera, rotation : CFrame, info : TweenInfo)
    EasingManager.easeRotation(cam, cam.CFrame * rotation, info)
end

function CameraUtils.rotateX(cam : Camera, angle : number)
	cam.CFrame = MathUtils.rotateGlobalX(cam.CFrame, angle)
end

function CameraUtils.rotateXEased(cam : Camera, angle : number, info : TweenInfo)
    EasingManager.easeRotation(cam, MathUtils.rotateGlobalX(cam.CFrame, angle), info)
end

function CameraUtils.rotateY(cam : Camera, angle : number)
	cam.CFrame = MathUtils.rotateGlobalY(cam.CFrame, angle)
end

function CameraUtils.rotateYEased(cam : Camera, angle : number, info : TweenInfo)
    EasingManager.easeRotation(cam, MathUtils.rotateGlobalY(cam.CFrame, angle), info)
end

function CameraUtils.rotateZ(cam : Camera, angle : number)
	cam.CFrame = MathUtils.rotateGlobalZ(cam.CFrame, angle)
end

function CameraUtils.rotateZEased(cam : Camera, angle : number, info : TweenInfo)
    EasingManager.easeRotation(cam, MathUtils.rotateGlobalZ(cam.CFrame, angle), info)
end

function CameraUtils.setRotationAngles(cam : Camera, angles : Vector3)
    local anglesAsCFrame = MathUtils.EulerAnglesToRotation(angles)
    cam.CFrame = CFrame.new(cam.CFrame.Position) * anglesAsCFrame
end

function CameraUtils.setRotationAnglesEased(cam : Camera, angles : Vector3, info : TweenInfo)
	EasingManager.easeRotationAngles(cam, angles, info)
end

function CameraUtils.addRotationAngles(cam : Camera, angles : Vector3)
   local originalangles : Vector3 = MathUtils.CFrameToEulerAngles(cam.CFrame)
    cam.CFrame = CFrame.new(cam.CFrame.Position) * MathUtils.EulerAnglesToRotation(originalangles + angles)
end

function CameraUtils.addRotationAnglesEased(cam : Camera, angles : Vector3, info : TweenInfo)
	
    local originalangles : Vector3 = MathUtils.CFrameToEulerAngles(cam.CFrame)
    
    EasingManager.easeRotationAngles(cam, angles + originalangles, info)
end



-- Camera Position

function CameraUtils.setPosition(cam : Camera, position : Vector3)
    cam.CFrame = CFrame.new(position) * cam.CFrame.Rotation
end

function CameraUtils.setPositionEased(cam : Camera, position : Vector3, info : TweenInfo)
    EasingManager.easePosition(cam, position, info)
end

function CameraUtils.incrementPosition(cam : Camera, increment : Vector3)
    cam.CFrame.Position += increment
end

function CameraUtils.incrementPositionEased(cam : Camera, increment : Vector3, info : TweenInfo)
    EasingManager.easePosition(cam, cam.CFrame.Position +  increment, info)
end

function CameraUtils.incrementPositionX(cam : Camera, increment : number)
    cam.CFrame.Position += Vector3.new(increment, 0, 0)
end

function CameraUtils.incrementPositionXEased(cam : Camera, increment : number, info : TweenInfo)
    EasingManager.easePosition(cam, cam.CFrame.Position + Vector3.new(increment, 0, 0), info)
end

function CameraUtils.incrementPositionY(cam : Camera, increment : number)
    cam.CFrame.Position += Vector3.new(0, increment, 0)
end

function CameraUtils.incrementPositionYEased(cam : Camera, increment : number, info : TweenInfo)
    EasingManager.easePosition(cam, cam.CFrame.Position + Vector3.new(0, increment, 0), info)
end

function CameraUtils.incrementPositionZ(cam : Camera, increment : number)
    cam.CFrame.Position += Vector3.new(0, 0, increment)
end

function CameraUtils.incrementPositionZEased(cam : Camera, increment : number, info : TweenInfo)
    EasingManager.easePosition(cam, cam.CFrame.Position + Vector3.new(0, 0, increment), info)
end

function CameraUtils.incrementRelativePosition(cam : Camera, increment : Vector3)
	cam.CFrame = cam.CFrame * CFrame.new(increment)
end

function CameraUtils.incrementRelativePositionEased(cam : Camera, increment : Vector3, info : TweenInfo)
	EasingManager.easeCFrame(cam, cam.CFrame * CFrame.new(increment), info)
end

function CameraUtils.incrementRelativePositionX(cam : Camera, increment : number)
	CameraUtils.incrementRelativePosition(cam, Vector3.new(increment, 0, 0))
end

function CameraUtils.incrementRelativePositionXEased(cam : Camera, increment : number, info : TweenInfo)
	CameraUtils.incrementRelativePositionEased(cam, Vector3.new(increment, 0, 0), info)
end

function CameraUtils.incrementRelativePositionY(cam : Camera, increment : number)
	CameraUtils.incrementRelativePosition(cam, Vector3.new(0, increment, 0))
end

function CameraUtils.incrementRelativePositionYEased(cam : Camera, increment : number, info : TweenInfo)
	CameraUtils.incrementRelativePositionEased(cam, Vector3.new(0, increment, 0), info)
end

function CameraUtils.incrementRelativePositionZ(cam : Camera, increment : number)
	CameraUtils.incrementRelativePosition(cam, Vector3.new(0, 0, increment))
end

function CameraUtils.incrementRelativePositionZEased(cam : Camera, increment : number, info : TweenInfo)
	CameraUtils.incrementRelativePositionEased(cam, Vector3.new(0, 0, increment), info)
end

return CameraUtils
