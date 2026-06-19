local DynamicsUtils = {}


local OBB= require(game.ReplicatedStorage.Lib.Physics.OBB)

type OBBCollider = OBB.OBBCollider


local PhysicalInstanceManager = require(game.ReplicatedStorage.Lib.Physics.PhysicalInstanceManager)

export type Transformable = PhysicalInstanceManager.Transformable

function DynamicsUtils.applyForce(instance : Transformable, force : Vector3, intensity : number, duration : number)
	
end

function DynamicsUtils.applyRelativeForce(instance : Transformable, force : Vector3, intensity : number, duration : number)
	
end

function DynamicsUtils.setGravityEnabled(instance : Transformable, enabled : boolean)
    
end

function DynamicsUtils.createOBB(instance : Transformable, size : Vector3) : OBBCollider | nil
    return nil
end

function DynamicsUtils.createAttachment(instance : Transformable)
    
end

function DynamicsUtils.createAttachmentWithOffset(instance : Transformable, offset : Vector3)
    
end

function DynamicsUtils.createAttachmentWithRelativeOffset(instance : Transformable, offset : Vector3)
    
end

function DynamicsUtils.getPartsInRadius(pos : Vector3, radius : number)
    
end

function DynamicsUtils.getPartsInCone(pos : Vector3, direction : Vector3, angle : number)
    
end







return DynamicsUtils
