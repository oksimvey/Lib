local PhysicalInstanceManager = {}

export type Transformable = BasePart | Model


function PhysicalInstanceManager.getPosition(part : Transformable) : Vector3 | nil
	if part:IsA("Model") then
		return part:GetPivot().Position
	elseif part:IsA("BasePart") then
		return part.Position
	end
	return nil
end

function PhysicalInstanceManager.setPosition(part : Transformable, pos : Vector3)
	if part:IsA("Model") then
		part:PivotTo(CFrame.new(pos))
	elseif part:IsA("BasePart") then
		part.Position = pos
	end
end

function PhysicalInstanceManager.getCFrame(part : Transformable): CFrame | nil
	if part:IsA("Model") then
		return part:GetPivot()
	elseif part:IsA("BasePart") then
		return part.CFrame
	end
	return nil
end

function PhysicalInstanceManager.setCFrame(part : Transformable, cframe : CFrame)
	if part:IsA("Model") then
		part:PivotTo(cframe)
	elseif part:IsA("BasePart") then
		part.CFrame = cframe
	end
end

function PhysicalInstanceManager.getRotation(part : Transformable): CFrame | nil
	if part:IsA("Model") then
		return part:GetPivot().Rotation
	elseif part:IsA("BasePart") then
		return part.CFrame.Rotation
	end
	return nil
end

function PhysicalInstanceManager.setRotation(part : Transformable, rot : CFrame)
	if part:IsA("Model") then
		part:PivotTo(CFrame.new(part:GetPivot().Position) * rot)
	elseif part:IsA("BasePart") then
		part.CFrame = CFrame.new(part.Position) * rot
	end
end




return PhysicalInstanceManager
