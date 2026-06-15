local MathUtils = {}

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

local function setPivot(obj: Transformable, cf: CFrame)
	if isModel(obj) then
		obj:PivotTo(cf)
	else
		obj.CFrame = cf
	end
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

local function setCFrameKeepPosition(obj: Transformable, rotationCf: CFrame)
	local position = getPosition(obj)
	setPivot(obj, CFrame.new(position) * rotationCf)
end

function MathUtils.setRotation(part: Transformable, rotation: Vector3)
	setCFrameKeepPosition(part, toRotationCFrame(rotation))
end

function MathUtils.setRotationX(part: Transformable, rotation: number)
	MathUtils.setRotation(part, Vector3.new(rotation, 0, 0))
end

function MathUtils.setRotationY(part: Transformable, rotation: number)
	MathUtils.setRotation(part, Vector3.new(0, rotation, 0))
end

function MathUtils.setRotationZ(part: Transformable, rotation: number)
	MathUtils.setRotation(part, Vector3.new(0, 0, rotation))
end

function MathUtils.rotate(part: Transformable, rotation: Vector3)
	local delta = toRotationCFrame(rotation)

	if isModel(part) then
		part:PivotTo(part:GetPivot() * delta)
	else
		part.CFrame = part.CFrame * delta
	end
end

function MathUtils.rotateX(part: Transformable, rotation: number)
	MathUtils.rotate(part, Vector3.new(rotation, 0, 0))
end

function MathUtils.rotateY(part: Transformable, rotation: number)
	MathUtils.rotate(part, Vector3.new(0, rotation, 0))
end

function MathUtils.rotateZ(part: Transformable, rotation: number)
	MathUtils.rotate(part, Vector3.new(0, 0, rotation))
end

function MathUtils.rotateVectorX(vector: Vector3, rotation: number)
	local angle = math.rad(rotation)
	local cosA = math.cos(angle)
	local sinA = math.sin(angle)

	return Vector3.new(
		vector.X,
		vector.Y * cosA - vector.Z * sinA,
		vector.Y * sinA + vector.Z * cosA
	)
end

function MathUtils.rotateVectorY(vector: Vector3, rotation: number)
	local angle = math.rad(rotation)
	local cosA = math.cos(angle)
	local sinA = math.sin(angle)

	return Vector3.new(
		vector.X * cosA + vector.Z * sinA,
		vector.Y,
		-vector.X * sinA + vector.Z * cosA
	)
end

function MathUtils.rotateVectorZ(vector: Vector3, rotation: number)
	local angle = math.rad(rotation)
	local cosA = math.cos(angle)
	local sinA = math.sin(angle)

	return Vector3.new(
		vector.X * cosA - vector.Y * sinA,
		vector.X * sinA + vector.Y * cosA,
		vector.Z
	)
end

function MathUtils.setPosition(part: Transformable, position: Vector3)
	local rotationCf = getRotationCFrame(part)
	setPivot(part, CFrame.new(position) * rotationCf)
end

function MathUtils.setPositionX(part: Transformable, position: number)
	local current = getPosition(part)
	MathUtils.setPosition(part, Vector3.new(position, current.Y, current.Z))
end

function MathUtils.setPositionY(part: Transformable, position: number)
	local current = getPosition(part)
	MathUtils.setPosition(part, Vector3.new(current.X, position, current.Z))
end

function MathUtils.setPositionZ(part: Transformable, position: number)
	local current = getPosition(part)
	MathUtils.setPosition(part, Vector3.new(current.X, current.Y, position))
end

function MathUtils.move(part: Transformable, offset: Vector3)
	MathUtils.setPosition(part, getPosition(part) + offset)
end

function MathUtils.moveX(part: Transformable, offset: number)
	MathUtils.move(part, Vector3.new(offset, 0, 0))
end

function MathUtils.moveY(part: Transformable, offset: number)
	MathUtils.move(part, Vector3.new(0, offset, 0))
end

function MathUtils.moveZ(part: Transformable, offset: number)
	MathUtils.move(part, Vector3.new(0, 0, offset))
end

function MathUtils.moveRelative(part: Transformable, offset: Vector3)
	local worldOffset = getRotationCFrame(part):VectorToWorldSpace(offset)
	MathUtils.move(part, worldOffset)
end

function MathUtils.moveRelativeX(part: Transformable, offset: number)
	MathUtils.moveRelative(part, Vector3.new(offset, 0, 0))
end

function MathUtils.moveRelativeY(part: Transformable, offset: number)
	MathUtils.moveRelative(part, Vector3.new(0, offset, 0))
end

function MathUtils.moveRelativeZ(part: Transformable, offset: number)
	MathUtils.moveRelative(part, Vector3.new(0, 0, offset))
end

return MathUtils