
-- Roblox Custom Emote Menu Script
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Wait for PlayerGui
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Clean up existing GUI if re-executed
if PlayerGui:FindFirstChild("EmoteMenuGui") then
    PlayerGui.EmoteMenuGui:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EmoteMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title Bar
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleLabel.Text = "✨ Emote Menu"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

-- Scrolling Frame for Emote Buttons
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -100)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Auto-adjust Canvas Size
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- Animation Tracker
local currentTrack = nil

local function stopCurrentEmote()
    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end
end

-- Function to play animation
local function playEmote(animationId)
    stopCurrentEmote()

    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(animationId)

    local success, track = pcall(function()
        return animator:LoadAnimation(anim)
    end)

    if success and track then
        currentTrack = track
        currentTrack:Play()
    end
end

-- Emote List (Add or change Asset IDs here)
local emotes = {
    { Name = "Dance 1", Id = 182435998 },
    { Name = "Dance 2", Id = 182436842 },
    { Name = "Dance 3", Id = 182436935 },
    { Name = "Point", Id = 1288561117 },
    { Name = "Salute", Id = 1288569831 },
    { Name = "Stadium Emote", Id = 3337966304 },
    { Name = "Tilt", Id = 3338010159 },
    { Name = "Wave", Id = 1288560312 }
}

-- Create Emote Buttons
for _, emote in ipairs(emotes) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = emote.Name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 15
    btn.Font = Enum.Font.SourceSansSemiBold
    btn.Parent = ScrollFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        playEmote(emote.Id)
    end)
end

-- Stop Button
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, -20, 0, 36)
StopBtn.Position = UDim2.new(0, 10, 1, -44)
StopBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
StopBtn.Text = "🛑 Stop Emote"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.TextSize = 15
StopBtn.Font = Enum.Font.SourceSansBold
StopBtn.Parent = MainFrame

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 6)
StopCorner.Parent = StopBtn

StopBtn.MouseButton1Click:Connect(function()
    stopCurrentEmote()
end)

print("Emote Menu successfully loaded!")
