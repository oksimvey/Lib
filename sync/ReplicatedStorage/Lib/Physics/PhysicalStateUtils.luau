local PhysicalStateUtils = {}

local TweenService = game:GetService("TweenService")


local EasingManager = require(game.ReplicatedStorage.Lib.Math.EasingManager)


local PhysicalInstanceManager = require(game.ReplicatedStorage.Lib.Physics.PhysicalInstanceManager)

export type Transformable = PhysicalInstanceManager.Transformable


-- State

export type PhysicalState = {
	acceleration : Vector3,
	velocity : Vector3
}


function PhysicalStateUtils.setCFrame(instance : Transformable, cframe : CFrame)
	PhysicalInstanceManager.setCFrame(instance, cframe)
end

function PhysicalStateUtils.setCFrameEased(instance : Transformable, cframe : CFrame, info : TweenInfo)
	EasingManager.easeCFrame(instance, cframe, info)
end

function PhysicalStateUtils.setPosition(instance : Transformable, pos : Vector3)

end

function PhysicalStateUtils.setPositionEased(instance : Transformable, pos : Vector3, info : TweenInfo)

end

function PhysicalStateUtils.setRotation(instance : Transformable, rot : Vector3)

end

function PhysicalStateUtils.setRotationEased(instance : Transformable, rot : Vector3, info : TweenInfo)

end

function PhysicalStateUtils.incrementPosition(instance : Transformable, increment : Vector3)

end

function PhysicalStateUtils.incrementPositionEased(instance : Transformable, increment : Vector3, info : TweenInfo)

end

function PhysicalStateUtils.incrementPositionX(instance : Transformable, increment : number)
	PhysicalStateUtils.incrementPosition(instance, Vector3.new(increment, 0, 0))
end

function PhysicalStateUtils.incrementPositionXEased(instance : Transformable, increment : number, info : TweenInfo)
	PhysicalStateUtils.incrementPositionEased(instance, Vector3.new(increment, 0, 0), info)
end

function PhysicalStateUtils.incrementPositionY(instance : Transformable, increment : number)
	PhysicalStateUtils.incrementPosition(instance, Vector3.new(0, increment, 0))
end

function PhysicalStateUtils.incrementPositionYEased(instance : Transformable, increment : number, info : TweenInfo)
	PhysicalStateUtils.incrementPositionEased(instance, Vector3.new(0, increment, 0), info)
end

function PhysicalStateUtils.incrementPositionZ(instance : Transformable, increment : number)
	PhysicalStateUtils.incrementPosition(instance, Vector3.new(0, 0, increment))
end

function PhysicalStateUtils.incrementPositionZEased(instance : Transformable, increment : number, info : TweenInfo)
	PhysicalStateUtils.incrementPositionEased(instance, Vector3.new(0, 0, increment), info)
end


function PhysicalStateUtils.rotate(instance : Transformable, rot : Vector3)

end

function PhysicalStateUtils.rotateEased(instance : Transformable, rot : Vector3, info : TweenInfo)

end

function PhysicalStateUtils.rotateX(instance : Transformable, rot : number)
	PhysicalStateUtils.rotate(instance, Vector3.new(rot, 0, 0))
end

function PhysicalStateUtils.rotateXEased(instance : Transformable, rot : number, info : TweenInfo)
	PhysicalStateUtils.rotateEased(instance, Vector3.new(rot, 0, 0), info)
end

function PhysicalStateUtils.rotateY(instance : Transformable, rot : number)
	PhysicalStateUtils.rotate(instance, Vector3.new(0, rot, 0))
end

function PhysicalStateUtils.rotateYEased(instance : Transformable, rot : number, info : TweenInfo)
	PhysicalStateUtils.rotateEased(instance, Vector3.new(0, rot, 0), info)
end

function PhysicalStateUtils.rotateZ(instance : Transformable, rot : number)
	PhysicalStateUtils.rotate(instance, Vector3.new(0, 0, rot))
end

function PhysicalStateUtils.rotateZEased(instance : Transformable, rot : number, info : TweenInfo)
	PhysicalStateUtils.rotateEased(instance, Vector3.new(0, 0, rot), info)
end

function PhysicalStateUtils.addPositionRelative(instance : Transformable, increment : Vector3)

end

function PhysicalStateUtils.addPositionRelativeEased(instance : Transformable, increment : Vector3, info : TweenInfo)

end

function PhysicalStateUtils.addPositionRelativeX(instance : Transformable, increment : number)
	PhysicalStateUtils.addPositionRelative(instance, Vector3.new(increment, 0, 0))
end

function PhysicalStateUtils.addPositionRelativeXEased(instance : Transformable, increment : number, info : TweenInfo)
	PhysicalStateUtils.addPositionRelativeEased(instance, Vector3.new(increment, 0, 0), info)
end

function PhysicalStateUtils.addPositionRelativeY(instance : Transformable, increment : number)
	PhysicalStateUtils.addPositionRelative(instance, Vector3.new(0, increment, 0))
end

function PhysicalStateUtils.addPositionRelativeYEased(instance : Transformable, increment : number, info : TweenInfo)
	PhysicalStateUtils.addPositionRelativeEased(instance, Vector3.new(0, increment, 0), info)
end

function PhysicalStateUtils.addPositionRelativeZ(instance : Transformable, increment : number)
	PhysicalStateUtils.addPositionRelative(instance, Vector3.new(0, 0, increment))
end

function PhysicalStateUtils.addPositionRelativeZEased(instance : Transformable, increment : number, info : TweenInfo)
	PhysicalStateUtils.addPositionRelativeEased(instance, Vector3.new(0, 0, increment), info)
end

function PhysicalStateUtils.getPosition(instance : Transformable)

end

function PhysicalStateUtils.getRotation(instance : Transformable)

end

function PhysicalStateUtils.getCFrame(instance : Transformable)

end

return PhysicalStateUtils
