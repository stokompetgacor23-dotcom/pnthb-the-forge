repeat task.wait() until game:IsLoaded()

-- =======================================================
-- PINATHUB | THE FORGE (WINDUI v2)
-- =======================================================

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

-- ============================================
-- EXECUTOR COMPATIBILITY
-- ============================================
local function noop() end
local get_hui = gethui or (syn and syn.gethui) or noop
local set_clipboard = setclipboard or (syn and syn.setclipboard) or noop

-- ============================================
-- SERVICES (GAME SPECIFIC)
-- ============================================
local Services = {
    Inventory = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Packages") and ReplicatedStorage.Shared.Packages:FindFirstChild("Knit") and ReplicatedStorage.Shared.Packages.Knit:FindFirstChild("Services") and ReplicatedStorage.Shared.Packages.Knit.Services:FindFirstChild("InventoryService"),
    Proximity = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Packages") and ReplicatedStorage.Shared.Packages:FindFirstChild("Knit") and ReplicatedStorage.Shared.Packages.Knit:FindFirstChild("Services") and ReplicatedStorage.Shared.Packages.Knit.Services:FindFirstChild("ProximityService"),
    Dialogue = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Packages") and ReplicatedStorage.Shared.Packages:FindFirstChild("Knit") and ReplicatedStorage.Shared.Packages.Knit:FindFirstChild("Services") and ReplicatedStorage.Shared.Packages.Knit.Services:FindFirstChild("DialogueService"),
    Quest = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Packages") and ReplicatedStorage.Shared.Packages:FindFirstChild("Knit") and ReplicatedStorage.Shared.Packages.Knit:FindFirstChild("Services") and ReplicatedStorage.Shared.Packages.Knit.Services:FindFirstChild("QuestService"),
    Status = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Packages") and ReplicatedStorage.Shared.Packages:FindFirstChild("Knit") and ReplicatedStorage.Shared.Packages.Knit:FindFirstChild("Services") and ReplicatedStorage.Shared.Packages.Knit.Services:FindFirstChild("StatusService"),
    Character = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Packages") and ReplicatedStorage.Shared.Packages:FindFirstChild("Knit") and ReplicatedStorage.Shared.Packages.Knit:FindFirstChild("Services") and ReplicatedStorage.Shared.Packages.Knit.Services:FindFirstChild("CharacterService"),
    Tool = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Packages") and ReplicatedStorage.Shared.Packages:FindFirstChild("Knit") and ReplicatedStorage.Shared.Packages.Knit:FindFirstChild("Services") and ReplicatedStorage.Shared.Packages.Knit.Services:FindFirstChild("ToolService"),
    Forge = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Packages") and ReplicatedStorage.Shared.Packages:FindFirstChild("Knit") and ReplicatedStorage.Shared.Packages.Knit:FindFirstChild("Services") and ReplicatedStorage.Shared.Packages.Knit.Services:FindFirstChild("ForgeService"),
}

-- ============================================
-- PLAYER VARIABLES
-- ============================================
local player = LocalPlayer
local UIS = UserInputService

-- ============================================
-- LOGO LAUNCHER PINATHUB
-- ============================================
local logoGui = Instance.new("ScreenGui")
logoGui.Name = "PinatHubLogo"
logoGui.ResetOnSpawn = false
logoGui.Parent = player:WaitForChild("PlayerGui", 5)

local logoButton = Instance.new("ImageButton")
logoButton.Name = "LogoButton"
logoButton.Size = UDim2.new(0, 50, 0, 50)
logoButton.Position = UDim2.new(0.5, -25, 0.5, -25)
logoButton.BackgroundTransparency = 1
logoButton.Image = "rbxassetid://118264723961739"
logoButton.ImageColor3 = Color3.fromRGB(180, 0, 255)
logoButton.ScaleType = Enum.ScaleType.Fit
logoButton.Parent = logoGui

local uiCornerLogo = Instance.new("UICorner")
uiCornerLogo.CornerRadius = UDim.new(1, 0)
uiCornerLogo.Parent = logoButton

local hoverTween = TweenService:Create(logoButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)})
local unhoverTween = TweenService:Create(logoButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)})

logoButton.MouseEnter:Connect(function() hoverTween:Play() end)
logoButton.MouseLeave:Connect(function() unhoverTween:Play() end)

