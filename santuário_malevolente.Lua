local Players = game:GetService("Players")
local Chat = game:GetService("Chat")
local Debris = game:GetService("Debris")

-- Função para criar o Santuário Malevolente
local function createMalevolentSanctuary(player)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local tool = Instance.new("Tool")
    tool.Name = "MalevolentSanctuary"
    tool.RequiresHandle = false -- Para evitar que o jogador solte o item
    tool.Parent = player.Backpack
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 2, 1)
    handle.BrickColor = BrickColor.new("Really black")
    handle.Parent = tool
    
    tool.Equipped:Connect(function()
        -- Quando equipado, definir a função de ataque
        tool.Activated:Connect(function()
            local target = humanoid.Target
            if target then
                target:TakeDamage(100) -- Causa 100 pontos de dano
            end
        end)
    end)
end

-- Função para processar os comandos de chat
local function processChatCommand(player, message)
    if message == "/sant01" then
        createMalevolentSanctuary(player)
    end
end

-- Conectar a função ao evento de recebimento de mensagens de chat
Chat:RegisterChatCallback(Enum.ChatCallbackType.OnCreatingChatWindow, function(targetPlayer, message)
    processChatCommand(targetPlayer, message)
    return message
end)



-- Desmantelar
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local cooldown = 3
local chargeTime = 3
local damagePercent = 0.1
local bleedDamagePercent = 0.005
local bleedDuration = 5
local bleedInterval = 0.5

local function createSemiCircle(player)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local semiCircle = Instance.new("Part")
    semiCircle.Size = Vector3.new(10, 0.2, 10)
    semiCircle.Color = Color3.new(1, 1, 1)
    semiCircle.Position = head.Position + Vector3.new(0, -head.Size.Y / 2, 0)
    semiCircle.Anchored = true
    semiCircle.CanCollide = false
    semiCircle.Transparency = 0.5
    semiCircle.Parent = game.Workspace
    
    Debris:AddItem(semiCircle, 2)
    
    local debounce = false
    local startTime = nil
    
    local function damagePlayer(hit)
        local hitHumanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
        if hitHumanoid then
            local maxHealth = hitHumanoid.MaxHealth
            hitHumanoid:TakeDamage(damagePercent * maxHealth)
            
            local bleedEndTime = tick() + bleedDuration
            spawn(function()
                while tick() < bleedEndTime do
                    hitHumanoid:TakeDamage(bleedDamagePercent * hitHumanoid.Health)
                    wait(bleedInterval)
                end
            end)
        end
    end
    
    semiCircle.Touched:Connect(function(hit)
        if debounce or not hit.Parent then return end
        debounce = true
        damagePlayer(hit)
        wait(1)
        debounce = false
    end)
    
    local function onMouseHold()
        startTime = tick()
        while tick() - startTime < chargeTime do
            wait()
        end
        debounce = false
        damagePlayer(humanoid)
    end
    
    local function onInputBegan(input)
        if input.KeyCode == Enum.KeyCode.Z then
            debounce = true
            onMouseHold()
        end
    end
    
    local function onInputEnded(input)
        if input.KeyCode == Enum.KeyCode.Z then
            debounce = false
        end
    end
    
    game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
    game:GetService("UserInputService").InputEnded:Connect(onInputEnded)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        createSemiCircle(player)
    end)
end)

--Clivar
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local cooldown = 5
local chargeTime = 3
local damagePercent = 0.2
local bleedDamagePercent = 0.005
local bleedDuration = 10
local bleedInterval = 0.5

local function createSemiCircle(player, ignoreDefenses)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local semiCircle = Instance.new("Part")
    semiCircle.Size = Vector3.new(10, 0.2, 10)
    semiCircle.Color = ignoreDefenses and Color3.new(0, 0, 0) or Color3.new(1, 0, 0)
    semiCircle.Position = head.Position + Vector3.new(0, -head.Size.Y / 2, 0)
    semiCircle.Anchored = true
    semiCircle.CanCollide = false
    semiCircle.Transparency = 0.5
    semiCircle.Parent = game.Workspace
    
    Debris:AddItem(semiCircle, 2)
    
    local function damagePlayer(hit)
        local hitHumanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
        if hitHumanoid then
            local maxHealth = hitHumanoid.MaxHealth
            hitHumanoid:TakeDamage(damagePercent * maxHealth)
            
            local bleedEndTime = tick() + bleedDuration
            spawn(function()
                while tick() < bleedEndTime do
                    hitHumanoid:TakeDamage(bleedDamagePercent * hitHumanoid.Health)
                    wait(bleedInterval)
                end
            end)
        end
    end
    
    semiCircle.Touched:Connect(function(hit)
        damagePlayer(hit)
    end)
