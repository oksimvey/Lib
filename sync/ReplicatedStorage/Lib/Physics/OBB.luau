local OBB = {}

export type OBBCollider = {
    size : Vector3,
    debug : Vector3,
    parent : BasePart,
    onTouch : (BasePart) -> (),
}

return OBB
