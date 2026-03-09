-- [[ BOOM HUB - ARROW EDITION ]] --
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")

-- ล้าง UI เก่าออกให้หมดก่อนรันใหม่
for _, oldUI in pairs(game.CoreGui:GetChildren()) do
    if oldUI.Name == "BoomHub" then oldUI:Destroy() end
end

local Library = Instance.new("ScreenGui", game.CoreGui)
Library.Name = "BoomHub"

-- ฟังก์ชันระเบิด
local function makeBoom(pos)
    local exp = Instance.new("Explosion")
    exp.Position = pos
    exp.BlastRadius = 0 -- ตัวไม่ตาย
    exp.Parent = workspace
    local s = Instance.new("Sound", workspace)
    s.SoundId = "rbxassetid://142070127"; s:Play()
    game:GetService("Debris"):AddItem(s, 2)
end

-- [ 1. ปุ่มเปิด/ปิด ทรงกลมขอบแดงตามรูป ]
local ToggleBtn = Instance.new("TextButton", Library)
ToggleBtn.Size = UDim2.new(0, 70, 0, 70); ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); ToggleBtn.Text = "💥"; ToggleBtn.TextSize = 35
ToggleBtn.Active = true; ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local Stroke1 = Instance.new("UIStroke", ToggleBtn)
Stroke1.Color = Color3.fromRGB(255, 0, 0); Stroke1.Thickness = 3

-- [ 2. ตัวเมนูหลัก ขอบแดงหนาตามรูป ]
local MainFrame = Instance.new("Frame", Library)
MainFrame.Size = UDim2.new(0, 250, 0, 420); MainFrame.Position = UDim2.new(0.5, -125, 0.4, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); MainFrame.Visible = false
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke2 = Instance.new("UIStroke", MainFrame)
Stroke2.Color = Color3.fromRGB(255, 0, 0); Stroke2.Thickness = 4

-- [ 3. หัวข้อระเบิด 5 อัน ]
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 60); Title.Text = "💥💥💥💥💥"
Title.BackgroundTransparency = 1; Title.TextSize = 25

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- [ 4. ฟังก์ชันสร้างปุ่มสีแดงตัวอักษรดำ ]
local function createBoomBtn(text, pos, action)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0, 210, 0, 45); b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    b.Text = "💥" .. text .. "💥"; b.TextColor3 = Color3.fromRGB(0, 0, 0)
    b.Font = Enum.Font.SourceSansBold; b.TextSize = 16
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(action)
end

-- [[ ปุ่ม 1: ระเบิดตัวเอง ]]
createBoomBtn("ระเบิดตัวเอง", UDim2.new(0, 20, 0, 80), function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        makeBoom(player.Character.HumanoidRootPart.Position)
    end
end)

-- [[ ปุ่ม 2: ระเบิดทุกคน ]]
createBoomBtn("ระเบิดทุกคน", UDim2.new(0, 20, 0, 150), function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            makeBoom(v.Character.HumanoidRootPart.Position)
        end
    end
end)

-- [[ ปุ่ม 3: ระเบิดไอเทม ]]
createBoomBtn("ระเบิดไอเทม", UDim2.new(0, 20, 0, 220), function()
    local tool = Instance.new("Tool")
    tool.Name = "💥ระเบิด💥"; tool.RequiresHandle = true
    local handle = Instance.new("Part", tool); handle.Name = "Handle"
    handle.Size = Vector3.new(1,1,1); handle.Color = Color3.fromRGB(255,0,0)
    tool.Parent = player.Backpack
    tool.Activated:Connect(function() makeBoom(mouse.Hit.p) end)
end)

-- [[ ปุ่ม 4: ระเบิดออร่า ]]
local auraActive = false
local targetsHit = {}

createBoomBtn("ระเบิดออร่า", UDim2.new(0, 20, 0, 290), function()
    auraActive = not auraActive
    if auraActive then targetsHit = {} end
end)

-- ระบบตรวจสอบออร่า (ทำงานเมื่อเปิดเท่านั้น)
runService.Heartbeat:Connect(function()
    if auraActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = player.Character.HumanoidRootPart.Position
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local tRoot = v.Character.HumanoidRootPart
                local dist = (myPos - tRoot.Position).Magnitude
                if dist < 20 then
                    if not targetsHit[v.Name] then
                        makeBoom(tRoot.Position)
                        targetsHit[v.Name] = true
                    end
                else
                    targetsHit[v.Name] = nil
                end
            end
        end
    end
end)