end

local function onInputBegan(input)
    if input.KeyCode == Enum.KeyCode.X then
        local player = game.Players:GetPlayerFromCharacter(input.User)
        if player then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local startTime = tick()
                    while tick() - startTime < chargeTime do
                        wait()
                    end
                    createSemiCircle(player, true)
                end
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        local debounce = false
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if not debounce then
                debounce = true
                humanoid.Health = 0
                debounce = false
            end
        end)
    end)
end)

game:GetService("UserInputService").InputBegan:Connect(onInputBegan)


-- Abra: Fornalha
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local cooldown = 10
local chargeTime = 3
local damagePercent = 0.6
local burnDamagePercent = 0.01
local burnDuration = 10
local burnInterval = 0.1
local explosionRadius = 10

local function createArrow(player, chargeLevel)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local arrow = Instance.new("Part")
    arrow.Size = Vector3.new(2, 0.5, 0.5)
    arrow.BrickColor = BrickColor.new("Bright orange")
    arrow.Position = character.Head.Position + Vector3.new(0, -2, 0)
    arrow.Anchored = true
    arrow.CanCollide = false
    arrow.Name = "Arrow"
    arrow.Parent = game.Workspace
    
    Debris:AddItem(arrow, 5)
    
    local debounce = false
    
    local function damagePlayer(hit)
        local hitHumanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
        if hitHumanoid then
            local maxHealth = hitHumanoid.MaxHealth
            hitHumanoid:TakeDamage(damagePercent * maxHealth)
            
            local burnEndTime = tick() + burnDuration
            spawn(function()
                while tick() < burnEndTime do
                    hitHumanoid:TakeDamage(burnDamagePercent * hitHumanoid.Health)
                    wait(burnInterval)
                end
            end)
            
            if hitHumanoid.Parent == player.Character then
                game:GetService("Players"):Chat(player.Name .. ": Abra: Fornalha")
            end
        end
    end
    
    local function explode()
        local explosion = Instance.new("Explosion")
        explosion.Position = arrow.Position
        explosion.BlastRadius = explosionRadius
        explosion.Parent = game.Workspace
    end
    
    arrow.Touched:Connect(function(hit)
        if debounce then return end
        debounce = true
        damagePlayer(hit)
        explode()
        wait(1)
        arrow:Destroy()
    end)
end

local function onInputBegan(input)
    if input.KeyCode == Enum.KeyCode.C then
        local player = game.Players:GetPlayerFromCharacter(input.User)
        if player then
            local startTime = tick()
            while tick() - startTime < chargeTime do
                wait()
            end
            createArrow(player, true)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        local debounce = false
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if not debounce then
                debounce = true
                humanoid.Health = 0
                debounce = false
            end
        end)
    end)
end)

game:GetService("UserInputService").InputBegan:Connect(onInputBegan)


-- Corte que corta o mundo
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local cooldown = 30
local chargeTime = 5
local damagePercent = 0.99

