local UIS = game:GetService("UserInputService")

local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character

local Glove = LocalPlayer.Backpack:WaitForChild("Extreme Glove")
local AnimID = "rbxassetid://10717116749"

local Animation = Instance.new("Animation")
Animation.AnimationId = AnimID

local Track = Character:WaitForChild("Humanoid"):LoadAnimation(Animation)

local AddedConnection
local BeganConnection
local EndedConnection

local function Punch()
	Track:Play()
	Track.TimePosition = 1.95
	Track:AdjustSpeed(0)
end

local function Punch2()
	Track:AdjustSpeed(1.2)
	task.delay(0.2, function()
		Track:AdjustSpeed(0)
	end)
	task.delay(0.5, function()
		Track:Stop(0.3)
	end)
end

local function removeGloveTransparency()
	local Backpack = LocalPlayer.Backpack
	Character:WaitForChild("Humanoid"):UnequipTools()
	Character:WaitForChild("Humanoid"):EquipTool(Backpack:WaitForChild("Extreme Glove"))
	game.ReplicatedStorage.HDAdminClient.Signals.RequestCommand:InvokeServer("/invisible")
	Character:WaitForChild("Humanoid"):UnequipTools()
	game.ReplicatedStorage.HDAdminClient.Signals.RequestCommand:InvokeServer("/visible")
end

local function removeGloveAnimations()
	local Animate = Character:WaitForChild("Animate") -- Remove tool holding animation
	Animate.toollunge.ToolLungeAnim.AnimationId = ""
	Animate.toolnone.ToolNoneAnim.AnimationId = ""
	Animate.toolslash.ToolSlashAnim.AnimationId = ""
end

local Holding = false
BeganConnection = UIS.InputBegan:Connect(function(Input, GPE)
	if not GPE then
		if Input.KeyCode == Enum.KeyCode.F then	
			Holding = true
			Punch() -- Do hold punch animation		
		elseif Input.KeyCode == Enum.KeyCode.B then
			if BeganConnection then BeganConnection:Disconnect() BeganConnection = nil end
			if EndedConnection then EndedConnection:Disconnect() EndedConnection = nil end
			if AddedConnection then AddedConnection:Disconnect() AddedConnection = nil end
			if Holding then
				Character:WaitForChild("Humanoid"):EquipTool(Glove)
				local Remote = Glove:WaitForChild("Remote")
				Remote:FireServer("LeftDown")
				task.delay(0.5, function()
					if Character:FindFirstChild("Extreme Glove") then
						Character.Humanoid:UnequipTools()
					end
				end)
				Punch2() -- Do punch animation	
			end
		end	
	end
end)

EndedConnection = UIS.InputEnded:Connect(function(Input, GPE)
	if Input.KeyCode == Enum.KeyCode.F and Holding then	
		Holding = false
		Character:WaitForChild("Humanoid"):EquipTool(Glove)
		local Remote = Glove:WaitForChild("Remote")
		Remote:FireServer("LeftDown")
		task.delay(0.5, function()
			if Character:FindFirstChild("Extreme Glove") then
				Character.Humanoid:UnequipTools()
			end
		end)
		Punch2() -- Do punch animation	
	end
end)

removeGloveTransparency()
removeGloveAnimations()

local function Do()
	game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(child)
		if child:IsA("BodyVelocity") and child.Name == "BodyVelocity" and child.MaxForce == Vector3.new(1000000000, 1000000000, 1000000000) then
			game.Players.LocalPlayer.Character.Humanoid.Sit = false
			child.MaxForce = Vector3.new(0, 0, 0)
			spawn(function()
				child:Destroy()
			end)
		end
	end)
end
Do()
AddedConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
	Do()
	Character = NewCharacter
	Track = Character:WaitForChild("Humanoid"):LoadAnimation(Animation)
	Glove = LocalPlayer.Backpack:WaitForChild("Extreme Glove")
	removeGloveTransparency()
	removeGloveAnimations()
end)
