game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "Loaded", -- Required
	Text = "Hydro ESP Has Loaded!", -- Required
})






-- Create the GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 380)  -- Extended frame height for new buttons
frame.Position = UDim2.new(0, -220, 0, 10)  -- Start off-screen (for animation)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true  -- Hide anything outside of the frame
frame.Parent = screenGui

-- Add rounded corners to the frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Hydro ESP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.BackgroundTransparency = 1
title.TextStrokeTransparency = 0.8
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
title.Parent = frame

-- Function to create buttons with consistent styling
local function createButton(text, position)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 40)
    button.Position = position
    button.Text = text
    button.BackgroundTransparency = 1
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 20
    button.TextStrokeTransparency = 0.8
    button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    button.Font = Enum.Font.GothamBold
    button.Parent = frame

    -- Hover effect
    button.MouseEnter:Connect(function()
        button.TextColor3 = Color3.fromRGB(255, 165, 0)  -- Orange when hovered
    end)

    button.MouseLeave:Connect(function()
        button.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White when not hovered
    end)

    return button
end

-- Create buttons
local espButton = createButton("ESP Boxes", UDim2.new(0, 0, 0, 40))
local lockonButton = createButton("Lockon", UDim2.new(0, 0, 0, 90))
local adminButton = createButton("Get Admin", UDim2.new(0, 0, 0, 140))
local wallhaxButton = createButton("Wallhax", UDim2.new(0, 0, 0, 190))
local walkspeedButton = createButton("Walkspeed", UDim2.new(0, 0, 0, 240))
local killAllButton = createButton("Kill All", UDim2.new(0, 0, 0, 290))
local floatButton = createButton("Float", UDim2.new(0, 0, 0, 340))

-- Add shadow to the frame
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(0, 220, 0, 380)
shadow.Position = UDim2.new(0, 10, 0, 10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://3011648356"  -- Shadow image
shadow.ImageTransparency = 0.5
shadow.Parent = screenGui

-- Make the GUI draggable
local dragToggle = nil
local dragSpeed = 0.2
local dragStart = nil
local startPos = nil

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragToggle then
        update(input)
    end
end)

-- Opening Animation
local isOpen = false
local tweenService = game:GetService("TweenService")
local openTween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Position = UDim2.new(0, 10, 0, 10)})
local closeTween = tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.In), {Position = UDim2.new(0, -220, 0, 10)})

-- Toggle GUI Visibility with K key
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        if isOpen then
            closeTween:Play()
        else
            openTween:Play()
        end
        isOpen = not isOpen
    end
end)

-- ESP Boxes Functionality (Client-Sided)
local espActive = false

function toggleESP()
    espActive = not espActive
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= player.Character then  -- Avoid highlighting own character
            if espActive then
                local box = Instance.new("SelectionBox")
                box.Adornee = v.PrimaryPart
                box.Color3 = Color3.fromRGB(255, 165, 0)
                box.Parent = v
            else
                for _, child in pairs(v:GetChildren()) do
                    if child:IsA("SelectionBox") then
                        child:Destroy()
                    end
                end
            end
        end
    end
end

espButton.MouseButton1Click:Connect(toggleESP)

-- Lockon Functionality (Only for real players and dummy models)
local lockonActive = false
local lockonTarget = nil

function lockon()
    lockonActive = not lockonActive
    if lockonActive then
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = input.Position
                local ray = workspace.CurrentCamera:ScreenPointToRay(mousePos.X, mousePos.Y)
                local hitPart, hitPos = workspace:FindPartOnRay(ray)
                
                if hitPart and hitPart.Parent and (hitPart.Parent:FindFirstChild("Humanoid") or hitPart.Parent:FindFirstChild("Dummy")) then
                    lockonTarget = hitPart.Parent
                else
                    lockonTarget = nil
                end
            end
        end)
    else
        lockonTarget = nil
    end
end

lockonButton.MouseButton1Click:Connect(lockon)

-- Get Admin Button Functionality (HD Admin)
adminButton.MouseButton1Click:Connect(function()
    local success, msg = pcall(function()
        -- Assuming HD Admin is installed as a module, you can load it
        local hdAdmin = require(game:GetService("ServerScriptService"):WaitForChild("HDAdmin"))
        hdAdmin:GiveAccess(player)
    end)
    
    if not success then
        warn("Failed to load HD Admin: " .. msg)
    end
end)

-- Wallhax Functionality
local wallhaxActive = false

function toggleWallhax()
    wallhaxActive = not wallhaxActive
    if wallhaxActive then
        -- Allow the player to walk through walls
        player.Character.Humanoid.WalkSpeed = 50  -- Set a higher walk speed (or just use default)
        player.Character.Humanoid.PlatformStand = true  -- Disable platform collision
    else
        -- Revert back to normal walking
        player.Character.Humanoid.PlatformStand = false
        player.Character.Humanoid.WalkSpeed = 16  -- Default walking speed
    end
end

wallhaxButton.MouseButton1Click:Connect(toggleWallhax)

-- Walkspeed Button Functionality
walkspeedButton.MouseButton1Click:Connect(function()
    player.Character.Humanoid.WalkSpeed = 1000  -- Set walkspeed to 1000
end)

-- Kill All Functionality
killAllButton.MouseButton1Click:Connect(function()
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then  -- Don't kill the local player
            local character = otherPlayer.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.Health = 0  -- Kill the player
            end
        end
    end
end)

-- Float Functionality
local floating = false

floatButton.MouseButton1Click:Connect(function()
    floating = not floating
    if floating then
        -- Set humanoid root part to a fixed position (floating effect)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bodyGyro = Instance.new("BodyGyro")
            local bodyPosition = Instance.new("BodyPosition")
            bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
            bodyGyro.D = 10
            bodyGyro.Parent = hrp
            bodyPosition.MaxForce = Vector3.new(400000, 400000, 400000)
            bodyPosition.D = 10
            bodyPosition.Parent = hrp
            bodyPosition.Position = hrp.Position
        end
    else
        -- Reset floating effect by removing BodyGyro and BodyPosition
        for _, v in pairs(player.Character.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyGyro") or v:IsA("BodyPosition") then
                v:Destroy()
            end
        end
    end
end)

-- End of script
