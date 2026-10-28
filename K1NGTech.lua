local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local DETECT_ID = "rbxassetid://10503381238"
local DASH_ANIM_ID = "rbxassetid://10479335397"

local DASH_CANCEL_DELAY = 0.45
local LOCK_DURATION = 0.63
local LOOP_DELAY = 0.31
local FLICK_DELAY = 0.23
local JUMP_VELOCITY = 50
local FLICK_INTENSITY = 1
local FLICK_SMOOTHING = 1
local JUMP_INTENSITY = 37

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local SCRIPT_ENABLED = false
local isLoopActive = false
local scriptGeneration = 0

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "K1NGTechUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.fromOffset(145, 58)
frame.Position = UDim2.new(0.5, -72, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 7)
frameCorner.Parent = frame

local border = Instance.new("UIStroke")
border.Thickness = 2
border.Color = Color3.fromRGB(90, 40, 180)
border.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -28, 0, 27)
title.Position = UDim2.fromOffset(2, 1)
title.BackgroundTransparency = 1
title.Text = "K1NG TECH"
title.TextColor3 = Color3.fromRGB(150, 100, 255)
title.TextSize = 16
title.Font = Enum.Font.Arcade
title.TextScaled = false
title.TextWrapped = false
title.Rotation = 5
title.ZIndex = 2
title.Parent = frame

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 90, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(95, 75, 210)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 45, 115))
})
titleGradient.Parent = title

local configButton = Instance.new("TextButton")
configButton.Name = "ConfigButton"
configButton.Size = UDim2.fromOffset(21, 21)
configButton.Position = UDim2.new(1, -24, 0, 3)
configButton.BackgroundColor3 = Color3.fromRGB(45, 35, 100)
configButton.BorderSizePixel = 0
configButton.Text = "+"
configButton.TextColor3 = Color3.fromRGB(210, 190, 255)
configButton.TextSize = 19
configButton.Font = Enum.Font.GothamBold
configButton.AutoButtonColor = false
configButton.ZIndex = 5
configButton.Parent = frame

local configButtonCorner = Instance.new("UICorner")
configButtonCorner.CornerRadius = UDim.new(0, 5)
configButtonCorner.Parent = configButton

local toggle = Instance.new("TextButton")
toggle.Name = "ToggleButton"
toggle.Size = UDim2.new(1, -12, 0, 23)
toggle.Position = UDim2.fromOffset(6, 31)
toggle.BackgroundColor3 = Color3.fromRGB(55, 35, 105)
toggle.BorderSizePixel = 0
toggle.Text = "● OFF"
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.TextSize = 12
toggle.Font = Enum.Font.GothamBold
toggle.AutoButtonColor = false
toggle.Active = true
toggle.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5)
toggleCorner.Parent = toggle

local configPanel = Instance.new("ScrollingFrame")
configPanel.Name = "ConfigPanel"
configPanel.Size = UDim2.fromOffset(225, 280)
configPanel.Position = UDim2.new(0, 0, 1, 5)
configPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 22)
configPanel.BorderSizePixel = 0
configPanel.ScrollBarThickness = 4
configPanel.ScrollBarImageColor3 = Color3.fromRGB(115, 75, 220)
configPanel.CanvasSize = UDim2.fromOffset(0, 390)
configPanel.AutomaticCanvasSize = Enum.AutomaticSize.None
configPanel.Visible = false
configPanel.Active = true
configPanel.ZIndex = 10
configPanel.Parent = frame

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 7)
panelCorner.Parent = configPanel

local panelStroke = Instance.new("UIStroke")
panelStroke.Thickness = 1.5
panelStroke.Color = Color3.fromRGB(100, 65, 200)
panelStroke.Parent = configPanel

local panelTitle = Instance.new("TextLabel")
panelTitle.Size = UDim2.new(1, -12, 0, 28)
panelTitle.Position = UDim2.fromOffset(6, 4)
panelTitle.BackgroundTransparency = 1
panelTitle.Text = "K1NG TECH CONFIG"
panelTitle.TextColor3 = Color3.fromRGB(175, 135, 255)
panelTitle.Font = Enum.Font.GothamBold
panelTitle.TextSize = 14
panelTitle.ZIndex = 11
panelTitle.Parent = configPanel

