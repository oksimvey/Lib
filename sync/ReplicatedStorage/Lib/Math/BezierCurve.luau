local BezierCurve = {}

function cubicBezier(t: number, p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3): Vector3
	local u = 1 - t
	local tt = t * t
	local uu = u * u
	local uuu = uu * u
	local ttt = tt * t

	return p0 * uuu
		+ p1 * (3 * uu * t)
		+ p2 * (3 * u * tt)
		+ p3 * ttt
end

return BezierCurve
