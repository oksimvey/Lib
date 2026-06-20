local MathUtils = {}

--// Localized builtins
local abs = math.abs
local acos = math.acos
local clamp = math.clamp
local cos = math.cos
local sin = math.sin
local sqrt = math.sqrt
local rad = math.rad
local deg = math.deg

--// Constants
local EPSILON = 1e-8
local EPSILON_SQ = EPSILON * EPSILON

local ZERO = Vector3.zero

--// Internal helpers

-- Returns true when a number is close enough to zero to be treated as zero.
function isNearlyZero(value: number): boolean
	return abs(value) < EPSILON
end

-- Returns a normalized vector, or Vector3.zero if the vector is too small.
local function safeNormalize(v: Vector3): Vector3
	local magSq = v:Dot(v)
	if magSq < EPSILON_SQ then
		return ZERO
	end

	return v / sqrt(magSq)
end

-- Clamps a dot product into the valid acos range [-1, 1].
local function clampDot(dot: number): number
	return clamp(dot, -1, 1)
end

-- Rotates a vector around a normalized axis using Rodrigues' rotation formula.
local function rotateVectorAroundUnitAxis(vector: Vector3, axisUnit: Vector3, angleRad: number): Vector3
	local c = cos(angleRad)
	local s = sin(angleRad)

	local dot = vector:Dot(axisUnit)
	local cross = axisUnit:Cross(vector)

	return vector * c + cross * s + axisUnit * (dot * (1 - c))
end

--// Vector rotation

-- Rotates a vector around any axis by an angle in degrees.
function MathUtils.rotateVectorAroundAxis(vector: Vector3, axis: Vector3, angleDeg: number): Vector3
	local axisUnit = safeNormalize(axis)
	if axisUnit == ZERO then
		return vector
	end

	return rotateVectorAroundUnitAxis(vector, axisUnit, rad(angleDeg))
end

-- Rotates a vector around the X axis by an angle in degrees.
function MathUtils.rotateVectorAroundX(vector: Vector3, angleDeg: number): Vector3
	local a = rad(angleDeg)
	local c = cos(a)
	local s = sin(a)

	local y = vector.Y * c - vector.Z * s
	local z = vector.Y * s + vector.Z * c

	return Vector3.new(vector.X, y, z)
end

-- Rotates a vector around the Y axis by an angle in degrees.
function MathUtils.rotateVectorAroundY(vector: Vector3, angleDeg: number): Vector3
	local a = rad(angleDeg)
	local c = cos(a)
	local s = sin(a)

	local x = vector.X * c + vector.Z * s
	local z = -vector.X * s + vector.Z * c

	return Vector3.new(x, vector.Y, z)
end

-- Rotates a vector around the Z axis by an angle in degrees.
function MathUtils.rotateVectorAroundZ(vector: Vector3, angleDeg: number): Vector3
	local a = rad(angleDeg)
	local c = cos(a)
	local s = sin(a)

	local x = vector.X * c - vector.Y * s
	local y = vector.X * s + vector.Y * c

	return Vector3.new(x, y, vector.Z)
end

--// Euler / CFrame rotation

-- Converts a CFrame orientation into Euler angles in degrees.
function MathUtils.cframeToEulerAngles(cframe: CFrame): Vector3
	local x, y, z = cframe:ToOrientation()
	return Vector3.new(deg(x), deg(y), deg(z))
end

-- Builds a CFrame from Euler angles in degrees.
function MathUtils.eulerAnglesToCFrame(euler: Vector3): CFrame
	return CFrame.fromOrientation(
		rad(euler.X),
		rad(euler.Y),
		rad(euler.Z)
	)
end

-- Applies a local rotation to a CFrame.
function MathUtils.rotateCFrameLocal(cframe: CFrame, rotation: Vector3): CFrame
	return cframe * CFrame.fromOrientation(rad(rotation.X), rad(rotation.Y), rad(rotation.Z))
end