local dragging = false
local dragStart = nil
local startPos = nil

logoButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = logoButton.Position
    end
end)

logoButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragStart = nil
        startPos = nil
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and dragStart and startPos then
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            logoButton.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
        end
    end
end)

-- ============================================
-- LOAD WINDUI v2
-- ============================================
local WindUI = loadstring(game:HttpGet('https://github.com/Footagesus/WindUI/releases/latest/download/main.lua'))()

local window = WindUI:CreateWindow({
    Title = "PinatHub",
    Author = "@viunze on tiktok",
    Folder = "pinathub",
    Size = UDim2.fromOffset(500, 350),
    Transparent = true,
    Theme = "Dark",
    IsOpenButtonEnabled = false,
    UserEnabled = true,
    HasOutline = true,
    SideBarWidth = 150,
})

local guiVisible = true
logoButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    if window then
        pcall(function()
            if guiVisible then
                window:Open()
            else
                window:Minimize()
            end
        end)
    end
end)

-- Create Tabs
local tabs = {
    info = window:Tab({Title = "Info", Icon = "info"}),
    farm = window:Tab({Title = "Auto Farm", Icon = "pickaxe"}),
    combat = window:Tab({Title = "Combat", Icon = "sword"}),
    misc = window:Tab({Title = "Misc", Icon = "settings"}),
    settings = window:Tab({Title = "Settings", Icon = "cog"}),
    community = window:Tab({Title = "Community", Icon = "users"}),
}

-- ============================================
-- STATE VARIABLES
-- ============================================

-- Anti AFK
local antiAFKEnabled = false
local afkConnection = nil
local lastAction = tick()
local actionCount = 0

-- Auto Farm
local autoMining = false
local autoSell = false
local autoForge = false
local autoInstantMelt = false
local autoInstantPour = false
local autoPerfectHammer = true
local forgeItemType = "Weapon"
local selectedOre = "Rock"
local selectedSellItem = "All Items"
local flySpeed = 50
local miningRange = 20

-- Auto Combat
local autoKillZombie = false
local selectedNPC = "Delver Zombie"

-- Stats
local statsCollected = 0
local zombiesKilled = 0
local itemsSold = 0
local itemsForged = 0

-- Connections
local farmConnection = nil
local killConnection = nil
local sellConnection = nil
local forgeConnection = nil
local currentTarget = nil
local isForging = false

-- Noclip/Fly
local isFlying = false
local originalCollisionGroup = {}
local noclipConnection = nil

-- Ore Names List
local oreNames = {"Rock", "Earth Crystal", "Basalt Rock", "Cyan Crystal", "Light Crystal", "Violet Crystal", "BasaltVein", "Boulder", "Volcanic Rock", "Pebble", "Basalt Core", "Lucky Block"}

-- NPC Names List for Auto Kill
local npcNames = {"Delver Zombie", "Deathaxe", "Skeleton", "Axe Skeleton", "Reaper", "Skeleton Rogue", "Blazing Slime", "Bomber", "Slime", "Elite Deathaxe Skeleton", "Elite Zombie", "Brute Zombie", "Elite", "Rogue Skeleton", "Blight Pyromancer", "Zombie"}

-- Item Names for Selling
local sellItemNames = {"All Items", "Iron Shard", "Crystal Powder", "Forge Catalyst", "Binding Alloy", "Mystic Shard", "Dust Core", "Hardened Metal Plate", "Runic Essence", "Ember Dust", "Luminite Powder"}

-- Forge Item Types
local forgeItemTypes = {"Weapon", "Tool", "Armor"}

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

local function getCharacter()
    return player.Character
end

local function getHumanoidRootPart()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChild("Humanoid")
end

-- Noclip Functions
local function enableNoclip()
    if noclipConnection then return end
    isFlying = true
    
    local char = getCharacter()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCollisionGroup[part] = part.CanCollide
                part.CanCollide = false
            end
        end
    end
    
    noclipConnection = RunService.Stepped:Connect(function()
        if isFlying then
            local character = getCharacter()
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end

local function disableNoclip()
    isFlying = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    local char = getCharacter()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if originalCollisionGroup[part] ~= nil then
                    part.CanCollide = originalCollisionGroup[part]
                else
                    part.CanCollide = true
                end
            end
        end
    end
    originalCollisionGroup = {}
end

-- Tween to position
local function tweenTo(targetPos, speed)
    local hrp = getHumanoidRootPart()
    if not hrp then return end
    
    local distance = (hrp.Position - targetPos).Magnitude
    local duration = distance / speed
    
    enableNoclip()
    
    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(targetPos)}
    )
    
    tween:Play()
    
    tween.Completed:Connect(function()
        disableNoclip()
    end)
    
    return tween
