local MathUtils = {}

function MathUtils.rotateVectorX(vector: Vector3, rotation: number) : Vector3
	local angle = math.rad(rotation)
	local cosA = math.cos(angle)
	local sinA = math.sin(angle)

	return Vector3.new(
		vector.X,
		vector.Y * cosA - vector.Z * sinA,
		vector.Y * sinA + vector.Z * cosA
	)
end

function MathUtils.rotateVectorY(vector: Vector3, rotation: number) : Vector3
	local angle = math.rad(rotation)
	local cosA = math.cos(angle)
	local sinA = math.sin(angle)

	return Vector3.new(
		vector.X * cosA + vector.Z * sinA,
		vector.Y,
		-vector.X * sinA + vector.Z * cosA
	)
end

function MathUtils.rotateVectorZ(vector: Vector3, rotation: number) : Vector3
	local angle = math.rad(rotation)
	local cosA = math.cos(angle)
	local sinA = math.sin(angle)

	return Vector3.new(
		vector.X * cosA - vector.Y * sinA,
		vector.X * sinA + vector.Y * cosA,
		vector.Z
	)
end

function MathUtils.CFrameToEulerAngles(cframe: CFrame): Vector3
	local x, y, z = cframe:ToOrientation()

	return Vector3.new(
		math.deg(x),
		math.deg(y),
		math.deg(z)
	)
end

function MathUtils.EulerAnglesToRotation(euler: Vector3): CFrame
	return CFrame.fromOrientation(
		math.rad(euler.X),
		math.rad(euler.Y),
		math.rad(euler.Z)
	)
end

function MathUtils.rotateLocal(
	cframe: CFrame,
	rotation: Vector3
): CFrame
	return cframe * MathUtils.EulerAnglesToRotation(rotation)
end

function MathUtils.rotateGlobal(
	cframe: CFrame,
	rotation: Vector3
): CFrame
	return MathUtils.EulerAnglesToRotation(rotation) * cframe
end


local AXIS = {
	X = Vector3.xAxis,
	Y = Vector3.yAxis,
	Z = Vector3.zAxis
}

function MathUtils.rotateLocalAxis(
	cframe: CFrame,
	axis: Vector3,
	angle: number
): CFrame
	return cframe * CFrame.fromAxisAngle(
		axis,
		math.rad(angle)
	)
end

function MathUtils.rotateGlobalAxis(
	cframe: CFrame,
	axis: Vector3,
	angle: number
): CFrame
	return CFrame.fromAxisAngle(
		axis,
		math.rad(angle)
	) * cframe
end


function MathUtils.rotateLocalX(cf, angle)
	return MathUtils.rotateLocalAxis(cf, AXIS.X, angle)
end

function MathUtils.rotateLocalY(cf, angle)
	return MathUtils.rotateLocalAxis(cf, AXIS.Y, angle)
end

function MathUtils.rotateLocalZ(cf, angle)
	return MathUtils.rotateLocalAxis(cf, AXIS.Z, angle)
end

function MathUtils.rotateGlobalX(cf, angle)
	return MathUtils.rotateGlobalAxis(cf, AXIS.X, angle)
end

function MathUtils.rotateGlobalY(cf, angle)
	return MathUtils.rotateGlobalAxis(cf, AXIS.Y, angle)
end

function MathUtils.rotateGlobalZ(cf, angle)
	return MathUtils.rotateGlobalAxis(cf, AXIS.Z, angle)
end

function MathUtils.distanceTo(v : Vector3, u : Vector3) : number
	return (v - u).Magnitude
end

function MathUtils.angleBetweenRad(v : Vector3, u : Vector3) : number
	return math.acos(v:Dot(u) / (v.Magnitude * u.Magnitude))
end

function MathUtils.angleBetweenDeg(v : Vector3, u : Vector3) : number
	return math.deg(MathUtils.angleBetweenRad(v, u))
end

function MathUtils.unityPointingTo(sourcevec : Vector3, targetvec : Vector3) : Vector3
	return (targetvec - sourcevec).Unit
end

return MathUtils