-- Applies a global/world-space rotation to a CFrame.
function MathUtils.rotateCFrameGlobal(cframe: CFrame, rotation: Vector3): CFrame
	return CFrame.fromOrientation(rad(rotation.X), rad(rotation.Y), rad(rotation.Z)) * cframe
end

-- Rotates a CFrame around a local axis by an angle in degrees.
function MathUtils.rotateCFrameLocalAxis(cframe: CFrame, axis: Vector3, angleDeg: number): CFrame
	local axisUnit = safeNormalize(axis)
	if axisUnit == ZERO then
		return cframe
	end

	return cframe * CFrame.fromAxisAngle(axisUnit, rad(angleDeg))
end

-- Rotates a CFrame around a world axis by an angle in degrees.
function MathUtils.rotateCFrameGlobalAxis(cframe: CFrame, axis: Vector3, angleDeg: number): CFrame
	local axisUnit = safeNormalize(axis)
	if axisUnit == ZERO then
		return cframe
	end

	return CFrame.fromAxisAngle(axisUnit, rad(angleDeg)) * cframe
end

-- Applies a local X-axis rotation to a CFrame.
function MathUtils.rotateCFrameLocalX(cframe: CFrame, angleDeg: number): CFrame
	return cframe * CFrame.Angles(rad(angleDeg), 0, 0)
end

-- Applies a local Y-axis rotation to a CFrame.
function MathUtils.rotateCFrameLocalY(cframe: CFrame, angleDeg: number): CFrame
	return cframe * CFrame.Angles(0, rad(angleDeg), 0)
end

-- Applies a local Z-axis rotation to a CFrame.
function MathUtils.rotateCFrameLocalZ(cframe: CFrame, angleDeg: number): CFrame
	return cframe * CFrame.Angles(0, 0, rad(angleDeg))
end

-- Applies a world-space X-axis rotation to a CFrame.
function MathUtils.rotateCFrameGlobalX(cframe: CFrame, angleDeg: number): CFrame
	return CFrame.Angles(rad(angleDeg), 0, 0) * cframe
end

-- Applies a world-space Y-axis rotation to a CFrame.
function MathUtils.rotateCFrameGlobalY(cframe: CFrame, angleDeg: number): CFrame
	return CFrame.Angles(0, rad(angleDeg), 0) * cframe
end

-- Applies a world-space Z-axis rotation to a CFrame.
function MathUtils.rotateCFrameGlobalZ(cframe: CFrame, angleDeg: number): CFrame
	return CFrame.Angles(0, 0, rad(angleDeg)) * cframe
end

function MathUtils.CFrameFromPosAndRot(pos : Vector3, rot : Vector3)
	return CFrame.new(pos) * CFrame.fromOrientation(rad(rot.X), rad(rot.Y), rad(rot.Z))
end

function MathUtils.CFrameFromPosAndRotNumber(x : number, y : number, z : number, pitch : number, yaw : number, roll : number)
	return CFrame.new(x, y, z) * CFrame.fromOrientation(rad(pitch), rad(yaw), rad(roll))
end

--// Vector math

-- Returns the distance between two points.
function MathUtils.distanceBetween(a: Vector3, b: Vector3): number
	return (a - b).Magnitude
end

-- Returns the angle between two vectors in radians.
function MathUtils.angleBetweenRadians(a: Vector3, b: Vector3): number
	local aMagSq = a:Dot(a)
	local bMagSq = b:Dot(b)
	local magSq = aMagSq * bMagSq

	if magSq < EPSILON_SQ then
		return 0
	end

	return acos(clampDot(a:Dot(b) / sqrt(magSq)))
end

-- Returns the angle between two vectors in degrees.
function MathUtils.angleBetweenDegrees(a: Vector3, b: Vector3): number
	return deg(MathUtils.angleBetweenRadians(a, b))
end

