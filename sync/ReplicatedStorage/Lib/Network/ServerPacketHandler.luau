
local ServerPacketHandler = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

export type EventPacket = {
	Name: string,
	Handler: (Player, ...any) -> (),
}

export type FunctionPacket = {
	Name: string,
	Handler: (Player, ...any) -> ...any,
}

type RemotePacket = RemoteEvent | RemoteFunction


local packetMap: {[string]: RemotePacket} = {}

local function getOrCreateFolder(): Folder
	local folder = ReplicatedStorage:FindFirstChild("Packets")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "Packets"
		folder.Parent = ReplicatedStorage
	end
	return folder :: Folder
end

function ServerPacketHandler.registerEvent(packet: EventPacket)
	if packetMap[packet.Name] then
		error(`Packet "{packet.Name}" already exists`)
	end

	local folder = getOrCreateFolder()

	local remote = Instance.new("RemoteEvent")
	remote.Name = packet.Name
	remote.Parent = folder
	


	remote.OnServerEvent:Connect(function(player: Player, ...: any)
		packet.Handler(player, ...)
	end)

	packetMap[packet.Name] = remote
end

function ServerPacketHandler.registerFunction(packet: FunctionPacket)
	if packetMap[packet.Name] then
		error(`Packet "{packet.Name}" already exists`)
	end

	local folder = getOrCreateFolder()

	local remote = Instance.new("RemoteFunction")
	remote.Name = packet.Name
	remote.Parent = folder
	
	

	remote.OnServerInvoke = function(player: Player, ...: any)
		return packet.Handler(player, ...)
	end

	packetMap[packet.Name] = remote
end

return ServerPacketHandler