local configRows = {}

local function createConfigRow(name, variableName, value, yPosition, unused)
    local row = Instance.new("Frame")
    row.Name = variableName .. "Row"
    row.Size = UDim2.new(1, -12, 0, 32)
    row.Position = UDim2.fromOffset(6, yPosition)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    row.BorderSizePixel = 0
    row.ZIndex = 11
    row.Parent = configPanel

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 4)
    rowCorner.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.62, -4, 1, 0)
    label.Position = UDim2.fromOffset(5, 0)
    label.BackgroundTransparency = 1
    label.Text = unused and (name .. " *") or name
    label.TextColor3 = unused
        and Color3.fromRGB(130, 130, 145)
        or Color3.fromRGB(220, 215, 245)
    label.TextSize = 10
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 12
    label.Parent = row

    local box = Instance.new("TextBox")
    box.Name = variableName .. "Input"
    box.Size = UDim2.new(0.38, -6, 0, 24)
    box.Position = UDim2.new(0.62, 0, 0.5, -12)
    box.BackgroundColor3 = Color3.fromRGB(38, 32, 75)
    box.BorderSizePixel = 0
    box.Text = tostring(value)
    box.TextColor3 = Color3.fromRGB(235, 225, 255)
    box.TextSize = 11
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    box.TextEditable = not unused
    box.Active = true
    box.ZIndex = 12
    box.Parent = row

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = box

    configRows[variableName] = box
end

createConfigRow("DASH CANCEL", "DASH_CANCEL_DELAY", DASH_CANCEL_DELAY, 38)
createConfigRow("LOCK DURATION", "LOCK_DURATION", LOCK_DURATION, 74)
createConfigRow("LOOP DELAY", "LOOP_DELAY", LOOP_DELAY, 110)
createConfigRow("FLICK DELAY", "FLICK_DELAY", FLICK_DELAY, 146)
createConfigRow("JUMP VELOCITY", "JUMP_VELOCITY", JUMP_VELOCITY, 182)
createConfigRow("FLICK INTENSITY", "FLICK_INTENSITY", FLICK_INTENSITY, 218)
createConfigRow("FLICK SMOOTHING", "FLICK_SMOOTHING", FLICK_SMOOTHING, 254)
createConfigRow("JUMP INTENSITY", "JUMP_INTENSITY", JUMP_INTENSITY, 290, true)

local applyButton = Instance.new("TextButton")
applyButton.Name = "ApplyButton"
applyButton.Size = UDim2.new(1, -12, 0, 30)
applyButton.Position = UDim2.fromOffset(6, 328)
applyButton.BackgroundColor3 = Color3.fromRGB(80, 50, 160)
applyButton.BorderSizePixel = 0
applyButton.Text = "APPLY SETTINGS"
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyButton.TextSize = 12
applyButton.Font = Enum.Font.GothamBold
applyButton.AutoButtonColor = false
applyButton.ZIndex = 11
applyButton.Parent = configPanel

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 5)
applyCorner.Parent = applyButton

local configStatus = Instance.new("TextLabel")
configStatus.Size = UDim2.new(1, -12, 0, 20)
configStatus.Position = UDim2.fromOffset(6, 360)
configStatus.BackgroundTransparency = 1
configStatus.Text = "* JUMP INTENSITY is unused"
configStatus.TextColor3 = Color3.fromRGB(145, 135, 170)
configStatus.TextSize = 9
configStatus.Font = Enum.Font.Gotham
configStatus.ZIndex = 11
configStatus.Parent = configPanel

local function updateToggle()
    if SCRIPT_ENABLED then
        toggle.Text = "● ON"
        toggle.BackgroundColor3 = Color3.fromRGB(65, 45, 150)
    else
        toggle.Text = "● OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(55, 35, 105)
    end
end

