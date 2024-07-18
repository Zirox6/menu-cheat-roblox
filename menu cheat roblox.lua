local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Robojini/Tuturial_UI_Library/main/UI_Template_1"))()

local Window = Library.CreateLib("name", "RJTheme3")

local Tab = Window:NewTab("qwe")

local Section = TabNewSection("Section Name")


Section:Newbutton("AimBot", "ButtonInfo", function()
    --> VARIABLES <--
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local camera = game:GetService("Workspace").CurrentCamera
 
--> FUNCTIONS <--
function notBehindWall(target)
    local ray = Ray.new(plr.Character.Head.Position, (target.Position - plr.Character.Head.Position).Unit * 300)
    local part, position = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, {plr.Character}, false, true)
    if part then
        local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            humanoid = part.Parent.Parent:FindFirstChildOfClass("Humanoid")
        end
        if humanoid and target and humanoid.Parent == target.Parent then
            local pos, visible = camera:WorldToScreenPoint(target.Position)
            if visible then
                return true
            end
        end
    end
end
 
function getPlayerClosestToMouse()
    local target = nil
    local maxDist = 100
    for _,v in pairs(plrs:GetPlayers()) do
        if v.Character then
            if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.TeamColor ~= plr.TeamColor then
                local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).magnitude
                if dist < maxDist and vis then
                    local torsoPos = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    local torsoDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(torsoPos.X, torsoPos.Y)).magnitude
                    local headPos = camera:WorldToViewportPoint(v.Character.Head.Position)
                    local headDist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(headPos.X, headPos.Y)).magnitude
                    if torsoDist > headDist then
                        if notBehindWall(v.Character.Head) then
                            target = v.Character.Head
                        end
                    else
                        if notBehindWall(v.Character.HumanoidRootPart) then
                            target = v.Character.HumanoidRootPart
                        end
                    end
                    maxDist = dist
                end
            end
        end
    end
    return target
end
 
--> Hooking to the remote <--
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldNamecall = gmt.__namecall
 
gmt.__namecall = newcclosure(function(self, ...)
    local Args = {...}
    local method = getnamecallmethod()
    if tostring(self) == "HitPart" and tostring(method) == "FireServer" then
        Args[1] = getPlayerClosestToMouse()
        Args[2] = getPlayerClosestToMouse().Position
        return self.FireServer(self, unpack(Args))
    end
    return oldNamecall(self, ...)
  end)
end)

Section:Newbutton("EspBox", "ButtonInfo", function()
    while wait(0.5) do
        for i, childrik in ipairs(workspace:GetDescendants()) do
            if childrik:FindFirstChild("Humanoid") then
                if not childrik:FindFirstChild("EspBox") then
                    if childrik ~= game.Players.LocalPlayer.Character then
                        local esp = Instance.new("BoxHandleAdornment",childrik)
                        esp.Adornee = childrik
                        esp.ZIndex = 0
                        esp.Size = Vector3.new(4, 5, 1)
                        esp.Transparency = 0.65
                        esp.Color3 = Color3.fromRGB(255,48,48)
                        esp.AlwaysOnTop = true
                        esp.Name = "EspBox"
                    end
                end
            end
        end
    end
end)

