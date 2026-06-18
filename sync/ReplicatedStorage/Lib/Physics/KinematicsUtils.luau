local KinematicsUtils = {}

local PhysicalInstanceManager = require(game.ReplicatedStorage.Lib.Physics.PhysicalInstanceManager)

export type Transformable = PhysicalInstanceManager.Transformable



-- Kinematics

function KinematicsUtils.getVelocity(instance : Transformable)

end

function KinematicsUtils.getRelativeVelocity(instance : Transformable)

end

function KinematicsUtils.getAcceleration(instance : Transformable)

end

function KinematicsUtils.getRelativeAcceleration(instance : Transformable)

end

function KinematicsUtils.setSpeed(instance : Transformable, speed : Vector3)

end

function KinematicsUtils.setSpeedEased(instance : Transformable, speed : Vector3, info : TweenInfo)

end

function KinematicsUtils.setSpeedX(instance : Transformable, speed : number)

end

function KinematicsUtils.setSpeedXEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.setSpeedY(instance : Transformable, speed : number)

end

function KinematicsUtils.setSpeedYEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.setSpeedZ(instance : Transformable, speed : number)

end

function KinematicsUtils.setSpeedZEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.setRelativeSpeed(instance : Transformable, speed : Vector3)

end

function KinematicsUtils.setRelativeSpeedEased(instance : Transformable, speed : Vector3)

end

function KinematicsUtils.setRelativeSpeedX(instance : Transformable, speed : number)

end

function KinematicsUtils.setRelativeSpeedXEased(instance : Transformable, speed : number)

end

function KinematicsUtils.setRelativeSpeedY(instance : Transformable, speed : number)

end

function KinematicsUtils.setRelativeSpeedYEased(instance : Transformable, speed : number)

end

function KinematicsUtils.setRelativeSpeedZ(instance : Transformable, speed : number)

end

function KinematicsUtils.setRelativeSpeedZEased(instance : Transformable, speed : number)

end

function KinematicsUtils.addSpeed(instance : Transformable, speed : Vector3)

end

function KinematicsUtils.addSpeedEased(instance : Transformable, speed : Vector3, info : TweenInfo)

end

function KinematicsUtils.addSpeedX(instance : Transformable, speed : number)

end

function KinematicsUtils.addSpeedXEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addSpeedY(instance : Transformable, speed : number)

end

function KinematicsUtils.addSpeedYEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addSpeedZ(instance : Transformable, speed : number)

end

function KinematicsUtils.addSpeedZEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addRelativeSpeed(instance : Transformable, speed : Vector3)

end

function KinematicsUtils.addRelativeSpeedEased(instance : Transformable, speed : Vector3, info : TweenInfo)

end

function KinematicsUtils.addRelativeSpeedX(instance : Transformable, speed : number)

end

function KinematicsUtils.addRelativeSpeedXEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addRelativeSpeedY(instance : Transformable, speed : number)

end

function KinematicsUtils.addRelativeSpeedYEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addRelativeSpeedZ(instance : Transformable, speed : number)

end

function KinematicsUtils.addRelativeSpeedZEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.getSpeed(instance : Transformable)

end

function KinematicsUtils.getRelativeSpeed(instance : Transformable)

end

function KinematicsUtils.setAngularVelocity(instance : Transformable, speed : Vector3)

end

function KinematicsUtils.setAngularVelocityEased(instance : Transformable, speed : Vector3, info : TweenInfo)

end

function KinematicsUtils.setAngularVelocityX(instance : Transformable, speed : number)

end

function KinematicsUtils.setAngularVelocityXEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.setAngularVelocityY(instance : Transformable, speed : number)

end

function KinematicsUtils.setAngularVelocityYEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.setAngularVelocityZ(instance : Transformable, speed : number)

end

function KinematicsUtils.setAngularVelocityZEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addAngularVelocity(instance : Transformable, speed : Vector3)

end

function KinematicsUtils.addAngularVelocityEased(instance : Transformable, speed : Vector3, info : TweenInfo)

end

function KinematicsUtils.addAngularVelocityX(instance : Transformable, speed : number)

end

function KinematicsUtils.addAngularVelocityXEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addAngularVelocityY(instance : Transformable, speed : number)

end

function KinematicsUtils.addAngularVelocityYEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addAngularVelocityZ(instance : Transformable, speed : number)

end

function KinematicsUtils.addAngularVelocityZEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.getAngularVelocity(instance : Transformable)

end

function KinematicsUtils.getRelativeAngularVelocity(instance : Transformable)

end

function KinematicsUtils.setAcceleration(instance : Transformable, speed : Vector3)

end

function KinematicsUtils.setAccelerationEased(instance : Transformable, speed : Vector3, info : TweenInfo)

end

function KinematicsUtils.setAccelerationX(instance : Transformable, speed : number)

end

function KinematicsUtils.setAccelerationXEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.setAccelerationY(instance : Transformable, speed : number)

end

function KinematicsUtils.setAccelerationYEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.setAccelerationZ(instance : Transformable, speed : number)

end

function KinematicsUtils.setAccelerationZEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addAcceleration(instance : Transformable, speed : Vector3)

end

function KinematicsUtils.addAccelerationEased(instance : Transformable, speed : Vector3, info : TweenInfo)

end

function KinematicsUtils.addAccelerationX(instance : Transformable, speed : number)

end

function KinematicsUtils.addAccelerationXEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addAccelerationY(instance : Transformable, speed : number)

end

function KinematicsUtils.addAccelerationYEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.addAccelerationZ(instance : Transformable, speed : number)

end

function KinematicsUtils.addAccelerationZEased(instance : Transformable, speed : number, info : TweenInfo)

end

function KinematicsUtils.setRelativeAcceleration(instance : Transformable, speed : Vector3)

end

function KinematicsUtils.setRelativeAccelerationEased(instance : Transformable, speed : Vector3, info : TweenInfo)
	
end

function KinematicsUtils.setRelativeAccelerationX(instance : Transformable, speed : number)
	
end

function KinematicsUtils.setRelativeAccelerationXEased(instance : Transformable, speed : number, info : TweenInfo)
	
end

function KinematicsUtils.setRelativeAccelerationY(instance : Transformable, speed : number)
	
end

function KinematicsUtils.setRelativeAccelerationYEased(instance : Transformable, speed : number, info : TweenInfo)
	
end

function KinematicsUtils.setRelativeAccelerationZ(instance : Transformable, speed : number)
	
end

function KinematicsUtils.setRelativeAccelerationZEased(instance : Transformable, speed : number, info : TweenInfo)
	
end

function KinematicsUtils.addRelativeAcceleration(instance : Transformable, speed : Vector3)
	
end

function KinematicsUtils.addRelativeAccelerationEased(instance : Transformable, speed : Vector3, info : TweenInfo)
	
end

function KinematicsUtils.addRelativeAccelerationX(instance : Transformable, speed : number)
	
end

function KinematicsUtils.addRelativeAccelerationXEased(instance : Transformable, speed : number, info : TweenInfo)
	
end

function KinematicsUtils.addRelativeAccelerationY(instance : Transformable, speed : number)
	
end

function KinematicsUtils.addRelativeAccelerationYEased(instance : Transformable, speed : number, info : TweenInfo)
	
end

function KinematicsUtils.addRelativeAccelerationZ(instance : Transformable, speed : number)
	
end

function KinematicsUtils.addRelativeAccelerationZEased(instance : Transformable, speed : number, info : TweenInfo)
	
end






return KinematicsUtils
