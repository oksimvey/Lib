local Curve = {}

Curve.__index = Curve

function Curve.new(name: string)
	return setmetatable({
		Name = name
	}, Curve)
end

function Curve:speak()
	print("som genérico")
end

return Curve