toggle.Activated:Connect(function()
    SCRIPT_ENABLED = not SCRIPT_ENABLED
    scriptGeneration += 1

    if not SCRIPT_ENABLED then
        isLoopActive = false

        if humanoid and humanoid.Parent then
            humanoid.AutoRotate = true
        end
    end

    updateToggle()
end)

configButton.Activated:Connect(function()
    configPanel.Visible = not configPanel.Visible
    configButton.Text = configPanel.Visible and "−" or "+"
end)

applyButton.Activated:Connect(function()
    local newValues = {}

    for variableName, box in pairs(configRows) do
        if variableName ~= "JUMP_INTENSITY" then
            local value = tonumber(box.Text)

            if not value or value ~= value or value == math.huge or value == -math.huge then
                configStatus.Text = "Invalid number: " .. variableName
                configStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
                return
            end

            newValues[variableName] = value
        end
    end

    DASH_CANCEL_DELAY = math.clamp(newValues.DASH_CANCEL_DELAY, 0, 10)
    LOCK_DURATION = math.clamp(newValues.LOCK_DURATION, 0, 10)
    LOOP_DELAY = math.clamp(newValues.LOOP_DELAY, 0, 10)
    FLICK_DELAY = math.clamp(newValues.FLICK_DELAY, 0, 10)
    JUMP_VELOCITY = math.clamp(newValues.JUMP_VELOCITY, -500, 500)
    FLICK_INTENSITY = math.clamp(newValues.FLICK_INTENSITY, 0, 1)
    FLICK_SMOOTHING = math.clamp(newValues.FLICK_SMOOTHING, 0, 1)

    configRows.DASH_CANCEL_DELAY.Text = tostring(DASH_CANCEL_DELAY)
    configRows.LOCK_DURATION.Text = tostring(LOCK_DURATION)
    configRows.LOOP_DELAY.Text = tostring(LOOP_DELAY)
    configRows.FLICK_DELAY.Text = tostring(FLICK_DELAY)
    configRows.JUMP_VELOCITY.Text = tostring(JUMP_VELOCITY)
    configRows.FLICK_INTENSITY.Text = tostring(FLICK_INTENSITY)
    configRows.FLICK_SMOOTHING.Text = tostring(FLICK_SMOOTHING)

    configStatus.Text = "Settings applied!"
    configStatus.TextColor3 = Color3.fromRGB(130, 255, 170)
end)

task.spawn(function()
    local hue = 0

    while screenGui.Parent do
        hue = (hue + 0.008) % 1
        border.Color = Color3.fromHSV(hue, 1, 1)
        task.wait(0.02)
    end
end)

local dragging = false
local dragStart
local startPosition
local activeTouch
local activeInput

local function getPosition(input)
    return Vector2.new(input.Position.X, input.Position.Y)
end

local function beginDrag(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        activeTouch = input
        dragStart = getPosition(input)
        startPosition = frame.Position
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        activeInput = input
        dragStart = getPosition(input)
        startPosition = frame.Position
    end
end

frame.InputBegan:Connect(beginDrag)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    local validInput =
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input == activeTouch

    if not validInput then
        return
    end

    local delta = getPosition(input) - dragStart

    frame.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input == activeTouch then
        dragging = false
        activeTouch = nil
        activeInput = nil
    end
end)

local function getClosestTarget()
    local liveFolder = workspace:FindFirstChild("Live")

    if not liveFolder or not rootPart or not rootPart.Parent then
        return nil
    end

    local closestTarget
    local maxDistance = 150

    for _, obj in pairs(liveFolder:GetChildren()) do
        if obj:IsA("Model") and obj ~= character then
            if obj.Name == "Weakest Dummy"
                or Players:GetPlayerFromCharacter(obj) then

                local targetRoot = obj:FindFirstChild("HumanoidRootPart")

                if targetRoot then
                    local distance =
                        (rootPart.Position - targetRoot.Position).Magnitude

                    if distance < maxDistance then
                        maxDistance = distance
                        closestTarget = obj
                    end
                end
            end
        end
    end

    return closestTarget
end

