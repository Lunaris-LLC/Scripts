-- Waits until the player and necessary components are loaded
repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character 
    and game.Players.LocalPlayer.Character:FindFirstChild("Torso") 
    and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

-- Get the player's mouse
local mouse = game.Players.LocalPlayer:GetMouse()
repeat wait() until mouse

-- Variables
local plr = game.Players.LocalPlayer
local character = plr.Character
local torso = character.Torso
local flying = false
local speed = 0
local maxSpeed = 50
local control = {f = 0, b = 0, l = 0, r = 0}
local bg, bv = nil, nil

-- Fly function
local function Fly()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Fly Mode";
        Text = "Activated";
        Duration = 2;
    })

    -- BodyGyro and BodyVelocity setup
    bg = Instance.new("BodyGyro", torso)
    bg.P = 90000
    bg.maxTorque = Vector3.new(900000000, 900000000, 900000000)
    bg.cframe = torso.CFrame

    bv = Instance.new("BodyVelocity", torso)
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(900000000, 900000000, 900000000)

    repeat
        wait()
        character.Humanoid.PlatformStand = true

        -- Adjust speed based on input
        if control.l + control.r ~= 0 or control.f + control.b ~= 0 then
            speed = math.min(speed + 1 + speed / maxSpeed, maxSpeed)
        elseif speed > 0 then
            speed = math.max(speed - 1, 0)
        end

        -- Update BodyVelocity based on controls
        if control.l + control.r ~= 0 or control.f + control.b ~= 0 then
            bv.velocity = ((game.Workspace.CurrentCamera.CFrame.LookVector * (control.f + control.b)) + 
                (game.Workspace.CurrentCamera.CFrame.RightVector * (control.l + control.r))) * speed
        else
            bv.velocity = Vector3.new(0, 0.1, 0)
        end

        bg.cframe = game.Workspace.CurrentCamera.CFrame
    until not flying

    -- Reset
    speed = 0
    control = {f = 0, b = 0, l = 0, r = 0}
    bg:Destroy()
    bv:Destroy()
    character.Humanoid.PlatformStand = false

    game.StarterGui:SetCore("SendNotification", {
        Title = "Fly Mode";
        Text = "Deactivated";
        Duration = 2;
    })
end

-- Handle key presses
mouse.KeyDown:Connect(function(key)
    key = key:lower()
    if key == "e" then
        flying = not flying
        if flying then
            Fly()
        end
    elseif key == "w" then
        control.f = 1
    elseif key == "s" then
        control.b = -1
    elseif key == "a" then
        control.l = -1
    elseif key == "d" then
        control.r = 1
    end
end)

mouse.KeyUp:Connect(function(key)
    key = key:lower()
    if key == "w" then
        control.f = 0
    elseif key == "s" then
        control.b = 0
    elseif key == "a" then
        control.l = 0
    elseif key == "d" then
        control.r = 0
    end
end)