end

-- Activate Tool
local function activateTool()
    local char = getCharacter()
    if not char then return end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    pcall(function()
        if Services.Tool and Services.Tool.RF and Services.Tool.RF.ToolActivated then
            Services.Tool.RF.ToolActivated:InvokeServer(tool.Name)
        end
    end)
    
    pcall(function()
        tool:Activate()
    end)
end

-- Find Nearest Ore
local function findNearestOre()
    local hrp = getHumanoidRootPart()
    if not hrp then return nil end
    
    local nearestOre = nil
    local nearestDistance = math.huge
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if selectedOre and selectedOre ~= "None" then
                if obj.Name:find(selectedOre) then
                    local orePart = obj:FindFirstChild("Part") or obj:FindFirstChildWhichIsA("BasePart")
                    if orePart then
                        local distance = (hrp.Position - orePart.Position).Magnitude
                        if distance < nearestDistance and distance < 500 then
                            nearestDistance = distance
                            nearestOre = orePart
                        end
                    end
                end
            end
        end
    end
    
    return nearestOre
end

-- Find Nearest Zombie
local function findNearestZombie()
    local hrp = getHumanoidRootPart()
    if not hrp then return nil end
    
    local nearestZombie = nil
    local nearestDistance = math.huge
    
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
            local npcHumanoid = npc:FindFirstChild("Humanoid")
            if npcHumanoid and npcHumanoid.Health > 0 then
                if selectedNPC and selectedNPC ~= "None" then
                    if npc.Name:lower():find(selectedNPC:lower()) then
                        local npcHrp = npc:FindFirstChild("HumanoidRootPart")
                        if npcHrp then
                            local distance = (hrp.Position - npcHrp.Position).Magnitude
                            if distance < nearestDistance and distance < 500 then
                                nearestDistance = distance
                                nearestZombie = npc
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nearestZombie
end

-- Equip Pickaxe
local function equipPickaxe()
    local char = getCharacter()
    if not char then return false end
    
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and not currentTool.Name:lower():find("pick") then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid:UnequipTools()
            task.wait(0.1)
        end
    end
    
    currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool and currentTool.Name:lower():find("pick") then
        return true
    end
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("pick") then
                local humanoid = getHumanoid()
                if humanoid then
                    humanoid:EquipTool(tool)
                    task.wait(0.2)
                    return true
                end
            end
        end
    end
    
    return char:FindFirstChildOfClass("Tool") ~= nil
end

-- Equip Weapon
local function equipWeapon()
    local char = getCharacter()
    if not char then return false end
    
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid:UnequipTools()
            task.wait(0.1)
        end
    end
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local humanoid = getHumanoid()
                if humanoid then
                    humanoid:EquipTool(tool)
                    task.wait(0.2)
                    return true
                end
            end
        end
    end
    
    return false
end

-- Find Nearest Sell NPC
local function findNearestSellNPC()
    local hrp = getHumanoidRootPart()
    if not hrp then return nil end
    
    local nearestNPC = nil
    local nearestDistance = math.huge
    
    local npcNames = {"Brakk", "Lira", "Oskar", "Tolin", "Mira", "Kaen", "Sela", "Drax", "Fynn", "Valeen", 
                      "Rudo", "Elwyn", "Jarrick", "Nora", "Taro", "Garm", "Vella", "Kard", "Myra", "Thorne"}
    
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") then
            local found = npc.Name:lower():find("merchant") or npc.Name:lower():find("shop") or npc.Name:lower():find("sell")
            if not found then
                for _, name in pairs(npcNames) do
                    if npc.Name:find(name) then
                        found = true
                        break
                    end
                end
            end
            
            if found then
                local npcHrp = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
                if npcHrp then
                    local distance = (hrp.Position - npcHrp.Position).Magnitude
                    if distance < nearestDistance and distance < 1000 then
                        nearestDistance = distance
                        nearestNPC = npc
                    end
                end
            end
        end
    end
    
    return nearestNPC