local function startFlick()
    if not SCRIPT_ENABLED then
        return
    end

    local targetModel = getClosestTarget()

    if not targetModel then
        return
    end

    local targetRoot = targetModel:FindFirstChild("HumanoidRootPart")

    if not targetRoot then
        return
    end

    local startTime = tick()
    local connection

    connection = RunService.Heartbeat:Connect(function()
        if not SCRIPT_ENABLED
            or not rootPart
            or not rootPart.Parent
            or not humanoid
            or not humanoid.Parent then

            if humanoid and humanoid.Parent then
                humanoid.AutoRotate = true
            end

            connection:Disconnect()
            return
        end

        local elapsed = tick() - startTime

        if elapsed > LOCK_DURATION
            or not targetRoot
            or not targetRoot.Parent then

            humanoid.AutoRotate = true
            connection:Disconnect()
            return
        end

        humanoid.AutoRotate = false

        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
        local velocity = targetRoot.AssemblyLinearVelocity
        local pTime = (0.4 - elapsed) + ping

        local pX = targetRoot.Position.X + velocity.X * pTime
        local pZ = targetRoot.Position.Z + velocity.Z * pTime
        local pY = targetRoot.Position.Y
            + velocity.Y * pTime
            - (0.5 * workspace.Gravity * pTime ^ 2)

        local currentLerp =
            elapsed < 0.05 and FLICK_INTENSITY or FLICK_SMOOTHING

        local finalPos = Vector3.new(
            pX,
            rootPart.Position.Y,
            pZ
        )

        local goalCFrame = CFrame.lookAt(rootPart.Position, finalPos)

        rootPart.CFrame = rootPart.CFrame:Lerp(
            goalCFrame,
            currentLerp
        )
    end)
end

local function fireDash()
    if not SCRIPT_ENABLED then
        return
    end

    local remote = character:FindFirstChild("Communicate")

    if remote then
        remote:FireServer({
            Dash = Enum.KeyCode.W,
            Key = Enum.KeyCode.Q,
            Goal = "KeyPress"
        })
    end
end

local function connectAnimator(currentAnimator)
    currentAnimator.AnimationPlayed:Connect(function(animTrack)
        if not SCRIPT_ENABLED then
            return
        end

        local animation = animTrack.Animation

        if not animation then
            return
        end

        if animation.AnimationId == DASH_ANIM_ID and isLoopActive then
            local currentGeneration = scriptGeneration

            task.delay(DASH_CANCEL_DELAY, function()
                if not SCRIPT_ENABLED
                    or currentGeneration ~= scriptGeneration
                    or not rootPart
                    or not rootPart.Parent then
                    return
                end

                local velocity = rootPart.AssemblyLinearVelocity

                rootPart.AssemblyLinearVelocity = Vector3.new(
                    0,
                    velocity.Y,
                    0
                )

                for _, obj in pairs(rootPart:GetChildren()) do
                    if obj:IsA("BodyVelocity")
                        or obj:IsA("LinearVelocity") then
                        obj:Destroy()
                    end
                end
            end)
        end

        if animation.AnimationId == DETECT_ID then
            if isLoopActive then
                return
            end

            isLoopActive = true
            local currentGeneration = scriptGeneration

            task.spawn(function()
                task.wait(LOOP_DELAY)

                if not SCRIPT_ENABLED
                    or currentGeneration ~= scriptGeneration
                    or not rootPart
                    or not rootPart.Parent then
                    isLoopActive = false
                    return
                end

                rootPart.AssemblyLinearVelocity = Vector3.new(
                    rootPart.AssemblyLinearVelocity.X,
                    JUMP_VELOCITY,
                    rootPart.AssemblyLinearVelocity.Z
                )

                fireDash()

                task.wait(FLICK_DELAY)

                if SCRIPT_ENABLED
                    and currentGeneration == scriptGeneration then
                    startFlick()
                end

                task.wait(0.5)

                if currentGeneration == scriptGeneration then
                    isLoopActive = false
                end
            end)
        end
    end)
end

connectAnimator(animator)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    animator = humanoid:WaitForChild("Animator")

    isLoopActive = false

    connectAnimator(animator)
end)

updateToggle()