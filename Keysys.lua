local KeySystem = {}

function KeySystem.new(config)
    config = config or {}
    
    local settings = {
        valid_keys = config.keys or {"DEFAULT_KEY"},
        protected_script = config.script or [[print("No script provided")]],
        script_name = config.name or "Protected Script",
        discord_link = config.discord_link or "https://discord.gg/example",
        require_captcha = config.require_captcha ~= false,
        ui_settings = {
            width = config.width or 400,
            height = config.height or 470,
            bg_color = config.bg_color or Color3.fromRGB(255, 255, 255),
            accent_color = config.accent_color or Color3.fromRGB(0, 120, 255)
        }
    }
    
    local function generateCaptcha()
        local chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789"
        local captcha = ""
        for i = 1, 6 do
            local rand = math.random(1, #chars)
            captcha = captcha .. string.sub(chars, rand, rand)
        end
        return captcha
    end
    
    local function createUI()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "KeySystem"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = game:GetService("CoreGui")
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, settings.ui_settings.width, 0, settings.ui_settings.height)
        mainFrame.Position = UDim2.new(0.5, -settings.ui_settings.width/2, 0.5, -settings.ui_settings.height/2)
        mainFrame.BackgroundColor3 = settings.ui_settings.bg_color
        mainFrame.BorderSizePixel = 1
        mainFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
        
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
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 40, 0, 40)
        closeBtn.Position = UDim2.new(1, -40, 0, 0)
        closeBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        closeBtn.TextSize = 18
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.BorderSizePixel = 0
        
        local lockIcon = Instance.new("ImageLabel")
        lockIcon.Size = UDim2.new(0, 60, 0, 60)
        lockIcon.Position = UDim2.new(0.5, -30, 0.04, 0)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Image = "rbxassetid://5513462875"
        lockIcon.ImageColor3 = Color3.fromRGB(0, 0, 0)
        
        local instructionLabel = Instance.new("TextLabel")
        instructionLabel.Size = UDim2.new(0.8, 0, 0, 30)
        instructionLabel.Position = UDim2.new(0.1, 0, 0.16, 0)
        instructionLabel.BackgroundTransparency = 1
        instructionLabel.Text = "Enter your license key to unlock " .. settings.script_name
        instructionLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
        instructionLabel.TextSize = 13
        instructionLabel.Font = Enum.Font.Gotham
        
        -- CAPTCHA Section
        local captchaFrame = Instance.new("Frame")
        captchaFrame.Size = UDim2.new(0.9, 0, 0, 80)
        captchaFrame.Position = UDim2.new(0.05, 0, 0.24, 0)
        captchaFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        captchaFrame.BorderSizePixel = 1
        captchaFrame.BorderColor3 = Color3.fromRGB(220, 220, 220)
        captchaFrame.Visible = settings.require_captcha
        
        local captchaLabel = Instance.new("TextLabel")
        captchaLabel.Size = UDim2.new(1, 0, 0, 25)
        captchaLabel.Position = UDim2.new(0, 0, 0, 0)
        captchaLabel.BackgroundTransparency = 1
        captchaLabel.Text = "Verify you're human:"
        captchaLabel.TextColor3 = Color3.fromRGB(60, 60, 60)
        captchaLabel.TextSize = 12
        captchaLabel.Font = Enum.Font.Gotham
        captchaLabel.TextXAlignment = Enum.TextXAlignment.Left
        captchaLabel.Parent = captchaFrame
        
        local captchaText = Instance.new("TextLabel")
        captchaText.Size = UDim2.new(0.6, 0, 0, 35)
        captchaText.Position = UDim2.new(0.05, 0, 0.35, 0)
        captchaText.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        captchaText.BackgroundTransparency = 0.1
        captchaText.Text = ""
        captchaText.TextColor3 = Color3.fromRGB(0, 0, 0)
        captchaText.TextSize = 20
        captchaText.Font = Enum.Font.GothamBold
        captchaText.TextScaled = true
        
        local captchaInput = Instance.new("TextBox")
        captchaInput.Size = UDim2.new(0.28, 0, 0, 35)
        captchaInput.Position = UDim2.new(0.67, 0, 0.35, 0)
        captchaInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        captchaInput.BorderColor3 = Color3.fromRGB(200, 200, 200)
        captchaInput.BorderSizePixel = 1
        captchaInput.PlaceholderText = "Enter code"
        captchaInput.Text = ""
        captchaInput.TextColor3 = Color3.fromRGB(0, 0, 0)
        captchaInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        captchaInput.TextSize = 14
        captchaInput.Font = Enum.Font.Gotham
        
        local refreshCaptchaBtn = Instance.new("TextButton")
        refreshCaptchaBtn.Size = UDim2.new(0, 30, 0, 30)
        refreshCaptchaBtn.Position = UDim2.new(0.92, 0, 0.38, 0)
        refreshCaptchaBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        refreshCaptchaBtn.Text = "↻"
        refreshCaptchaBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        refreshCaptchaBtn.TextSize = 20
        refreshCaptchaBtn.Font = Enum.Font.GothamBold
        refreshCaptchaBtn.BorderSizePixel = 0
        
        local captchaStatus = Instance.new("TextLabel")
        captchaStatus.Size = UDim2.new(1, 0, 0, 15)
        captchaStatus.Position = UDim2.new(0, 0, 0.8, 0)
        captchaStatus.BackgroundTransparency = 1
        captchaStatus.Text = ""
        captchaStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
        captchaStatus.TextSize = 10
        captchaStatus.Font = Enum.Font.Gotham
        captchaStatus.Parent = captchaFrame
        
        local currentCaptcha = ""
        local captchaVerified = false
        
        local function refreshCaptcha()
            currentCaptcha = generateCaptcha()
            captchaText.Text = currentCaptcha
            captchaInput.Text = ""
            captchaStatus.Text = ""
            captchaVerified = false
            captchaFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            captchaFrame.BorderColor3 = Color3.fromRGB(220, 220, 220)
            captchaText.TextColor3 = Color3.fromRGB(math.random(0, 100), math.random(0, 100), math.random(0, 100))
        end
        
        local function verifyCaptcha()
            if not settings.require_captcha then
                captchaVerified = true
                return true
            end
            
            if string.upper(captchaInput.Text) == string.upper(currentCaptcha) then
                captchaVerified = true
                captchaStatus.Text = "✓ Verified!"
                captchaStatus.TextColor3 = Color3.fromRGB(0, 150, 0)
                captchaFrame.BackgroundColor3 = Color3.fromRGB(230, 255, 230)
                captchaFrame.BorderColor3 = Color3.fromRGB(0, 200, 0)
                return true
            else
                captchaVerified = false
                captchaStatus.Text = "✗ Incorrect code"
                captchaStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
                captchaFrame.BackgroundColor3 = Color3.fromRGB(255, 230, 230)
                captchaFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
                
                local originalPos = captchaFrame.Position
                for i = 1, 3 do
                    captchaFrame.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 5, originalPos.Y.Scale, originalPos.Y.Offset)
                    wait(0.05)
                    captchaFrame.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 5, originalPos.Y.Scale, originalPos.Y.Offset)
                    wait(0.05)
                end
                captchaFrame.Position = originalPos
                
                return false
            end
        end
        
        local function isCaptchaVerified()
            return captchaVerified
        end
        
        local keyInput = Instance.new("TextBox")
        if settings.require_captcha then
            keyInput.Size = UDim2.new(0.8, 0, 0, 45)
            keyInput.Position = UDim2.new(0.1, 0, 0.47, 0)
        else
            keyInput.Size = UDim2.new(0.8, 0, 0, 45)
            keyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
        end
        keyInput.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
        keyInput.BorderColor3 = Color3.fromRGB(200, 200, 200)
        keyInput.BorderSizePixel = 1
        keyInput.Text = ""
        keyInput.PlaceholderText = "Enter your license key here..."
        keyInput.TextColor3 = Color3.fromRGB(0, 0, 0)
        keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        keyInput.TextSize = 14
        keyInput.Font = Enum.Font.Gotham
        
        local statusLabel = Instance.new("TextLabel")
        if settings.require_captcha then
            statusLabel.Size = UDim2.new(0.8, 0, 0, 30)
            statusLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
        else
            statusLabel.Size = UDim2.new(0.8, 0, 0, 40)
            statusLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
        end
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "Waiting for key..."
        statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
        statusLabel.TextSize = 12
        statusLabel.Font = Enum.Font.Gotham
        
        local discordButton = Instance.new("TextButton")
        if settings.require_captcha then
            discordButton.Size = UDim2.new(0.8, 0, 0, 35)
            discordButton.Position = UDim2.new(0.1, 0, 0.68, 0)
        else
            discordButton.Size = UDim2.new(0.8, 0, 0, 35)
            discordButton.Position = UDim2.new(0.1, 0, 0.65, 0)
        end
        discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        discordButton.Text = "GET YOUR KEY HERE"
        discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        discordButton.TextSize = 13
        discordButton.Font = Enum.Font.GothamBold
        discordButton.BorderSizePixel = 0
        
        local submitBtn = Instance.new("TextButton")
        if settings.require_captcha then
            submitBtn.Size = UDim2.new(0.6, 0, 0, 45)
            submitBtn.Position = UDim2.new(0.2, 0, 0.78, 0)
        else
            submitBtn.Size = UDim2.new(0.6, 0, 0, 45)
            submitBtn.Position = UDim2.new(0.2, 0, 0.78, 0)
        end
        submitBtn.BackgroundColor3 = settings.ui_settings.accent_color
        submitBtn.Text = "UNLOCK " .. settings.script_name:upper()
        submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        submitBtn.TextSize = 14
        submitBtn.Font = Enum.Font.GothamBold
        submitBtn.BorderSizePixel = 0
        
        local function copyToClipboard(text)
            local success = pcall(function()
                if setclipboard then
                    setclipboard(text)
                elseif toclipboard then
                    toclipboard(text)
                elseif set_clipboard then
                    set_clipboard(text)
                else
                    return false
                end
                return true
            end)
            return success
        end
        
        local function showCopyNotification()
            local notification = Instance.new("Frame")
            notification.Size = UDim2.new(0, 200, 0, 30)
            notification.Position = UDim2.new(0.5, -100, 0.85, 0)
            notification.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            notification.BackgroundTransparency = 0.2
            notification.BorderSizePixel = 0
            notification.Parent = mainFrame
            
            local notifyText = Instance.new("TextLabel")
            notifyText.Size = UDim2.new(1, 0, 1, 0)
            notifyText.BackgroundTransparency = 1
            notifyText.Text = "Link copied to clipboard"
            notifyText.TextColor3 = Color3.fromRGB(255, 255, 255)
            notifyText.TextSize = 12
            notifyText.Font = Enum.Font.Gotham
            notifyText.Parent = notification
            
            game:GetService("Debris"):AddItem(notification, 2)
            for i = 1, 10 do
                wait(0.1)
                notification.BackgroundTransparency = 0.2 + (i / 10)
                notifyText.TextTransparency = i / 10
            end
            notification:Destroy()
        end
        
        -- Assemble UI
        captchaText.Parent = captchaFrame
        captchaInput.Parent = captchaFrame
        refreshCaptchaBtn.Parent = captchaFrame
        captchaLabel.Parent = captchaFrame
        
        titleBar.Parent = mainFrame
        title.Parent = titleBar
        closeBtn.Parent = titleBar
        lockIcon.Parent = mainFrame
        instructionLabel.Parent = mainFrame
        
        if settings.require_captcha then
            captchaFrame.Parent = mainFrame
        end
        
        keyInput.Parent = mainFrame
        statusLabel.Parent = mainFrame
        discordButton.Parent = mainFrame
        submitBtn.Parent = mainFrame
        mainFrame.Parent = screenGui
        
        -- Set up CAPTCHA events
        if settings.require_captcha then
            refreshCaptcha()
            
            refreshCaptchaBtn.MouseButton1Click:Connect(function()
                refreshCaptcha()
            end)
            
            captchaInput.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    verifyCaptcha()
                end
            end)
            
            captchaInput.Changed:Connect(function()
                if captchaVerified then
                    captchaVerified = false
                    captchaFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
                    captchaFrame.BorderColor3 = Color3.fromRGB(220, 220, 220)
                    captchaStatus.Text = ""
                end
            end)
        end
        
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
        
        -- Discord button functionality
        discordButton.MouseEnter:Connect(function()
            discordButton.BackgroundColor3 = Color3.fromRGB(108, 121, 252)
        end)
        
        discordButton.MouseLeave:Connect(function()
            discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        end)
        
        discordButton.MouseButton1Click:Connect(function()
            local success = copyToClipboard(settings.discord_link)
            
            if success then
                showCopyNotification()
            else
                local failNotif = Instance.new("Frame")
                failNotif.Size = UDim2.new(0, 250, 0, 40)
                failNotif.Position = UDim2.new(0.5, -125, 0.85, 0)
                failNotif.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                failNotif.BackgroundTransparency = 0.2
                failNotif.BorderSizePixel = 0
                failNotif.Parent = mainFrame
                
                local failText = Instance.new("TextLabel")
                failText.Size = UDim2.new(1, 0, 1, 0)
                failText.BackgroundTransparency = 1
                failText.Text = "Copy manually: " .. settings.discord_link
                failText.TextColor3 = Color3.fromRGB(255, 255, 255)
                failText.TextSize = 10
                failText.Font = Enum.Font.Gotham
                failText.Parent = failNotif
                
                game:GetService("Debris"):AddItem(failNotif, 3)
                for i = 1, 15 do
                    wait(0.1)
                    failNotif.BackgroundTransparency = 0.2 + (i / 15)
                    failText.TextTransparency = i / 15
                end
                failNotif:Destroy()
            end
        end)
        
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
        
        return keyInput, statusLabel, submitBtn, closeBtn, discordButton, screenGui, mainFrame, 
               {isVerified = isCaptchaVerified, verify = verifyCaptcha}
    end
    
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
                return true, "Key accepted. Loading " .. settings.script_name
            else
                return false, "Error loading script: " .. tostring(err)
            end
        else
            return false, "Invalid key. Please check your license key."
        end
    end
    
    local function fadeOutAndDestroy(screenGui, mainFrame)
        if not screenGui or not mainFrame then return end
        
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
        
        pcall(function()
            screenGui:Destroy()
        end)
    end
    
    local function start()
        local keyInput, statusLabel, submitBtn, closeBtn, discordButton, screenGui, mainFrame, captchaControls = createUI()
        local uiDestroyed = false
        local isProcessing = false
        
        local function cleanupUI()
            if uiDestroyed then return end
            uiDestroyed = true
            fadeOutAndDestroy(screenGui, mainFrame)
        end
        
        local function onSubmit()
            if uiDestroyed or isProcessing then return end
            
            -- Check CAPTCHA if required
            if settings.require_captcha and captchaControls then
                -- First verify the CAPTCHA
                local verified = captchaControls.verify()
                if not verified then
                    statusLabel.Text = "Please enter the correct CAPTCHA code!"
                    statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    wait(1.5)
                    if not uiDestroyed then
                        statusLabel.Text = "Waiting for key..."
                        statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
                    end
                    return
                end
            end
            
            local enteredKey = keyInput.Text
            if enteredKey == "" then
                statusLabel.Text = "Please enter a key"
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                return
            end
            
            isProcessing = true
            statusLabel.Text = "Verifying key..."
            statusLabel.TextColor3 = Color3.fromRGB(0, 100, 200)
            submitBtn.Text = "VERIFYING..."
            submitBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            submitBtn.AutoButtonColor = false
            
            wait(0.3)
            
            local success, message = verifyAndLoad(enteredKey)
            statusLabel.Text = message
            
            if success then
                statusLabel.TextColor3 = Color3.fromRGB(0, 150, 0)
                cleanupUI()
            else
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                keyInput.Text = ""
                
                -- Shake effect
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
                
                submitBtn.Text = "UNLOCK " .. settings.script_name:upper()
                submitBtn.BackgroundColor3 = settings.ui_settings.accent_color
                submitBtn.AutoButtonColor = true
                isProcessing = false
                
                wait(1.5)
                if not uiDestroyed then
                    statusLabel.Text = "Waiting for key..."
                    statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
                end
            end
        end
        
        submitBtn.MouseButton1Click:Connect(onSubmit)
        
        keyInput.FocusLost:Connect(function(enterPressed)
            if enterPressed and not uiDestroyed and not isProcessing then
                onSubmit()
            end
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            cleanupUI()
        end)
    end
    
    return {start = start}
end

return KeySystem