-- Returns a normalized direction from source to target.
function MathUtils.directionTo(source: Vector3, target: Vector3): Vector3
	local delta = target - source
	local magSq = delta:Dot(delta)

	if magSq < EPSILON_SQ then
		return ZERO
	end

	return delta / sqrt(magSq)
end

-- Projects vector v onto another vector.
function MathUtils.project(v: Vector3, onto: Vector3): Vector3
	local denom = onto:Dot(onto)
	if denom < EPSILON_SQ then
		return ZERO
	end

	return onto * (v:Dot(onto) / denom)
end

-- Returns the rejection component of v relative to onto.
function MathUtils.reject(v: Vector3, onto: Vector3): Vector3
	local denom = onto:Dot(onto)
	if denom < EPSILON_SQ then
		return v
	end

	return v - onto * (v:Dot(onto) / denom)
end

-- Reflects a vector across a normal.
function MathUtils.reflect(v: Vector3, normal: Vector3): Vector3
	return v - 2 * v:Dot(normal) * normal
end

-- Removes the component of a vector along a normal, flattening it onto the plane.
function MathUtils.flatten(v: Vector3, normal: Vector3): Vector3
	return v - normal * v:Dot(normal)
end

--// CFrame helpers

-- Creates a look-at CFrame while keeping the Y coordinate flat.
function MathUtils.lookAtFlat(from: Vector3, to: Vector3): CFrame
	return CFrame.lookAt(from, Vector3.new(to.X, from.Y, to.Z))
end

-- Rotates a point around a pivot using a CFrame rotation.
function MathUtils.rotatePointAroundPivot(position: Vector3, pivot: Vector3, rotation: CFrame): Vector3
	return pivot + rotation:VectorToWorldSpace(position - pivot)
end

-- Returns the relative rotation of b in a's object space.
function MathUtils.relativeRotation(a: CFrame, b: CFrame): CFrame
	return a:ToObjectSpace(b)
end

-- Returns the forward/look vector of a CFrame.
function MathUtils.forwardVector(cframe: CFrame): Vector3
	return cframe.LookVector
end

-- Returns the right vector of a CFrame.
function MathUtils.rightVector(cframe: CFrame): Vector3
	return cframe.RightVector
end

-- Returns the up vector of a CFrame.
function MathUtils.upVector(cframe: CFrame): Vector3
	return cframe.UpVector
end

-- Replaces only the position of a CFrame, keeping its rotation.
function MathUtils.withPosition(cframe: CFrame, position: Vector3): CFrame
	return CFrame.new(position) * (cframe - cframe.Position)
end

-- Replaces only the rotation of a CFrame, keeping its position.
function MathUtils.withRotation(cframe: CFrame, rotation: CFrame): CFrame
	return CFrame.new(cframe.Position) * rotation
end

--// Geometry

-- Returns the closest point on a segment AB to a given point.
function MathUtils.closestPointOnSegment(point: Vector3, a: Vector3, b: Vector3): Vector3
	local ab = b - a
	local abLenSq = ab:Dot(ab)

	if abLenSq < EPSILON_SQ then
		return a
	end

	local t = (point - a):Dot(ab) / abLenSq
	t = clamp(t, 0, 1)

	return a + ab * t
end

-- Returns the closest point on an infinite line to a point.
function MathUtils.closestPointOnLine(point: Vector3, linePoint: Vector3, lineDir: Vector3): Vector3
	local denom = lineDir:Dot(lineDir)
	if denom < EPSILON_SQ then
		return linePoint
	end

	local t = (point - linePoint):Dot(lineDir) / denom
	return linePoint + lineDir * t
end

-- Returns the closest point on a plane to a point.
-- Assumes the normal is normalized for best performance.
function MathUtils.closestPointOnPlane(point: Vector3, planePoint: Vector3, normal: Vector3): Vector3
	return point - normal * ((point - planePoint):Dot(normal))
end

