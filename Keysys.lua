local KeySystem = {}

function KeySystem.new(config)
    config = config or {}
    
    local settings = {
        valid_keys = config.keys or {"DEFAULT_KEY"},
        protected_script = config.script or [[print("No script provided")]],
        script_name = config.name or "Protected Script",
        ui_settings = {
            width = config.width or 400,
            height = config.height or 350,
            bg_color = config.bg_color or Color3.fromRGB(255, 255, 255),
            accent_color = config.accent_color or Color3.fromRGB(0, 120, 255)
        }
    }
    
    -- Create the UI
    local function createUI()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "KeySystem"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = game:GetService("CoreGui")
        
        -- Main frame
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, settings.ui_settings.width, 0, settings.ui_settings.height)
        mainFrame.Position = UDim2.new(0.5, -settings.ui_settings.width/2, 0.5, -settings.ui_settings.height/2)
        mainFrame.BackgroundColor3 = settings.ui_settings.bg_color
        mainFrame.BorderSizePixel = 1
        mainFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
        
        -- Title bar
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
        titleBar.BorderSizePixel = 0
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -40, 1, 0)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = settings.script_name:upper() .. " KEY SYSTEM"
        title.TextColor3 = Color3.fromRGB(0, 0, 0)
        title.TextSize = 16
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Font = Enum.Font.GothamBold
        
        -- Close button
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 40, 0, 40)
        closeBtn.Position = UDim2.new(1, -40, 0, 0)
        closeBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        closeBtn.TextSize = 18
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.BorderSizePixel = 0
        
        -- Lock Icon
        local lockIcon = Instance.new("ImageLabel")
        lockIcon.Size = UDim2.new(0, 80, 0, 80)
        lockIcon.Position = UDim2.new(0.5, -40, 0.08, 0)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Image = "rbxassetid://5513462875"
        lockIcon.ImageColor3 = Color3.fromRGB(0, 0, 0)
        
        -- Instruction label
        local instructionLabel = Instance.new("TextLabel")
        instructionLabel.Size = UDim2.new(0.8, 0, 0, 40)
        instructionLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
        instructionLabel.BackgroundTransparency = 1
        instructionLabel.Text = "Enter your license key to unlock " .. settings.script_name
        instructionLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
        instructionLabel.TextSize = 14
        instructionLabel.Font = Enum.Font.Gotham
        
        -- Key input box
        local keyInput = Instance.new("TextBox")
        keyInput.Size = UDim2.new(0.8, 0, 0, 45)
        keyInput.Position = UDim2.new(0.1, 0, 0.45, 0)
        keyInput.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
        keyInput.BorderColor3 = Color3.fromRGB(200, 200, 200)
        keyInput.BorderSizePixel = 1
        keyInput.Text = ""
        keyInput.PlaceholderText = "Enter your license key here..."
        keyInput.TextColor3 = Color3.fromRGB(0, 0, 0)
        keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        keyInput.TextSize = 14
        keyInput.Font = Enum.Font.Gotham
        
        -- Status label
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(0.8, 0, 0, 40)
        statusLabel.Position = UDim2.new(0.1, 0, 0.62, 0)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "Waiting for key..."
        statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
        statusLabel.TextSize = 12
        statusLabel.Font = Enum.Font.Gotham
        
        -- Submit button
        local submitBtn = Instance.new("TextButton")
        submitBtn.Size = UDim2.new(0.6, 0, 0, 45)
        submitBtn.Position = UDim2.new(0.2, 0, 0.8, 0)
        submitBtn.BackgroundColor3 = settings.ui_settings.accent_color
        submitBtn.Text = "UNLOCK " .. settings.script_name:upper()
        submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        submitBtn.TextSize = 14
        submitBtn.Font = Enum.Font.GothamBold
        submitBtn.BorderSizePixel = 0
        
        -- Hover effect
        submitBtn.MouseEnter:Connect(function()
            submitBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 220)
        end)
        
        submitBtn.MouseLeave:Connect(function()
            submitBtn.BackgroundColor3 = settings.ui_settings.accent_color
        end)
        
        closeBtn.MouseEnter:Connect(function()
            closeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        end)
        
        closeBtn.MouseLeave:Connect(function()
            closeBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        end)
        
        -- Dragging functionality
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        titleBar.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                               startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        -- Assemble UI
        titleBar.Parent = mainFrame
        title.Parent = titleBar
        closeBtn.Parent = titleBar
        lockIcon.Parent = mainFrame
        instructionLabel.Parent = mainFrame
        keyInput.Parent = mainFrame
        statusLabel.Parent = mainFrame
        submitBtn.Parent = mainFrame
        mainFrame.Parent = screenGui
        
        return keyInput, statusLabel, submitBtn, screenGui, mainFrame
    end
    
    -- Verify key and load script
    local function verifyAndLoad(key)
        local isValid = false
        
        for _, validKey in ipairs(settings.valid_keys) do
            if key == validKey then
                isValid = true
                break
            end
        end
        
        if not isValid then
            local upperKey = string.upper(key)
            for _, validKey in ipairs(settings.valid_keys) do
                if string.upper(validKey) == upperKey then
                    isValid = true
                    break
                end
            end
        end
        
        if isValid then
            local success, err = loadstring(settings.protected_script)
            if success then
                success()
                return true, "Key accepted! Loading " .. settings.script_name .. "..."
            else
                return false, "Error loading script: " .. tostring(err)
            end
        else
            return false, "Invalid key! Please check your key key."
        end
    end
    
    -- Fade out animation
    local function fadeOutAndDestroy(screenGui, mainFrame)
        for i = 0, 10 do
            wait(0.03)
            local transparency = i / 10
            mainFrame.BackgroundTransparency = transparency
            mainFrame.BorderSizePixel = transparency > 0.9 and 0 or 1
            
            for _, child in ipairs(mainFrame:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") or child:IsA("ImageLabel") then
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        child.TextTransparency = transparency
                    end
                    if child:IsA("TextButton") or child:IsA("ImageLabel") then
                        child.BackgroundTransparency = transparency
                    end
                    if child:IsA("ImageLabel") then
                        child.ImageTransparency = transparency
                    end
                end
            end
        end
        
        screenGui:Destroy()
    end
    
    -- Start the system
    local function start()
        local keyInput, statusLabel, submitBtn, screenGui, mainFrame = createUI()
        local uiDestroyed = false
        
        local function onSubmit()
            if uiDestroyed then return end
            
            local enteredKey = keyInput.Text
            if enteredKey == "" then
                statusLabel.Text = "Please enter a key!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                return
            end
            
            statusLabel.Text = "Verifying key..."
            statusLabel.TextColor3 = Color3.fromRGB(0, 100, 200)
            
            wait(0.3)
            
            local success, message = verifyAndLoad(enteredKey)
            statusLabel.Text = message
            
            if success then
                statusLabel.TextColor3 = Color3.fromRGB(0, 150, 0)
                uiDestroyed = true
                fadeOutAndDestroy(screenGui, mainFrame)
            else
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                keyInput.Text = ""
                keyInput:CaptureFocus()
                
                local originalPos = mainFrame.Position
                for i = 1, 3 do
                    mainFrame.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 8,
                                                  originalPos.Y.Scale, originalPos.Y.Offset)
                    wait(0.05)
                    mainFrame.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 8,
                                                  originalPos.Y.Scale, originalPos.Y.Offset)
                    wait(0.05)
                end
                mainFrame.Position = originalPos
                
                wait(1)
                if not uiDestroyed then
                    statusLabel.Text = "Waiting for key..."
                    statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
                end
            end
        end
        
        submitBtn.MouseButton1Click:Connect(onSubmit)
        
        keyInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                onSubmit()
            end
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            if not uiDestroyed then
                uiDestroyed = true
                fadeOutAndDestroy(screenGui, mainFrame)
            end
        end)
    end
    
    return {start = start}
end

return KeySystem