end

-- Find Nearest Forge Station
local function findNearestForgeStation()
    local hrp = getHumanoidRootPart()
    if not hrp then return nil end
    
    local nearestForge = nil
    local nearestDistance = math.huge
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            local isForge = obj.Name:lower():find("forge") or obj.Name:lower():find("anvil") or 
                           obj.Name:lower():find("craft") or obj.Name:lower():find("furnace") or
                           obj.Name:lower():find("smithing") or obj.Name:lower():find("workbench")
            
            if isForge then
                local forgePart = obj:IsA("Part") and obj or obj:FindFirstChild("Part") or obj:FindFirstChildWhichIsA("BasePart")
                if forgePart then
                    local distance = (hrp.Position - forgePart.Position).Magnitude
                    if distance < nearestDistance and distance < 1000 then
                        nearestDistance = distance
                        nearestForge = obj
                    end
                end
            end
        end
    end
    
    return nearestForge
end

-- Open Dialogue
local function openDialogue(npc)
    pcall(function()
        if Services.Proximity and Services.Proximity.RF and Services.Proximity.RF.Dialogue then
            Services.Proximity.RF.Dialogue:InvokeServer(npc)
        end
    end)
end

-- Run Dialogue Command
local function runDialogueCommand(command)
    pcall(function()
        if Services.Dialogue and Services.Dialogue.RF and Services.Dialogue.RF.RunCommand then
            Services.Dialogue.RF.RunCommand:InvokeServer(command)
        end
    end)
end

-- Forge
local function forge(target)
    pcall(function()
        if Services.Proximity and Services.Proximity.RF and Services.Proximity.RF.Forge then
            Services.Proximity.RF.Forge:InvokeServer(target)
        end
    end)
end

-- Perform Complete Forge
local function performCompleteForge()
    if isForging then return end
    isForging = true
    
    local forgeStation = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Forge")
    if not forgeStation then
        isForging = false
        return
    end
    
    -- Step 1: Interact with forge station
    pcall(function()
        if Services.Proximity and Services.Proximity.RF and Services.Proximity.RF.Forge then
            Services.Proximity.RF.Forge:InvokeServer(forgeStation)
        end
    end)
    task.wait(0.5)
    
    -- Step 2: Start forge
    pcall(function()
        if Services.Forge and Services.Forge.RF and Services.Forge.RF.StartForge then
            Services.Forge.RF.StartForge:InvokeServer(forgeStation)
        end
    end)
    task.wait(0.5)
    
    -- Step 3: Melt
    local meltParams = { ItemType = forgeItemType }
    if autoInstantMelt then
        meltParams.FastForge = true
        meltParams.Instant = true
    end
    
    pcall(function()
        if Services.Forge and Services.Forge.RF and Services.Forge.RF.ChangeSequence then
            Services.Forge.RF.ChangeSequence:InvokeServer("Melt", meltParams)
        end
    end)
    task.wait(autoInstantMelt and 0.3 or 3)
    
    -- Step 4: Pour
    local pourParams = { ClientTime = tick() }
    if autoInstantPour then
        pourParams.Instant = true
        pourParams.FastPour = true
    end
    
    pcall(function()
        if Services.Forge and Services.Forge.RF and Services.Forge.RF.ChangeSequence then
            Services.Forge.RF.ChangeSequence:InvokeServer("Pour", pourParams)
        end
    end)
    task.wait(autoInstantPour and 0.3 or 3)
    
    -- Step 5: Hammer
    local hammerParams = { ClientTime = tick() }
    if autoPerfectHammer then
        hammerParams.Perfect = true
        hammerParams.Quality = 100
        hammerParams.Accuracy = 1
    end
    
    pcall(function()
        if Services.Forge and Services.Forge.RF and Services.Forge.RF.ChangeSequence then
            Services.Forge.RF.ChangeSequence:InvokeServer("Hammer", hammerParams)
        end
    end)
    task.wait(2)
    
    -- Step 6: Water
    pcall(function()
        if Services.Forge and Services.Forge.RF and Services.Forge.RF.ChangeSequence then
            Services.Forge.RF.ChangeSequence:InvokeServer("Water", { ClientTime = tick() })
        end
    end)
    task.wait(2)
    
    -- Step 7: Showcase
    pcall(function()
        if Services.Forge and Services.Forge.RF and Services.Forge.RF.ChangeSequence then
            Services.Forge.RF.ChangeSequence:InvokeServer("Showcase", {})
        end
    end)
    task.wait(2)
    
    -- Step 8: End forge
    pcall(function()
        if Services.Forge and Services.Forge.RF and Services.Forge.RF.EndForge then
            Services.Forge.RF.EndForge:InvokeServer()
        end
    end)
    
    itemsForged = itemsForged + 1
    isForging = false
    task.wait(1)
