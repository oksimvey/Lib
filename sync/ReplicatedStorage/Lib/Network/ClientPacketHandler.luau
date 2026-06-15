local ClientPacketHandler = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local folder = ReplicatedStorage:WaitForChild("Packets")

local function getRemote(name: string): Instance?
	return folder:FindFirstChild(name)
end

function ClientPacketHandler.sendEvent(name: string, ...: any) 
	local remote = getRemote(name)

	if not remote or not remote:IsA("RemoteEvent") then
		warn(`Event "{name}" not found`)
		return
	end
	
	
	remote:FireServer(...)
end

function ClientPacketHandler.sendFunction(name: string, ...: any): any
	local remote = getRemote(name)

	if not remote or not remote:IsA("RemoteFunction") then
		warn(`Function "{name}" not found`)
		return nil
	end

	return remote:InvokeServer(...)
end

return ClientPacketHandler