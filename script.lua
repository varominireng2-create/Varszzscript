loadstring([[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("ToggleGodMode")

local KEY = "varszzscript"
local unlocked = false

-- ================= GUI =================

local gui = Instance.new("ScreenGui")
gui.Name = "VarsZZGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ================= DRAG FUNCTION =================

local function makeDraggable(frame)
	local dragging = false
	local dragStart
	local startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- ================= KEY FRAME =================

local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.fromScale(0.3,0.18)
keyFrame.Position = UDim2.fromScale(0.35,0.41)
keyFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
keyFrame.BorderSizePixel = 0

makeDraggable(keyFrame)

local keyCorner = Instance.new("UICorner", keyFrame)
keyCorner.CornerRadius = UDim.new(0,16)

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.fromScale(1,0.35)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "Enter Key"
keyTitle.TextScaled = true
keyTitle.TextColor3 = Color3.fromRGB(255,255,255)
keyTitle.Font = Enum.Font.GothamBold

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.fromScale(0.9,0.35)
keyBox.Position = UDim2.fromScale(0.05,0.45)
keyBox.PlaceholderText = "Type key..."
keyBox.Text = ""
keyBox.TextScaled = true
keyBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.Font = Enum.Font.Gotham
keyBox.ClearTextOnFocus = false

local boxCorner = Instance.new("UICorner", keyBox)
boxCorner.CornerRadius = UDim.new(0,10)

-- ================= MAIN FRAME =================

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.fromScale(0,0)
mainFrame.Position = UDim2.fromScale(0.375,0.44)
mainFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false

makeDraggable(mainFrame)

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0,16)

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.fromScale(0.15,0.35)
closeBtn.Position = UDim2.fromScale(0.85,0)
closeBtn.Text = "X"
closeBtn.TextScaled = true
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255,120,120)
closeBtn.Font = Enum.Font.GothamBold

local button = Instance.new("TextButton", mainFrame)
button.Size = UDim2.fromScale(1,1)
button.BackgroundTransparency = 1
button.Text = "Toggle GodMode"
button.TextScaled = true
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.GothamBold

-- ================= FUNCTIONS =================

local function openMain()
	mainFrame.Visible = true
	mainFrame.Size = UDim2.fromScale(0,0)

	local tween = TweenService:Create(
		mainFrame,
		TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.fromScale(0.25,0.12)}
	)

	tween:Play()
end

local function closeMain()
	local tween = TweenService:Create(
		mainFrame,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{Size = UDim2.fromScale(0,0)}
	)

	tween:Play()
	tween.Completed:Wait()
	mainFrame.Visible = false
end

local function unlock()
	unlocked = true
	keyFrame.Visible = false
	openMain()
end

-- ================= EVENTS =================

keyBox.FocusLost:Connect(function(enterPressed)
	if not enterPressed then return end

	if keyBox.Text == KEY then
		unlock()
	else
		keyBox.Text = ""
		keyBox.PlaceholderText = "Wrong key"
	end
end)

button.MouseButton1Click:Connect(function()
	if unlocked then
		remote:FireServer()
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	closeMain()
end)

]])()