end

-- ============================================
-- AUTO FARM FUNCTIONS
-- ============================================

-- Auto Mining
local function startAutoMining()
    if farmConnection then
        farmConnection:Disconnect()
    end
    
    farmConnection = RunService.Heartbeat:Connect(function()
        if not autoMining then return end
        
        local ore = findNearestOre()
        if ore then
            local hrp = getHumanoidRootPart()
            if hrp then
                local distance = (hrp.Position - ore.Position).Magnitude
                
                if distance > miningRange then
                    tweenTo(ore.Position + Vector3.new(0, 2, 0), flySpeed)
                else
                    local orePosition = ore.Position
                    local offsetPosition = orePosition + (hrp.Position - orePosition).Unit * 5
                    hrp.CFrame = CFrame.new(offsetPosition, orePosition)
                    
                    equipPickaxe()
                    task.wait(0.3)
                    
                    activateTool()
                    task.wait(0.1)
                    
                    forge(ore.Parent)
                    
                    if ore and ore.Parent then
                        statsCollected = statsCollected + 1
                    end
                end
            end
        end
        
        task.wait(0.3)
    end)
end

-- Auto Kill
local function startAutoKill()
    if killConnection then
        killConnection:Disconnect()
    end
    
    currentTarget = nil
    
    killConnection = RunService.Heartbeat:Connect(function()
        if not autoKillZombie then return end
        
        if currentTarget then
            local targetHumanoid = currentTarget:FindFirstChild("Humanoid")
            if not targetHumanoid or targetHumanoid.Health <= 0 or not currentTarget.Parent then
                if targetHumanoid and targetHumanoid.Health <= 0 then
                    zombiesKilled = zombiesKilled + 1
                end
                currentTarget = nil
            end
        end
        
        if not currentTarget then
            currentTarget = findNearestZombie()
        end
        
        if currentTarget then
            local hrp = getHumanoidRootPart()
            local zombieHrp = currentTarget:FindFirstChild("HumanoidRootPart")
            local zombieHumanoid = currentTarget:FindFirstChild("Humanoid")
            
            if hrp and zombieHrp and zombieHumanoid and zombieHumanoid.Health > 0 then
                local distance = (hrp.Position - zombieHrp.Position).Magnitude
                
                if distance > 8 then
                    tweenTo(zombieHrp.Position + Vector3.new(0, 2, 0), flySpeed)
                else
                    hrp.CFrame = CFrame.new(hrp.Position, zombieHrp.Position)
                    equipWeapon()
                    task.wait(0.3)
                    activateTool()
                    task.wait(0.1)
                end
            else
                currentTarget = nil
            end
        end
        
        task.wait(0.2)
    end)
end

-- Auto Sell
local function startAutoSell()
    if sellConnection then
        sellConnection:Disconnect()
    end
    
    sellConnection = RunService.Heartbeat:Connect(function()
        if not autoSell then return end
        
        local npc = findNearestSellNPC()
        if npc then
            local hrp = getHumanoidRootPart()
            local npcPart = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
            
            if hrp and npcPart then
                local distance = (hrp.Position - npcPart.Position).Magnitude
                
                if distance > 10 then
                    tweenTo(npcPart.Position + Vector3.new(0, 3, 0), flySpeed)
                else
                    openDialogue(npc)
                    task.wait(0.5)
                    
                    if selectedSellItem == "All Items" then
                        runDialogueCommand("Sell All")
                        runDialogueCommand("Sell")
                    else
                        runDialogueCommand("Sell " .. selectedSellItem)
                    end
                    
                    itemsSold = itemsSold + 1
                    task.wait(2)
                end
            end
        end
        
        task.wait(1)
    end)
end

