local ServerPacketHandler = require(game.ReplicatedStorage.Lib.Network.ServerPacketHandler)

local PhysicalStateUtils = require(game.ReplicatedStorage.Lib.Physics.PhysicalStateUtils)

ServerPacketHandler.registerEvent({
	Name = "Test",
	Handler = function(player: Player, duration : number)
		local char = player.Character or player.CharacterAdded:Wait()

		local part : BasePart = workspace.Cool


		for _, obj in ipairs(char:GetDescendants()) do

			if obj:IsA("BasePart") then


				local attachment = Instance.new("Attachment")
				attachment.Parent = obj

				local velocity = Instance.new("LinearVelocity")
				velocity.Attachment0 = attachment

				velocity.VectorVelocity = Vector3.new(0, 0, 0)
				velocity.Parent = obj
			end

		end


		local info = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

		local newcframe : CFrame = CFrame.new(100, 0, 0)


		PhysicalStateUtils.setCFrame(char, CFrame.new(100, 100, 0))
		PhysicalStateUtils.setCFrameEased(part, newcframe, info)

		PhysicalStateUtils.setCFrameEased(char, newcframe, info)
	end,
})