local PhysicsUtils = {}

type Transformable = BasePart | Model

local function isModel(obj: Transformable): boolean
	return obj:IsA("Model")
end

local function getPivot(obj: Transformable): CFrame
	if isModel(obj) then
		return obj:GetPivot()
	end
	return obj.CFrame
end

local function getPosition(obj: Transformable): Vector3
	if isModel(obj) then
		return obj:GetPivot().Position
	end
	return obj.Position
end

local function getRotationCFrame(obj: Transformable): CFrame
	return getPivot(obj).Rotation
end

local function toRotationCFrame(rotation: Vector3): CFrame
	return CFrame.fromOrientation(
		math.rad(rotation.X),
		math.rad(rotation.Y),
		math.rad(rotation.Z)
	)
end

local function withRotationCf(position: Vector3, rotationCf: CFrame): CFrame
	return CFrame.new(position) * rotationCf
end

--// Builders puros
function PhysicsUtils.rotationCFrame(rotation: Vector3): CFrame
	return toRotationCFrame(rotation)
end

function PhysicsUtils.positionCFrame(position: Vector3): CFrame
	return CFrame.new(position)
end

function PhysicsUtils.targetCFrame(part: Transformable, position: Vector3?, rotation: Vector3?): CFrame
	local pos = position or getPosition(part)
	local rot = rotation and toRotationCFrame(rotation) or getRotationCFrame(part)
	return withRotationCf(pos, rot)
end

--// Rotação
function PhysicsUtils.setRotation(part: Transformable, rotation: Vector3): CFrame
	return withRotationCf(getPosition(part), toRotationCFrame(rotation))
end

function PhysicsUtils.setRotationX(part: Transformable, rotation: number): CFrame
	return PhysicsUtils.setRotation(part, Vector3.new(rotation, 0, 0))
end

function PhysicsUtils.setRotationY(part: Transformable, rotation: number): CFrame
	return PhysicsUtils.setRotation(part, Vector3.new(0, rotation, 0))
end

function PhysicsUtils.setRotationZ(part: Transformable, rotation: number): CFrame
	return PhysicsUtils.setRotation(part, Vector3.new(0, 0, rotation))
end

function PhysicsUtils.rotate(part: Transformable, rotation: Vector3): CFrame
	return getPivot(part) * toRotationCFrame(rotation)
end

function PhysicsUtils.rotateX(part: Transformable, rotation: number): CFrame
	return PhysicsUtils.rotate(part, Vector3.new(rotation, 0, 0))
end

function PhysicsUtils.rotateY(part: Transformable, rotation: number): CFrame
	return PhysicsUtils.rotate(part, Vector3.new(0, rotation, 0))
end

function PhysicsUtils.rotateZ(part: Transformable, rotation: number): CFrame
	return PhysicsUtils.rotate(part, Vector3.new(0, 0, rotation))
end

--// Posição
function PhysicsUtils.setPosition(part: Transformable, position: Vector3): CFrame
	return withRotationCf(position, getRotationCFrame(part))
end

function PhysicsUtils.setPositionX(part: Transformable, position: number): CFrame
	local current = getPosition(part)
	return PhysicsUtils.setPosition(part, Vector3.new(position, current.Y, current.Z))
end

function PhysicsUtils.setPositionY(part: Transformable, position: number): CFrame
	local current = getPosition(part)
	return PhysicsUtils.setPosition(part, Vector3.new(current.X, position, current.Z))
end

function PhysicsUtils.setPositionZ(part: Transformable, position: number): CFrame
	local current = getPosition(part)
	return PhysicsUtils.setPosition(part, Vector3.new(current.X, current.Y, position))
end

function PhysicsUtils.move(part: Transformable, offset: Vector3): CFrame
	return PhysicsUtils.setPosition(part, getPosition(part) + offset)
end

function PhysicsUtils.moveX(part: Transformable, offset: number): CFrame
	return PhysicsUtils.move(part, Vector3.new(offset, 0, 0))
end

function PhysicsUtils.moveY(part: Transformable, offset: number): CFrame
	return PhysicsUtils.move(part, Vector3.new(0, offset, 0))
end

function PhysicsUtils.moveZ(part: Transformable, offset: number): CFrame
	return PhysicsUtils.move(part, Vector3.new(0, 0, offset))
end

function PhysicsUtils.moveRelative(part: Transformable, offset: Vector3): CFrame
	local worldOffset = getRotationCFrame(part):VectorToWorldSpace(offset)
	return PhysicsUtils.move(part, worldOffset)
end

function PhysicsUtils.moveRelativeX(part: Transformable, offset: number): CFrame
	return PhysicsUtils.moveRelative(part, Vector3.new(offset, 0, 0))
end

function PhysicsUtils.moveRelativeY(part: Transformable, offset: number): CFrame
	return PhysicsUtils.moveRelative(part, Vector3.new(0, offset, 0))
end

function PhysicsUtils.moveRelativeZ(part: Transformable, offset: number): CFrame
	return PhysicsUtils.moveRelative(part, Vector3.new(0, 0, offset))
end