-- Auto Forge
local function startAutoForge()
    if forgeConnection then
        forgeConnection:Disconnect()
    end
    
    forgeConnection = RunService.Heartbeat:Connect(function()
        if not autoForge then return end
        if isForging then return end
        
        local forgeStation = findNearestForgeStation()
        if forgeStation then
            local hrp = getHumanoidRootPart()
            local forgePart = forgeStation
            
            if forgeStation:IsA("Model") then
                forgePart = forgeStation:FindFirstChild("Part") or forgeStation:FindFirstChildWhichIsA("BasePart")
            end
            
            if hrp and forgePart then
                local distance = (hrp.Position - forgePart.Position).Magnitude
                
                if distance > 15 then
                    tweenTo(forgePart.Position + Vector3.new(0, 5, 0), flySpeed)
                else
                    task.spawn(performCompleteForge)
                end
            end
        end
        
        task.wait(1)
    end)
end

-- ============================================
-- ANTI AFK
-- ============================================
local function performAntiAFK()
    if not antiAFKEnabled then return end
    
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
    
    actionCount = actionCount + 1
    lastAction = tick()
    
    if getCharacter() and getHumanoid() then
        local humanoid = getHumanoid()
        if humanoid and humanoid.MoveDirection == Vector3.new(0, 0, 0) then
            humanoid:Move(Vector3.new(0.01, 0, 0))
            task.wait(0.1)
            humanoid:Move(Vector3.new(0, 0, 0))
        end
    end
end

-- ============================================
-- UI SECTIONS
-- ============================================

-- INFO TAB
local infoSection = tabs.info:Section({Title = "Script Information"})
infoSection:Paragraph({
    Title = "PinatHub | The Forge",
    Desc = "script with Anti AFK, Auto Mining, Auto Kill, and Auto Forge features."
})

local statsSection = tabs.info:Section({Title = "Session Statistics"})
local statsParagraph = statsSection:Paragraph({
    Title = "Live Statistics",
    Desc = "Anti AFK Actions: 0\nOres Collected: 0\nZombies Killed: 0\nItems Sold: 0\nItems Forged: 0"
})

task.spawn(function()
    while task.wait(2) do
        statsParagraph:SetDesc(string.format("Anti AFK Actions: %d\nOres Collected: %d\nZombies Killed: %d\nItems Sold: %d\nItems Forged: %d", 
            actionCount, statsCollected, zombiesKilled, itemsSold, itemsForged))
    end
end)

-- FARM TAB
local miningSection = tabs.farm:Section({Title = "Auto Mining"})
miningSection:Paragraph({
    Title = "Auto Mining",
    Desc = "Automatically fly to ores and mine them. Select specific ore type or mine all ores."
})

miningSection:Dropdown({
    Title = "Select Ore Type",
    Values = oreNames,
    Value = "Rock",
    Callback = function(value)
        selectedOre = value
    end
})

miningSection:Toggle({
    Title = "Enable Auto Mining",
    Value = false,
    Callback = function(state)
        autoMining = state
        if state then
            startAutoMining()
        else
            if farmConnection then
                farmConnection:Disconnect()
                farmConnection = nil
            end
            disableNoclip()
        end
    end
})

miningSection:Slider({
    Title = "Mining Range",
    Value = { Min = 5, Max = 50, Default = 20 },
    Rounding = 0,
    Callback = function(value)
        miningRange = value
    end
})

miningSection:Divider()

-- Auto Sell Section
local sellSection = tabs.farm:Section({Title = "Auto Sell"})
sellSection:Paragraph({
    Title = "Auto Sell Items",
    Desc = "Automatically fly to merchant/shop NPC and sell your items."
})

sellSection:Dropdown({
    Title = "Select Item to Sell",
    Values = sellItemNames,
    Value = "All Items",
    Callback = function(value)
        selectedSellItem = value
    end
})

sellSection:Toggle({
    Title = "Enable Auto Sell",
    Value = false,
    Callback = function(state)
        autoSell = state
        if state then
            startAutoSell()
        else
            if sellConnection then
                sellConnection:Disconnect()
                sellConnection = nil
            end
            disableNoclip()
        end
    end
})

