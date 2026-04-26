local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Lữ Tài Vip",
    SubTitle = "by Lữ Tài",
    TabWidth = 120,
    Size = UDim2.fromOffset(500, 400),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Camera Settings", Icon = "camera" }),
    AutoChest = Window:AddTab({ Title = "Auto Farm Chest", Icon = "box" })
}

-- [NÚT LỮ TÀI - VIỀN AQUA]
local OpenBtn = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIBorder = Instance.new("UIStroke")

OpenBtn.Name = "LuTaiVipOpen"
OpenBtn.Parent = game:GetService("CoreGui")
OpenBtn.ResetOnSpawn = false

MainBtn.Parent = OpenBtn
MainBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainBtn.BackgroundTransparency = 0.2
MainBtn.Position = UDim2.new(0, 15, 0.5, 0)
MainBtn.Size = UDim2.new(0, 80, 0, 35)
MainBtn.Text = "Lữ Tài"
MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainBtn.Font = Enum.Font.GothamBold
MainBtn.TextSize = 16

UIBorder.Parent = MainBtn
UIBorder.Color = Color3.fromRGB(0, 255, 255)
UIBorder.Thickness = 3
UIBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

MainBtn.Draggable = true
MainBtn.Active = true
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainBtn

MainBtn.MouseButton1Click:Connect(function() Window:Minimize() end)

-- ==========================================
-- MỤC 1: CAMERA SETTINGS
-- ==========================================
Tabs.Main:AddSlider("ZoomSlider", {
    Title = "Khoảng cách Zoom",
    Default = 128, Min = 128, Max = 3000, Rounding = 0,
    Callback = function(Value)
        game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = Value
    end
})

Tabs.Main:AddToggle("NoFog", {
    Title = "Xóa Sương Mù (Clear View)",
    Default = false,
    Callback = function(Value)
        _G.NoFog = Value
        task.spawn(function()
            while _G.NoFog do
                game:GetService("Lighting").FogEnd = 100000
                local atmos = game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere")
                if atmos then atmos.Parent = game:GetService("TestService") end
                task.wait(2)
            end
            if not _G.NoFog then
                local atmos = game:GetService("TestService"):FindFirstChildOfClass("Atmosphere")
                if atmos then atmos.Parent = game:GetService("Lighting") end
                game:GetService("Lighting").FogEnd = 1000
            end
        end)
    end
})

-- ==========================================
-- MỤC 2: AUTO FARM CHEST (NHẶT TOÀN SERVER)
-- ==========================================
Tabs.AutoChest:AddToggle("AutoChestToggle", {
    Title = "Bật Auto Nhặt Rương Toàn Server",
    Default = false,
    Callback = function(Value)
        _G.AutoChest = Value
        
        if Value then
            -- Vòng lặp nhặt rương thông minh
            task.spawn(function()
                while _G.AutoChest do
                    local foundChest = false
                    pcall(function()
                        -- Quét tất cả rương hiện có trong Workspace
                        for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
                            if v:IsA("Part") and v.Name:find("Chest") then
                                local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if root and _G.AutoChest then
                                    foundChest = true
                                    -- Teleport trực tiếp đến rương
                                    root.CFrame = v.CFrame
                                    task.wait(0.2) -- Đợi một chút để game nhận diện đã nhặt
                                end
                            end
                        end
                        
                        -- Nếu không thấy rương ở gần, quét sâu hơn vào các folder chứa rương ẩn
                        if not foundChest then
                            for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                                if v:IsA("TouchTransmitter") and v.Parent and v.Parent.Name:find("Chest") then
                                    local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if root and _G.AutoChest then
                                        root.CFrame = v.Parent.CFrame
                                        task.wait(0.2)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)

            -- Vòng lặp Auto Reset (Giúp game load lại rương ở đảo khác)
            task.spawn(function()
                while _G.AutoChest do
                    task.wait(12)
                    if _G.AutoChest then
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid.Health = 0 
                        end
                    end
                end
            end)
        end
    end
})

Window:SelectTab(1)