--// Alinhamento
function PhysicsUtils.alignPartToPart(anchor: Transformable, part: Transformable): CFrame
	return getPivot(anchor)
end

function PhysicsUtils.alignPartToPartWithOffset(anchor: Transformable, part: Transformable, offset: Vector3): CFrame
	return getPivot(anchor) * CFrame.new(offset)
end

--// OBB / queries
function PhysicsUtils.createOBBByPart(anchor: Transformable, aabb: BasePart): (CFrame, Vector3)
	return getPivot(anchor), aabb.Size
end

function PhysicsUtils.createOBBBySize(anchor: Transformable, sizeX: number, sizeY: number, sizeZ: number): (CFrame, Vector3)
	return getPivot(anchor), Vector3.new(sizeX, sizeY, sizeZ)
end

function PhysicsUtils.createOBBAutoSize(anchor: Transformable): (CFrame, Vector3)
	if isModel(anchor) then
		local cf, size = anchor:GetBoundingBox()
		return cf, size
	end
	return getPivot(anchor), (anchor :: BasePart).Size
end

function PhysicsUtils.getPartsInRadius(origin: Vector3, radius: number): {BasePart}
	local overlap = OverlapParams.new()
	overlap.FilterType = Enum.RaycastFilterType.Exclude
	return workspace:GetPartBoundsInRadius(origin, radius, overlap)
end


function PhysicsUtils.setSpeed(part: Transformable, speed: Vector3)
	
end

function PhysicsUtils.setSpeedX(part : Transformable, speed: number)
	PhysicsUtils.setSpeed(part, Vector3.new(speed, 0, 0))
end

function PhysicsUtils.setSpeedY(part : Transformable, speed: number)
	PhysicsUtils.setSpeed(part, Vector3.new(0, speed, 0))
end

function PhysicsUtils.setSpeedZ(part : Transformable, speed: number)
	PhysicsUtils.setSpeed(part, Vector3.new(0, 0, speed))
end

function PhysicsUtils.setRelativeSpeed(part: Transformable, speed: Vector3)
	
end

function PhysicsUtils.setRelativeSpeedX(part: Transformable, speed: number)
	PhysicsUtils.setRelativeSpeed(part, Vector3.new(speed, 0, 0))
end

function PhysicsUtils.setRelativeSpeedY(part: Transformable, speed: number)
	PhysicsUtils.setRelativeSpeed(part, Vector3.new(0, speed, 0))
end

function PhysicsUtils.setRelativeSpeedZ(part: Transformable, speed: number)
	PhysicsUtils.setRelativeSpeed(part, Vector3.new(0, 0, speed))
end

function PhysicsUtils.addSpeed(part: Transformable, speed: Vector3)
	

end

function PhysicsUtils.addSpeedX(part: Transformable, speed: number)
	PhysicsUtils.addSpeed(part, Vector3.new(speed, 0, 0))
end

function PhysicsUtils.addSpeedY(part: Transformable, speed: number)
	PhysicsUtils.addSpeed(part, Vector3.new(0, speed, 0))
end

function PhysicsUtils.addSpeedZ(part: Transformable, speed: number)
	PhysicsUtils.addSpeed(part, Vector3.new(0, 0, speed))
end

function PhysicsUtils.addRelativeSpeed(part: Transformable, speed: Vector3)
	
end

function PhysicsUtils.addRelativeSpeedX(part: Transformable, speed: number)
	PhysicsUtils.addRelativeSpeed(part, Vector3.new(speed, 0, 0))
end

function PhysicsUtils.addRelativeSpeedY(part: Transformable, speed: number)
	PhysicsUtils.addRelativeSpeed(part, Vector3.new(0, speed, 0))
end

function PhysicsUtils.addRelativeSpeedZ(part: Transformable, speed: number)
	PhysicsUtils.addRelativeSpeed(part, Vector3.new(0, 0, speed))
end

function PhysicsUtils.setAcceleration(part: Transformable, speed : Vector3)
	
end

function PhysicsUtils.setAccelerationX(part: Transformable, speed: number)
	PhysicsUtils.setAcceleration(part, Vector3.new(speed, 0, 0))
end

function PhysicsUtils.setAccelerationY(part: Transformable, speed: number)
	PhysicsUtils.setAcceleration(part, Vector3.new(0, speed, 0))
end

function PhysicsUtils.setAccelerationZ(part: Transformable, speed: number)
	PhysicsUtils.setAcceleration(part, Vector3.new(0, 0, speed))
end

function PhysicsUtils.setRelativeAcceleration(part: Transformable, speed: Vector3)
	
end

function PhysicsUtils.setRelativeAccelerationX(part: Transformable, speed: number)
	PhysicsUtils.setRelativeAcceleration(part, Vector3.new(speed, 0, 0))
end

function PhysicsUtils.setRelativeAccelerationY(part: Transformable, speed: number)
	PhysicsUtils.setRelativeAcceleration(part, Vector3.new(0, speed, 0))
end

function PhysicsUtils.setRelativeAccelerationZ(part: Transformable, speed: number)
	PhysicsUtils.setRelativeAcceleration(part, Vector3.new(0, 0, speed))
end


return PhysicsUtils