sellSection:Button({
    Title = "Sell Items Once",
    Callback = function()
        local npc = findNearestSellNPC()
        if npc then
            local npcPart = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart")
            if npcPart then
                local hrp = getHumanoidRootPart()
                if hrp then
                    tweenTo(npcPart.Position, flySpeed)
                    task.wait(2)
                    openDialogue(npc)
                    task.wait(0.5)
                    runDialogueCommand("Sell")
                end
            end
        end
    end
})

sellSection:Divider()

-- Auto Forge Section
local forgeSectionUI = tabs.farm:Section({Title = "Auto Forge"})
forgeSectionUI:Paragraph({
    Title = "Auto Forge Items",
    Desc = "Automatically fly to forge station and craft items with instant melt, pour, and perfect hammer."
})

forgeSectionUI:Dropdown({
    Title = "Forge Item Type",
    Values = forgeItemTypes,
    Value = "Weapon",
    Callback = function(value)
        forgeItemType = value
    end
})

forgeSectionUI:Toggle({
    Title = "Auto Instant Melt",
    Value = false,
    Callback = function(state)
        autoInstantMelt = state
    end
})

forgeSectionUI:Toggle({
    Title = "Auto Instant Pour",
    Value = false,
    Callback = function(state)
        autoInstantPour = state
    end
})

forgeSectionUI:Toggle({
    Title = "Auto Perfect Hammer (100%)",
    Value = true,
    Callback = function(state)
        autoPerfectHammer = state
    end
})

forgeSectionUI:Button({
    Title = "Forge Once (Manual)",
    Callback = function()
        task.spawn(performCompleteForge)
    end
})

forgeSectionUI:Toggle({
    Title = "Enable Auto Forge",
    Value = false,
    Callback = function(state)
        autoForge = state
        if state then
            startAutoForge()
        else
            if forgeConnection then
                forgeConnection:Disconnect()
                forgeConnection = nil
            end
            disableNoclip()
        end
    end
})

-- COMBAT TAB
local combatSection = tabs.combat:Section({Title = "Auto Kill"})
combatSection:Paragraph({
    Title = "Auto Kill NPC",
    Desc = "Automatically detect and kill nearby NPCs/enemies."
})

combatSection:Dropdown({
    Title = "Select NPC Type",
    Values = npcNames,
    Value = "Delver Zombie",
    Callback = function(value)
        selectedNPC = value
    end
})

combatSection:Toggle({
    Title = "Enable Auto Kill",
    Value = false,
    Callback = function(state)
        autoKillZombie = state
        if state then
            startAutoKill()
        else
            if killConnection then
                killConnection:Disconnect()
                killConnection = nil
            end
            disableNoclip()
        end
    end
})

combatSection:Button({
    Title = "Kill Nearest Enemy",
    Callback = function()
        local enemy = findNearestZombie()
        if enemy then
            local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
            if enemyHrp then
                local hrp = getHumanoidRootPart()
                if hrp then
                    tweenTo(enemyHrp.Position, flySpeed)
                end
            end
        end
    end
})

-- MISC TAB
local antiAFKSection = tabs.misc:Section({Title = "Anti AFK"})
antiAFKSection:Paragraph({
    Title = "About Anti AFK",
    Desc = "Prevents Roblox from kicking you after 20 minutes of inactivity."
})

antiAFKSection:Toggle({
    Title = "Enable Anti AFK",
    Value = false,
    Callback = function(state)
        antiAFKEnabled = state
        
        if state then
            if afkConnection then
                afkConnection:Disconnect()
            end
            
            afkConnection = RunService.Heartbeat:Connect(function()
                if tick() - lastAction >= 60 then
                    performAntiAFK()
                end
            end)
            
            player.Idled:Connect(function()
                if antiAFKEnabled then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)
        else
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end
    end
})

local playerSettingsSection = tabs.misc:Section({Title = "Player Settings"})
playerSettingsSection:Button({
    Title = "Reset Stats",
    Callback = function()
        statsCollected = 0
        zombiesKilled = 0
        actionCount = 0
        itemsSold = 0
        itemsForged = 0
        window:Notify("Stats", "All stats reset!", 2)
    end
})

playerSettingsSection:Button({
    Title = "Teleport to Spawn",
    Callback = function()
        local hrp = getHumanoidRootPart()
        if hrp then
            hrp.CFrame = CFrame.new(0, 50, 0)
            window:Notify("Teleport", "Teleported to spawn!", 2)
        end
    end
})

-- SETTINGS TAB
local movementSection = tabs.settings:Section({Title = "Movement"})

