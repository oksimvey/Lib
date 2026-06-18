local MathFunction = {}

export type scalarFunction = (number) -> number

export type surfaceFunction = (number, number) -> number

export type vec2DFunction = (Vector2) -> Vector2

export type vec3DFunction = (Vector3) -> Vector3

export type parametricCurve2DFunction = (number) -> Vector2

export type parametricCurve3DFunction = (number) -> Vector3

export type parametricSurfaceFunction = (number, number) -> Vector3

export type validFunction =
	scalarFunction
	| surfaceFunction
	| vec2DFunction
	| vec3DFunction
	| parametricCurve2DFunction
	| parametricCurve3DFunction
	| parametricSurfaceFunction

return MathFunction
