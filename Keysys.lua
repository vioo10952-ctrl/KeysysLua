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
            height = config.height or 520, -- Increased height for key display
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
    
    -- Get a random valid key to reveal
    local function getRandomKey()
        if #settings.valid_keys > 0 then
            return settings.valid_keys[math.random(1, #settings.valid_keys)]
        end
        return "NO_KEY_AVAILABLE"
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
        lockIcon.Position = UDim2.new(0.5, -30, 0.03, 0)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Image = "rbxassetid://5513462875"
        lockIcon.ImageColor3 = Color3.fromRGB(0, 0, 0)
        
        local instructionLabel = Instance.new("TextLabel")
        instructionLabel.Size = UDim2.new(0.8, 0, 0, 30)
        instructionLabel.Position = UDim2.new(0.1, 0, 0.14, 0)
        instructionLabel.BackgroundTransparency = 1
        instructionLabel.Text = "Solve the CAPTCHA to get your license key"
        instructionLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
        instructionLabel.TextSize = 13
        instructionLabel.Font = Enum.Font.Gotham
        
        -- CAPTCHA Section
        local captchaFrame = Instance.new("Frame")
        captchaFrame.Size = UDim2.new(0.9, 0, 0, 100)
        captchaFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
        captchaFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
        captchaFrame.BorderSizePixel = 1
        captchaFrame.BorderColor3 = Color3.fromRGB(220, 220, 220)
        
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
        captchaText.Size = UDim2.new(0.55, 0, 0, 40)
        captchaText.Position = UDim2.new(0.05, 0, 0.32, 0)
        captchaText.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        captchaText.BackgroundTransparency = 0.1
        captchaText.Text = ""
        captchaText.TextColor3 = Color3.fromRGB(0, 0, 0)
        captchaText.TextSize = 24
        captchaText.Font = Enum.Font.GothamBold
        captchaText.TextScaled = true
        
        local captchaInput = Instance.new("TextBox")
        captchaInput.Size = UDim2.new(0.3, 0, 0, 40)
        captchaInput.Position = UDim2.new(0.62, 0, 0.32, 0)
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
        refreshCaptchaBtn.Position = UDim2.new(0.94, 0, 0.37, 0)
        refreshCaptchaBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        refreshCaptchaBtn.Text = "↻"
        refreshCaptchaBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        refreshCaptchaBtn.TextSize = 20
        refreshCaptchaBtn.Font = Enum.Font.GothamBold
        refreshCaptchaBtn.BorderSizePixel = 0
        
        local captchaStatus = Instance.new("TextLabel")
        captchaStatus.Size = UDim2.new(1, 0, 0, 20)
        captchaStatus.Position = UDim2.new(0, 0, 0.75, 0)
        captchaStatus.BackgroundTransparency = 1
        captchaStatus.Text = ""
        captchaStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
        captchaStatus.TextSize = 11
        captchaStatus.Font = Enum.Font.Gotham
        captchaStatus.Parent = captchaFrame
        
        -- Key Display Section (appears after CAPTCHA)
        local keyDisplayFrame = Instance.new("Frame")
        keyDisplayFrame.Size = UDim2.new(0.9, 0, 0, 100)
        keyDisplayFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
        keyDisplayFrame.BackgroundColor3 = Color3.fromRGB(240, 248, 255)
        keyDisplayFrame.BorderSizePixel = 2
        keyDisplayFrame.BorderColor3 = settings.ui_settings.accent_color
        keyDisplayFrame.Visible = false
        
        local keyDisplayLabel = Instance.new("TextLabel")
        keyDisplayLabel.Size = UDim2.new(1, 0, 0, 30)
        keyDisplayLabel.Position = UDim2.new(0, 0, 0, 0)
        keyDisplayLabel.BackgroundTransparency = 1
        keyDisplayLabel.Text = "✓ Your License Key:"
        keyDisplayLabel.TextColor3 = Color3.fromRGB(0, 150, 0)
        keyDisplayLabel.TextSize = 14
        keyDisplayLabel.Font = Enum.Font.GothamBold
        keyDisplayLabel.Parent = keyDisplayFrame
        
        local revealedKeyText = Instance.new("TextLabel")
        revealedKeyText.Size = UDim2.new(0.9, 0, 0, 40)
        revealedKeyText.Position = UDim2.new(0.05, 0, 0.4, 0)
        revealedKeyText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        revealedKeyText.BorderSizePixel = 1
        revealedKeyText.BorderColor3 = Color3.fromRGB(200, 200, 200)
        revealedKeyText.Text = ""
        revealedKeyText.TextColor3 = Color3.fromRGB(0, 0, 0)
        revealedKeyText.TextSize = 18
        revealedKeyText.Font = Enum.Font.GothamBold
        revealedKeyText.TextScaled = true
        revealedKeyText.Parent = keyDisplayFrame
        
        local copyKeyBtn = Instance.new("TextButton")
        copyKeyBtn.Size = UDim2.new(0.3, 0, 0, 30)
        copyKeyBtn.Position = UDim2.new(0.35, 0, 0.65, 0)
        copyKeyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        copyKeyBtn.Text = "COPY KEY"
        copyKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyKeyBtn.TextSize = 12
        copyKeyBtn.Font = Enum.Font.GothamBold
        copyKeyBtn.BorderSizePixel = 0
        copyKeyBtn.Parent = keyDisplayFrame
        
        local keyInput = Instance.new("TextBox")
        keyInput.Size = UDim2.new(0.8, 0, 0, 45)
        keyInput.Position = UDim2.new(0.1, 0, 0.67, 0)
        keyInput.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
        keyInput.BorderColor3 = Color3.fromRGB(200, 200, 200)
        keyInput.BorderSizePixel = 1
        keyInput.Text = ""
        keyInput.PlaceholderText = "Paste your license key here..."
        keyInput.TextColor3 = Color3.fromRGB(0, 0, 0)
        keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        keyInput.TextSize = 14
        keyInput.Font = Enum.Font.Gotham
        
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(0.8, 0, 0, 30)
        statusLabel.Position = UDim2.new(0.1, 0, 0.78, 0)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "Complete CAPTCHA to get your key"
        statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
        statusLabel.TextSize = 12
        statusLabel.Font = Enum.Font.Gotham
        
        local discordButton = Instance.new("TextButton")
        discordButton.Size = UDim2.new(0.8, 0, 0, 35)
        discordButton.Position = UDim2.new(0.1, 0, 0.85, 0)
        discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        discordButton.Text = "DISCORD (NEED HELP?)"
        discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        discordButton.TextSize = 13
        discordButton.Font = Enum.Font.GothamBold
        discordButton.BorderSizePixel = 0
        
        local submitBtn = Instance.new("TextButton")
        submitBtn.Size = UDim2.new(0.6, 0, 0, 45)
        submitBtn.Position = UDim2.new(0.2, 0, 0.92, 0)
        submitBtn.BackgroundColor3 = settings.ui_settings.accent_color
        submitBtn.Text = "UNLOCK SCRIPT"
        submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        submitBtn.TextSize = 14
        submitBtn.Font = Enum.Font.GothamBold
        submitBtn.BorderSizePixel = 0
        
        local currentCaptcha = ""
        local revealedKey = ""
        local captchaSolved = false
        
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
        
        local function showCopyNotification(notificationText)
            local notification = Instance.new("Frame")
            notification.Size = UDim2.new(0, 200, 0, 30)
            notification.Position = UDim2.new(0.5, -100, 0.88, 0)
            notification.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            notification.BackgroundTransparency = 0.2
            notification.BorderSizePixel = 0
            notification.Parent = mainFrame
            
            local notifyText = Instance.new("TextLabel")
            notifyText.Size = UDim2.new(1, 0, 1, 0)
            notifyText.BackgroundTransparency = 1
            notifyText.Text = notificationText or "Copied to clipboard!"
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
        
        local function refreshCaptcha()
            currentCaptcha = generateCaptcha()
            captchaText.Text = currentCaptcha
            captchaInput.Text = ""
            captchaStatus.Text = ""
            captchaSolved = false
            keyDisplayFrame.Visible = false
            keyInput.Text = ""
            captchaFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            captchaFrame.BorderColor3 = Color3.fromRGB(220, 220, 220)
            captchaText.TextColor3 = Color3.fromRGB(math.random(0, 100), math.random(0, 100), math.random(0, 100))
            statusLabel.Text = "Complete CAPTCHA to get your key"
            statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
        end
        
        local function solveCaptcha()
            if string.upper(captchaInput.Text) == string.upper(currentCaptcha) then
                captchaSolved = true
                revealedKey = getRandomKey()
                
                -- Show success
                captchaStatus.Text = "✓ CAPTCHA Solved!"
                captchaStatus.TextColor3 = Color3.fromRGB(0, 150, 0)
                captchaFrame.BackgroundColor3 = Color3.fromRGB(230, 255, 230)
                captchaFrame.BorderColor3 = Color3.fromRGB(0, 200, 0)
                
                -- Reveal the key
                revealedKeyText.Text = revealedKey
                keyDisplayFrame.Visible = true
                statusLabel.Text = "Key revealed! Copy it and paste below"
                statusLabel.TextColor3 = Color3.fromRGB(0, 150, 0)
                
                -- Shine animation on the revealed key
                for i = 1, 3 do
                    revealedKeyText.BackgroundColor3 = Color3.fromRGB(255, 255, 200)
                    wait(0.1)
                    revealedKeyText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    wait(0.1)
                end
                
                return true
            else
                captchaSolved = false
                captchaStatus.Text = "✗ Incorrect code! Try again"
                captchaStatus.TextColor3 = Color3.fromRGB(255, 0, 0)
                captchaFrame.BackgroundColor3 = Color3.fromRGB(255, 230, 230)
                captchaFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
                keyDisplayFrame.Visible = false
                
                -- Shake effect
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
        captchaFrame.Parent = mainFrame
        keyDisplayFrame.Parent = mainFrame
        keyInput.Parent = mainFrame
        statusLabel.Parent = mainFrame
        discordButton.Parent = mainFrame
        submitBtn.Parent = mainFrame
        mainFrame.Parent = screenGui
        
        -- Set up CAPTCHA events
        refreshCaptcha()
        
        refreshCaptchaBtn.MouseButton1Click:Connect(function()
            refreshCaptcha()
        end)
        
        captchaInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                solveCaptcha()
            end
        end)
        
        -- Copy key button
        copyKeyBtn.MouseButton1Click:Connect(function()
            if revealedKey ~= "" then
                local success = copyToClipboard(revealedKey)
                if success then
                    showCopyNotification("Key copied to clipboard!")
                    keyInput.Text = revealedKey
                    statusLabel.Text = "Key pasted! Click UNLOCK SCRIPT"
                    statusLabel.TextColor3 = Color3.fromRGB(0, 150, 0)
                else
                    showCopyNotification("Copy manually: " .. revealedKey)
                end
            end
        end)
        
        copyKeyBtn.MouseEnter:Connect(function()
            copyKeyBtn.BackgroundColor3 = Color3.fromRGB(108, 121, 252)
        end)
        
        copyKeyBtn.MouseLeave:Connect(function()
            copyKeyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        end)
        
        -- Discord button
        discordButton.MouseEnter:Connect(function()
            discordButton.BackgroundColor3 = Color3.fromRGB(108, 121, 252)
        end)
        
        discordButton.MouseLeave:Connect(function()
            discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        end)
        
        discordButton.MouseButton1Click:Connect(function()
            local success = copyToClipboard(settings.discord_link)
            if success then
                showCopyNotification("Discord link copied!")
            else
                showCopyNotification("Join: " .. settings.discord_link)
            end
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
               {isSolved = function() return captchaSolved end, getKey = function() return revealedKey end}
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
                return true, "Key accepted! Loading " .. settings.script_name
            else
                return false, "Error loading script: " .. tostring(err)
            end
        else
            return false, "Invalid key. Make sure you solved the CAPTCHA first!"
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
            
            -- Check if CAPTCHA is solved
            if not captchaControls.isSolved() then
                statusLabel.Text = "You must solve the CAPTCHA first!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                
                -- Shake the CAPTCHA frame to draw attention
                local captchaFrame = mainFrame:FindFirstChildWhichIsA("Frame")
                if captchaFrame then
                    local originalPos = captchaFrame.Position
                    for i = 1, 3 do
                        captchaFrame.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 5, originalPos.Y.Scale, originalPos.Y.Offset)
                        wait(0.05)
                        captchaFrame.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 5, originalPos.Y.Scale, originalPos.Y.Offset)
                        wait(0.05)
                    end
                    captchaFrame.Position = originalPos
                end
                
                wait(1.5)
                if not uiDestroyed then
                    statusLabel.Text = "Solve the CAPTCHA to get your key"
                    statusLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
                end
                return
            end
            
            local enteredKey = keyInput.Text
            if enteredKey == "" then
                statusLabel.Text = "Please paste your license key"
                statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                return
            end
            
            isProcessing = true
            statusLabel.Text = "Verifying key..."
            statusLabel.TextColor3 = Color3.fromRGB(0, 100, 200)
            submitBtn.Text = "UNLOCKING..."
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
                
                submitBtn.Text = "UNLOCK SCRIPT"
                submitBtn.BackgroundColor3 = settings.ui_settings.accent_color
                submitBtn.AutoButtonColor = true
                isProcessing = false
                
                wait(1.5)
                if not uiDestroyed then
                    statusLabel.Text = "Use the key from CAPTCHA above"
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