local function createSemiCircle(player, ignoreDefenses)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local semiCircle = Instance.new("Part")
    semiCircle.Size = Vector3.new(10, 0.2, 10)
    semiCircle.Color = Color3.fromRGB(173, 216, 230) -- Branco-azulado
    semiCircle.Position = head.Position + Vector3.new(0, -head.Size.Y / 2, 0)
    semiCircle.Anchored = true
    semiCircle.CanCollide = false
    semiCircle.Transparency = 0.5
    semiCircle.Parent = game.Workspace
    
    Debris:AddItem(semiCircle, 2)
    
    local function damagePlayer(hit)
        local hitHumanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
        if hitHumanoid then
            local maxHealth = hitHumanoid.MaxHealth
            hitHumanoid:TakeDamage(damagePercent * maxHealth)
        end
    end
    
    local function createEffects()
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (otherPlayer.Character.HumanoidRootPart.Position - head.Position).magnitude
                if distance <= 100 then
                    game:GetService("Players"):Chat(otherPlayer.Name .. ": escamas de dragão")
                    game:GetService("Players"):Chat(otherPlayer.Name .. ": pilar de luz")
                    game:GetService("Players"):Chat(otherPlayer.Name .. ": equinócio de verão")
                end
            end
        end
    end
    
    local function onMouseHold()
        createEffects()
        local startTime = tick()
        while tick() - startTime < chargeTime do
            wait()
        end
        damagePlayer(humanoid)
    end
    
    local function onInputBegan(input)
        if input.KeyCode == Enum.KeyCode.V then
            createEffects()
            onMouseHold()
        end
    end
    
    game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
end

local function cooldownComplete(player)
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    humanoid:SetAttribute("CanUseVAbility", true)
end

local function onPlayerAdded(player)
    local canUseVAbility = Instance.new("BoolValue")
    canUseVAbility.Name = "CanUseVAbility"
    canUseVAbility.Value = true
    canUseVAbility.Parent = player
    
    player.CharacterAdded:Connect(function(character)
        createSemiCircle(player)
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

while true do
    wait(cooldown)
    for _, player in ipairs(Players:GetPlayers()) do
        cooldownComplete(player)
    end
end


--Solção marcial
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local cooldown = 10
local damagePercent = 0.4

local function createLightningStrike(cursorPosition)
    local strike = Instance.new("Part")
    strike.Size = Vector3.new(1, 30, 1)
    strike.Position = cursorPosition + Vector3.new(0, 15, 0)
    strike.BrickColor = BrickColor.new("Bright yellow")
    strike.Anchored = true
    strike.CanCollide = false
    strike.Name = "LightningStrike"
    strike.Parent = game.Workspace
    
    Debris:AddItem(strike, 5)
    
    local function damagePlayer(hit)
        local hitHumanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
        if hitHumanoid then
            local maxHealth = hitHumanoid.MaxHealth
            hitHumanoid:TakeDamage(damagePercent * maxHealth)
        end
    end
    
    strike.Touched:Connect(function(hit)
        damagePlayer(hit)
        strike:Destroy()
    end)
end

local function onInputBegan(input)
    if input.KeyCode == Enum.KeyCode.B then
        local mouse = game.Players.LocalPlayer:GetMouse()
        local cursorPosition = mouse.Hit.p
        createLightningStrike(cursorPosition)
    end
end

game:GetService("UserInputService").InputBegan:Connect(onInputBegan)


--Teia de : Abra: Fornalha
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local cooldown = 25
local damagePercent = 0.2
local areaRadius = 20

local function createAreaAttack(player)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local area = Instance.new("Part")
    area.Size = Vector3.new(areaRadius * 2, 1, areaRadius * 2)
    area.Position = head.Position - Vector3.new(0, 10, 0)
    area.Anchored = true
    area.CanCollide = false
    area.Transparency = 0.5
    area.Parent = game.Workspace
    
    Debris:AddItem(area, 2)
    
    local function damagePlayersInArea()
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local distance = (otherPlayer.Character.HumanoidRootPart.Position - area.Position).magnitude
                if distance <= areaRadius then
                    local humanoid = otherPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local maxHealth = humanoid.MaxHealth
                        humanoid:TakeDamage(damagePercent * maxHealth)
                    end
                end
            end
        end
    end
    
    delay(0.5, function()
        damagePlayersInArea()
        area:Destroy()
    end)
end

local function onInputBegan(input)
    local zPressed = input.KeyCode == Enum.KeyCode.Z
    local xPressed = input.KeyCode == Enum.KeyCode.X
    if zPressed or xPressed then
        if zPressed and xPressed then
            local player = game.Players:GetPlayerFromCharacter(input.User)
            if player then
                createAreaAttack(player)
            end
        end
    end
end

game:GetService("UserInputService").InputBegan:Connect(onInputBegan)


