local RunService = game:GetService("RunService")
local rig = workspace:FindFirstChild("Rig")
if not rig then return end

local hrp = rig:FindFirstChild("HumanoidRootPart")
if not hrp then return end

-- Disable the default Animate script so it doesn't fight our animation
local animateScript = rig:FindFirstChild("Animate")
if animateScript then
	animateScript.Disabled = true
end

-- Anchor the root part so the rig stays in place
hrp.Anchored = true

-- Disable BallSocketConstraints (they have tight limits that block full rotation)
local ballSockets = {}
for _, desc in rig:GetDescendants() do
	if desc:IsA("BallSocketConstraint") then
		table.insert(ballSockets, {constraint = desc, wasEnabled = desc.Enabled})
		desc.Enabled = false
	end
end

-- Gather all AnimationConstraints
local function getAC(parent, name)
	local p = rig:FindFirstChild(parent)
	if not p then return nil end
	return p:FindFirstChild(name)
end

local rootAC = getAC("LowerTorso", "Root")
local waistAC = getAC("UpperTorso", "Waist")
local leftHipAC = getAC("LeftUpperLeg", "LeftHip")
local rightHipAC = getAC("RightUpperLeg", "RightHip")
local leftKneeAC = getAC("LeftLowerLeg", "LeftKnee")
local rightKneeAC = getAC("RightLowerLeg", "RightKnee")
local leftShoulderAC = getAC("LeftUpperArm", "LeftShoulder")
local rightShoulderAC = getAC("RightUpperArm", "RightShoulder")
local leftElbowAC = getAC("LeftLowerArm", "LeftElbow")
local rightElbowAC = getAC("RightLowerArm", "RightElbow")
local leftAnkleAC = getAC("LeftFoot", "LeftAnkle")
local rightAnkleAC = getAC("RightFoot", "RightAnkle")
local neckAC = getAC("Head", "Neck")
local leftWristAC = getAC("LeftHand", "LeftWrist")
local rightWristAC = getAC("RightHand", "RightWrist")

-- Store original HRP CFrame
local originalCFrame = hrp.CFrame

-- Animation parameters
local FLIP_DURATION = 1.0   -- seconds for one backflip
local PAUSE_DURATION = 0.8  -- pause between flips
local JUMP_HEIGHT = 8        -- peak height in studs

-- Smoothstep easing
local function smoothstep(t)
	t = math.clamp(t, 0, 1)
	return t * t * (3 - 2 * t)
end

-- Ease in-out cubic
local function easeInOut(t)
	t = math.clamp(t, 0, 1)
	if t < 0.5 then
		return 4 * t * t * t
	else
		return 1 - ((-2 * t + 2) ^ 3) / 2
	end
end

-- Reset all AnimationConstraint transforms to identity
local function resetTransforms()
	for _, ac in {rootAC, waistAC, leftHipAC, rightHipAC, leftKneeAC, rightKneeAC, leftShoulderAC, rightShoulderAC, leftElbowAC, rightElbowAC, leftAnkleAC, rightAnkleAC, neckAC, leftWristAC, rightWristAC} do
		if ac then
			ac.Transform = CFrame.new()
		end
	end
end

local startTime = tick()

local function update()
	local elapsed = tick() - startTime
	local totalCycle = FLIP_DURATION + PAUSE_DURATION
	local cycleTime = elapsed % totalCycle

	if cycleTime > FLIP_DURATION then
		-- Pause phase: standing still
		hrp.CFrame = originalCFrame
		resetTransforms()
		return
	end

	local t = cycleTime / FLIP_DURATION -- 0 to 1 over the flip

	-- === VERTICAL ARC (parabolic jump) ===
	local heightOffset = JUMP_HEIGHT * 4 * t * (1 - t)

	-- === MAIN FLIP ROTATION ===
	-- Ease the rotation: slow start, fast middle, slow end
	local rotT = easeInOut(t)
	local flipAngle = rotT * 2 * math.pi -- full 360 degrees

	-- === TUCK PHASE ===
	-- Tuck peaks around t=0.35-0.65
	local tuckAmount = 0
	if t < 0.15 then
		-- Prep: slight crouch
		tuckAmount = smoothstep(t / 0.15) * 0.2
	elseif t < 0.35 then
		-- Tuck in
		tuckAmount = 0.2 + smoothstep((t - 0.15) / 0.2) * 0.8
	elseif t < 0.65 then
		-- Full tuck
		tuckAmount = 1.0
	elseif t < 0.85 then
		-- Untuck
		tuckAmount = 1.0 - smoothstep((t - 0.65) / 0.2)
	else
		-- Landing prep
		tuckAmount = 0
	end

	-- === LANDING CROUCH ===
	local landCrouch = 0
	if t > 0.85 then
		landCrouch = smoothstep((t - 0.85) / 0.15) * 0.3
	end

	-- === APPLY TRANSFORMS ===

	-- Move HRP up for the jump arc
	hrp.CFrame = originalCFrame * CFrame.new(0, heightOffset, 0)

	-- Root: main backflip rotation (rotate entire body around X axis)
	if rootAC then
		rootAC.Transform = CFrame.Angles(flipAngle, 0, 0)
	end

	-- Waist: extra backward bend during tuck
	if waistAC then
		waistAC.Transform = CFrame.Angles(tuckAmount * 0.4, 0, 0)
	end

	-- Hips: bring legs up toward chest during tuck
	if leftHipAC then
		leftHipAC.Transform = CFrame.Angles(-tuckAmount * 1.4, 0, 0)
	end
	if rightHipAC then
		rightHipAC.Transform = CFrame.Angles(-tuckAmount * 1.4, 0, 0)
	end

	-- Knees: bend deeply during tuck
	if leftKneeAC then
		leftKneeAC.Transform = CFrame.Angles(tuckAmount * 2.0, 0, 0)
	end
	if rightKneeAC then
		rightKneeAC.Transform = CFrame.Angles(tuckAmount * 2.0, 0, 0)
	end

	-- Ankles: point toes during tuck, flex on landing
	if leftAnkleAC then
		leftAnkleAC.Transform = CFrame.Angles(-tuckAmount * 0.6 + landCrouch * 0.3, 0, 0)
	end
	if rightAnkleAC then
		rightAnkleAC.Transform = CFrame.Angles(-tuckAmount * 0.6 + landCrouch * 0.3, 0, 0)
	end

	-- Shoulders: swing arms up during launch, wrap during tuck
	if leftShoulderAC then
		leftShoulderAC.Transform = CFrame.Angles(tuckAmount * 1.2, 0, 0)
	end
	if rightShoulderAC then
		rightShoulderAC.Transform = CFrame.Angles(tuckAmount * 1.2, 0, 0)
	end

	-- Elbows: bend arms during tuck
	if leftElbowAC then
		leftElbowAC.Transform = CFrame.Angles(tuckAmount * 1.5, 0, 0)
	end
	if rightElbowAC then
		rightElbowAC.Transform = CFrame.Angles(tuckAmount * 1.5, 0, 0)
	end

	-- Wrists: slight bend
	if leftWristAC then
		leftWristAC.Transform = CFrame.Angles(tuckAmount * 0.3, 0, 0)
	end
	if rightWristAC then
		rightWristAC.Transform = CFrame.Angles(tuckAmount * 0.3, 0, 0)
	end

	-- Neck: tuck chin during flip
	if neckAC then
		neckAC.Transform = CFrame.Angles(-tuckAmount * 0.4, 0, 0)
	end
end

RunService.Heartbeat:Connect(update)