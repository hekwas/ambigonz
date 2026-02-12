local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local KEYS_URL = "https://raw.githubusercontent.com/hekwas/ambigonz/refs/heads/main/keys.json"
local SAVE_FILE = "gonzo_cache.json"

-- ===== LOCAL TOOL START FUNCTION =====
local function StartTool()
    print("Tool started!")
    loadstring(game:HttpGet('https://raw.githubusercontent.com/hekwas/ambigonz/refs/heads/main/67bile.lua'))()
end

-- ===== CACHE =====
local function save(data)
    if writefile then
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
    end
end

local function load()
    if readfile and isfile and isfile(SAVE_FILE) then
        return HttpService:JSONDecode(readfile(SAVE_FILE))
    end
end

local saved = load()
if saved and saved.expire and saved.expire > os.time() then
    StartTool()
    return
end

-- ===== UI =====
local gui = Instance.new("ScreenGui", player.PlayerGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 220)
frame.Position = UDim2.new(0.5, -180, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(12,12,18)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "GONZO KEY"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(200,0,255)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8,0,0,45)
box.Position = UDim2.new(0.1,0,0.4,0)
box.BackgroundColor3 = Color3.fromRGB(20,15,30)
box.TextColor3 = Color3.fromRGB(200,0,255)
box.PlaceholderText = "Enter Key..."
box.Font = Enum.Font.Gotham
box.TextSize = 14
Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.6,0,0,45)
button.Position = UDim2.new(0.2,0,0.7,0)
button.BackgroundColor3 = Color3.fromRGB(150,0,255)
button.Text = "VERIFY"
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.GothamBold
button.TextSize = 16
Instance.new("UICorner", button).CornerRadius = UDim.new(0,12)

button.MouseButton1Click:Connect(function()

    button.Text = "CHECKING..."

    local success, response = pcall(function()
        return game:HttpGet(KEYS_URL)
    end)

    if not success then
        button.Text = "ERROR"
        task.wait(1)
        button.Text = "VERIFY"
        return
    end

    local keyTable = HttpService:JSONDecode(response)

    if keyTable[box.Text] then
        save({
            expire = os.time() + (60*60*48)
        })

        button.Text = "ACCESS GRANTED"
        task.wait(1)
        gui:Destroy()
        StartTool()
    else
        button.Text = "INVALID KEY"
        task.wait(1)
        button.Text = "VERIFY"
    end
end)
