local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "keysyscracker"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.Parent = playerGui

local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(1, 0, 1, 0)
imageLabel.Position = UDim2.new(0, 0, 0, 0)
imageLabel.BackgroundTransparency = 0
imageLabel.Image = "rbxassetid://17862922361"
imageLabel.ZIndex = 1
imageLabel.Parent = screenGui


local function createText()
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(0, 200, 0, 50)
    text.Position = UDim2.new(math.random(), 0, math.random(), 0)
    text.BackgroundTransparency = 1
    text.Text = "script loaded!!!!!"
    text.TextScaled = true
    text.TextColor3 = Color3.new(math.random(), math.random(), math.random())
    text.Font = Enum.Font.SourceSansBold
    text.Rotation = math.random(-45, 45)
    text.ZIndex = 2
    text.Parent = screenGui
end


while true do
    for i = 1, 180007808081211777 do 
        createText()
    end
    task.wait() 
end