local walkSpeedValue = 16
movementSection:Slider({
    Title = "Walk Speed (16-250)",
    Value = { Min = 16, Max = 250, Default = 16 },
    Rounding = 0,
    Callback = function(value)
        walkSpeedValue = value
        local char = getCharacter()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = value end
        end
    end
})

local jumpPowerValue = 50
movementSection:Slider({
    Title = "Jump Power (0-500)",
    Value = { Min = 0, Max = 500, Default = 50 },
    Rounding = 0,
    Callback = function(value)
        jumpPowerValue = value
        local char = getCharacter()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.JumpPower = value
                hum.UseJumpPower = true
            end
        end
    end
})

local infiniteJumpEnabled = false
movementSection:Toggle({
    Title = "Infinite Jump",
    Value = false,
    Callback = function(value)
        infiniteJumpEnabled = value
    end
})

UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local char = getCharacter()
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState("Jumping") end
        end
    end
end)

movementSection:Button({
    Title = "Reset Character",
    Callback = function()
        if player.Character then
            player.Character:BreakJoints()
            window:Notify("Reset", "Character reset!", 2)
        end
    end
})

movementSection:Divider()

movementSection:Slider({
    Title = "Fly/Tween Speed",
    Value = { Min = 20, Max = 200, Default = 50 },
    Rounding = 0,
    Callback = function(value)
        flySpeed = value
    end
})

movementSection:Divider()

-- Server Section
local serverSection = tabs.settings:Section({Title = "Server"})

local antiAFKServer = false
serverSection:Toggle({
    Title = "Anti-AFK (Server)",
    Value = false,
    Callback = function(state)
        antiAFKServer = state
        if state then
            task.spawn(function()
                while antiAFKServer do
                    task.wait(60)
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end)
        end
    end
})

serverSection:Button({
    Title = "Server Hop",
    Callback = function()
        local req = syn and syn.request or http_request or request or httprequest
        local servers = {}
        local placeId = game.PlaceId
        
        if req then
            local cursor = ""
            for _ = 1, 3 do
                local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
                if cursor ~= "" then url = url .. "&cursor=" .. cursor end
                local ok, response = pcall(req, { Url = url, Method = "GET" })
                if not ok or not response or not response.Body then break end
                local ok2, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
                if not ok2 or not data or not data.data then break end
                for _, server in ipairs(data.data) do
                    if server.id ~= game.JobId and server.playing < server.maxPlayers then
                        table.insert(servers, server.id)
                    end
                end
                local nextCursor = data.nextPageCursor
                if not nextCursor or nextCursor == "" or nextCursor == "null" then break end
                cursor = tostring(nextCursor)
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)], player)
        else
            TeleportService:Teleport(placeId, player)
        end
        window:Notify("Server Hop", "Joining new server...", 2)
    end
})

serverSection:Button({
    Title = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, player)
        window:Notify("Rejoin", "Rejoining server...", 2)
    end
})

-- COMMUNITY TAB
local communitySection = tabs.community:Section({Title = "Join Community"})

communitySection:Button({
    Title = "WhatsApp Group",
    Callback = function()
        if set_clipboard then
            set_clipboard("https://chat.whatsapp.com/I8hG44FLgrRAwQcS3lvEft")
            window:Notify("Copied!", "WhatsApp link copied!", 2)
        end
    end
})

communitySection:Button({
    Title = "Discord Server",
    Callback = function()
        if set_clipboard then
            set_clipboard("https://discord.gg/eDbaHKEf7G")
            window:Notify("Copied!", "Discord link copied!", 2)
        end
    end
})

communitySection:Button({
    Title = "TikTok @viunze",
    Callback = function()
        if set_clipboard then
            set_clipboard("https://tiktok.com/@viunze")
            window:Notify("Copied!", "TikTok profile copied!", 2)
        end
    end
})

-- ============================================
-- CHARACTER RESPAWN HANDLER
-- ============================================
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart", 10)
    task.wait(0.5)
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = walkSpeedValue
            hum.JumpPower = jumpPowerValue
            hum.UseJumpPower = true
        end
    end)
end)

-- ============================================
-- INITIAL NOTIFICATION
-- ============================================
task.wait(1)
window:Notify("PinatHub", "The Forge Loaded!", 3)
window:Open()