-- Finds the intersection between a line and a plane.
-- Returns nil when the line is parallel to the plane.
function MathUtils.linePlaneIntersection(
	linePoint: Vector3,
	lineDir: Vector3,
	planePoint: Vector3,
	normal: Vector3
): Vector3?
	local denom = lineDir:Dot(normal)
	if abs(denom) < EPSILON then
		return nil
	end

	local t = (planePoint - linePoint):Dot(normal) / denom
	return linePoint + lineDir * t
end

--// Mapping / interpolation

-- Returns the normalized position of value between a and b.
function MathUtils.inverseLerp(a: number, b: number, value: number): number
	local denom = b - a
	if abs(denom) < EPSILON then
		return 0
	end

	return (value - a) / denom
end

-- Remaps a value from one range to another.
function MathUtils.remap(
	value: number,
	inMin: number,
	inMax: number,
	outMin: number,
	outMax: number
): number
	local denom = inMax - inMin
	if abs(denom) < EPSILON then
		return outMin
	end

	local t = (value - inMin) / denom
	return outMin + (outMax - outMin) * t
end

-- Smooths a value in the range [0, 1] using the smoothstep curve.
function MathUtils.smoothStep(t: number): number
	t = clamp(t, 0, 1)
	return t * t * (3 - 2 * t)
end

-- Smooths a value in the range [0, 1] using the smootherstep curve.
function MathUtils.smootherStep(t: number): number
	t = clamp(t, 0, 1)
	return t * t * t * (t * (t * 6 - 15) + 10)
end

--// Backward-compatible aliases

-- Legacy alias for rotateVectorAroundAxis.
MathUtils.rotateVectorAxis = MathUtils.rotateVectorAroundAxis
-- Legacy alias for rotateVectorAroundX.
MathUtils.rotateVectorX = MathUtils.rotateVectorAroundX
-- Legacy alias for rotateVectorAroundY.
MathUtils.rotateVectorY = MathUtils.rotateVectorAroundY
-- Legacy alias for rotateVectorAroundZ.
MathUtils.rotateVectorZ = MathUtils.rotateVectorAroundZ

-- Legacy alias for cframeToEulerAngles.
MathUtils.CFrameToEulerAngles = MathUtils.cframeToEulerAngles
-- Legacy alias for eulerAnglesToCFrame.
MathUtils.EulerAnglesToRotation = MathUtils.eulerAnglesToCFrame

-- Legacy aliases for local/global CFrame rotation helpers.
MathUtils.rotateLocal = MathUtils.rotateCFrameLocal
MathUtils.rotateGlobal = MathUtils.rotateCFrameGlobal
MathUtils.rotateLocalAxis = MathUtils.rotateCFrameLocalAxis
MathUtils.rotateGlobalAxis = MathUtils.rotateCFrameGlobalAxis
MathUtils.rotateLocalX = MathUtils.rotateCFrameLocalX
MathUtils.rotateLocalY = MathUtils.rotateCFrameLocalY
MathUtils.rotateLocalZ = MathUtils.rotateCFrameLocalZ
MathUtils.rotateGlobalX = MathUtils.rotateCFrameGlobalX
MathUtils.rotateGlobalY = MathUtils.rotateCFrameGlobalY
MathUtils.rotateGlobalZ = MathUtils.rotateCFrameGlobalZ

-- Legacy aliases for vector math helpers.
MathUtils.distanceTo = MathUtils.distanceBetween
MathUtils.angleBetweenRad = MathUtils.angleBetweenRadians
MathUtils.angleBetweenDeg = MathUtils.angleBetweenDegrees
MathUtils.pointingTo = MathUtils.directionTo

-- Legacy aliases for CFrame helper names.
MathUtils.rotateAround = MathUtils.rotatePointAroundPivot
MathUtils.deltaRotation = MathUtils.relativeRotation
MathUtils.getForward = MathUtils.forwardVector
MathUtils.getRight = MathUtils.rightVector
MathUtils.getUp = MathUtils.upVector

return MathUtils