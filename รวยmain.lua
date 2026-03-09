-- [[ ARROW MONEY V.1 ]] --
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local debris = game:GetService("Debris")

-- ล้าง UI เก่า
if game.CoreGui:FindFirstChild("ArrowMoneyV1") then game.CoreGui.ArrowMoneyV1:Destroy() end

local Library = Instance.new("ScreenGui", game.CoreGui)
Library.Name = "ArrowMoneyV1"

-- [ 1. ปุ่มเปิด/ปิด (ถุงเงินสีเหลือง) ]
local ToggleBtn = Instance.new("TextButton", Library)
ToggleBtn.Size = UDim2.new(0, 70, 0, 70); ToggleBtn.Position = UDim2.new(0, 20, 0, 250)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); ToggleBtn.Text = "💰"; ToggleBtn.TextSize = 40
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", ToggleBtn)
Stroke.Color = Color3.fromRGB(255, 215, 0); Stroke.Thickness = 2
ToggleBtn.Active = true; ToggleBtn.Draggable = true

-- [ 2. เมนูหลัก ]
local MainFrame = Instance.new("Frame", Library)
MainFrame.Size = UDim2.new(0, 230, 0, 360); MainFrame.Position = UDim2.new(0.5, -115, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); MainFrame.Visible = false
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(70, 70, 70)
MainFrame.Active = true; MainFrame.Draggable = true

-- [ 3. หัวข้อแบงก์มีปีก ]
local TopIcon = Instance.new("TextLabel", MainFrame)
TopIcon.Size = UDim2.new(1, 0, 0, 90); TopIcon.Text = "💸"; TopIcon.BackgroundTransparency = 1; TopIcon.TextSize = 55

-- ฟังก์ชันสร้างปุ่ม (เช็คแล้วว่าปุ่ม 1 ต้องใช้ฟังก์ชันนี้)
local function createMoneyBtn(text, pos, action)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 190, 0, 55); btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60); btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "💸 " .. text .. " 💸"; btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 20
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(action)
    return btn
end

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local moneyEmojis = {"💵", "💴", "💶", "💷", "💸"}

-- ฟังก์ชันเล่นเสียง (แก้ใหม่ให้ดังผ่าน PlayerGui)
local function playSfx(id)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Volume = 2; s.Parent = player:WaitForChild("PlayerGui")
    s:Play(); debris:AddItem(s, 2)
end

-- ==========================================
-- [[ 💸ปุ่ม 1: ออร่าเงิน💸 (ใส่กลับมาให้แล้ว!) ]]
-- ==========================================
local auraActive = false
createMoneyBtn("ออร่าเงิน", UDim2.new(0.1, 0, 0.3, 0), function()
    auraActive = not auraActive
    playSfx(12222232) -- เสียงติ๊กตอนเปิด
end)

runService.RenderStepped:Connect(function()
    if auraActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if player.Character.HumanoidRootPart.Velocity.Magnitude > 1 then
            local p = Instance.new("Part", workspace)
            p.Size = Vector3.new(1, 1, 1); p.Transparency = 1; p.CanCollide = false
            p.Position = player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-2,2), 0, math.random(-2,2))
            local bil = Instance.new("BillboardGui", p); bil.Size = UDim2.new(0, 50, 0, 50); bil.AlwaysOnTop = true
            local lbl = Instance.new("TextLabel", bil); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1
            lbl.Text = moneyEmojis[math.random(1, #moneyEmojis)]; lbl.TextSize = 25
            local force = Instance.new("BodyForce", p); force.Force = Vector3.new(math.random(-15,15), 25, math.random(-15,15))
            debris:AddItem(p, 1.2)
        end
    end
end)

-- ==========================================
-- [[ 💸ปุ่ม 2: ไอเทมคนรวย💸 ]]
-- ==========================================
createMoneyBtn("ไอเทมคนรวย", UDim2.new(0.1, 0, 0.5, 0), function()
    local tool = Instance.new("Tool", player.Backpack)
    tool.Name = "💰ถุงเงิน💰"; tool.RequiresHandle = true
    local handle = Instance.new("Part", tool); handle.Name = "Handle"; handle.Size = Vector3.new(1, 1, 1)
    handle.Color = Color3.fromRGB(255, 215, 0); handle.Material = Enum.Material.Metal
    tool.Activated:Connect(function()
        playSfx(5148443210) -- เสียงระเบิดเงิน
        local pos = mouse.Hit.p
        for i = 1, 12 do
            task.spawn(function()
                local part = Instance.new("Part", workspace); part.Size = Vector3.new(1, 1, 1); part.Transparency = 1; part.CanCollide = false
                part.Position = pos + Vector3.new(0, 1, 0)
                local b = Instance.new("BillboardGui", part); b.Size = UDim2.new(0, 45, 0, 45); b.AlwaysOnTop = true
                local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
                l.Text = moneyEmojis[math.random(1, #moneyEmojis)]; l.TextSize = 30
                local vel = Instance.new("BodyVelocity", part); vel.MaxForce = Vector3.new(1,1,1) * 10^5
                vel.Velocity = Vector3.new(math.random(-25,25), math.random(15,35), math.random(-25,25))
                debris:AddItem(part, 1.5); task.wait(0.1); if vel then vel:Destroy() end
            end)
        end
    end)
end)

-- ==========================================
-- [[ 💸ปุ่ม 3: โลกรวย💸 ]]
-- ==========================================
local worldGoldActive = false
local originalData = {}
createMoneyBtn("โลกรวย", UDim2.new(0.1, 0, 0.7, 0), function()
    worldGoldActive = not worldGoldActive
    if worldGoldActive then
        playSfx(4138611311) -- เสียงพลังงาน
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsDescendantOf(player.Character) then
                originalData[v] = {v.Color, v.Material, v.Reflectance}
                v.Color = Color3.fromRGB(255, 215, 0); v.Material = Enum.Material.Metal; v.Reflectance = 0.4
            end
        end
    else
        playSfx(156747124) -- เสียงปิด
        for part, data in pairs(originalData) do
            if part and part.Parent then
                part.Color = data[1]; part.Material = data[2]; part.Reflectance = data[3]
            end
        end
        originalData = {}
    end
end)
