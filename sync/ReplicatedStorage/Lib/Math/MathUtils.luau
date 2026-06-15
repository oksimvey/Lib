local MathUtils = {}



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


return MathUtils