-- ==========================================
-- SCRIPT: LỮ TÀI HUB - FLUENT EDITION
-- TÍNH NĂNG: AUTO CHEST, ANTI-KICK, RESET 20S (CHỈ KHI BẬT)
-- ==========================================

-- 1. CHỨC NĂNG CHỐNG BỊ KÍCH (ANTI-IDLE)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. KHỞI TẠO MENU FLUENT
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "LỮ TÀI HUB - VIP",
    SubTitle = "bởi Lữ Tài",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Hiệu ứng mờ ảo (Acrylic)
    Theme = "Dark", -- Chủ đề Dark
    MinimizeKey = Enum.KeyCode.RightControl -- Phím tắt/mở Menu
})

-- Tự động chọn phe Pirates
pcall(function() 
    if game.Players.LocalPlayer.Team == nil then 
        game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("SetTeam","Pirates") 
    end 
end)

-- Tạo các Tab
local Tabs = {
    Main = Window:AddTab({ Title = "Chính", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Cài đặt", Icon = "settings" })
}

local Options = Fluent.Options
_G.AutoChest = false

-- 3. TỰ ĐỘNG RESET MỖI 20 GIÂY (CHỈ CHẠY KHI BẬT NHẶT RƯƠNG)
task.spawn(function()
    while true do
        task.wait(20)
        if _G.AutoChest then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char:BreakJoints() -- Phá hủy nhân vật để Reset
                end
            end)
        end
    end
end)

-- 4. TÍNH NĂNG NHẶT RƯƠNG TỐC ĐỘ CAO (DÙNG FLUENT TOGGLE)
Tabs.Main:AddToggle("AutoChestToggle", {
    Title = "Bật/Tắt Nhặt Rương (SIÊU NHANH)",
    Default = false,
    Callback = function(v)
        _G.AutoChest = v
        if v then
            task.spawn(function()
                while _G.AutoChest do
                    pcall(function()
                        for _,v in pairs(game:GetDescendants()) do
                            if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Name:find("Chest") then
                                -- Dịch chuyển tức thời đến rương
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                                -- Chỉ đợi cực ngắn để server kịp nhận rương
                                task.wait(0.1)
                                if not _G.AutoChest then break end
                            end
                        end
                    end)
                    task.wait(0.05)
                end
            end)
        end
    end
})

-- 5. TÍNH NĂNG NHẢY SERVER (DÙNG FLUENT BUTTON)
Tabs.Main:AddButton({
    Title = "Nhảy Server (Khi hết rương)",
    Description = "Tự động tìm server mới",
    Callback = function()
        local Http = game:GetService("HttpService")
        local Tp = game:GetService("TeleportService")
        local S = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _,s in pairs(S.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                Tp:TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end
})

-- Hiển thị thông tin cài đặt
Tabs.Settings:AddParagraph({
    Title = "Thông tin",
    Content = "Reset 20s sẽ chạy khi bạn bật Nhặt Rương.\nPhím tắt/mở Menu: RightControl"
})

-- Quản lý Cài đặt
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentSettings")
SaveManager:SetFolder("FluentSettings")

Window:SelectTab(Tabs.Main)

-- Thông báo chào Lữ Tài (Dùng Fluent Notify)
Fluent:Notify({
    Title = "LỮ TÀI HUB",
    Content = "Xin Chào.",
    SubContent = "Scrip Đã Sẵn Sàng", -- Mô tả nhỏ
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
