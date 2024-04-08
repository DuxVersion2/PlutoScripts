_G.Configuration {
    Huges = true,
    Titanics = true,
    MaximumHugeAmount = 1000000,
    MaximumTitanicAmount = 500000000,
    Webhook = ""
}

local Players = game:GetService("Players")
local HTTPService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Request = (syn and syn.request) or request or (http and http.request) or http_request

local Network = ReplicatedStorage.Network
local Player = Players.LocalPlayer
local Booths = workspace["__THINGS"].Booths

local HugeIDs = {}
local TitanicIDs = {}
local NameIDs = {}

if _G.Configuration.Huges then
    for i, Pet in ipairs(ReplicatedStorage.__DIRECTORY.Pets.Huge:GetChildren()) do
        local Module = require(Pet)
        table.insert(HugeIDs, Module.thumbnail)
        table.insert(HugeIDs, Module.goldenThumbnail)
    
        NameIDs[Module.thumbnail] = Pet.Name
        NameIDs[Module.goldenThumbnail] = "Golden "..Pet.Name
    end
end

if _G.Configuration.Titanics then
    for i, Pet in ipairs(ReplicatedStorage.__DIRECTORY.Pets.Titanic:GetChildren()) do
        local Module = require(Pet)
        table.insert(TitanicIDs, Module.thumbnail)
        table.insert(TitanicIDs, Module.goldenThumbnail)
    
        NameIDs[Module.thumbnail] = Pet.Name
        NameIDs[Module.goldenThumbnail] = "Golden "..Pet.Name
    end
end

function GetTotalDiamonds()
    return Player.leaderstats["💎 Diamonds"].Value
end

function GetNameByIconAsync(Icon)
    return NameIDs[Icon]
end

function StringToInt(String)
    local suffixes = {['K'] = 1000, ['M'] = 1000000, ['B'] = 1000000000}
    local number

    number = tonumber(String)
    if number then
        return number
    else
        local suffix = String:sub(-1):upper()
        local number_str = String:sub(1, -2)
        
        if suffixes[suffix] then
            number = tonumber(number_str) * suffixes[suffix]
            if number then
                return number
            else
                return false
            end
        else
            return false
        end
    end
end

function GetUserNameFromDisplayNameAsync(DisplayName)
    local Username = false

    for i, Player in pairs(Players:GetPlayers()) do
        if Player.DisplayName == DisplayName then
            Username = Player.Name
            break
        end
    end

    return Username
end

function GetFileFromImageAsync(Image)
    local Image = string.gsub(Image, "rbxassetid://", "")

    return HTTPService:JSONDecode(Request({
        Url = "https://thumbnails.roproxy.com/v1/assets?assetIds="..Image.."&size=250x250&format=Png&isCircular=false",
        Method = "GET",
    }).Body).data[1].imageUrl
end

function SendWebhook(Pet)
    Request({
        Url = _G.Configuration.Webhook,
        Method = "POST",
        Body = HTTPService:JSONEncode({
            ["content"] = "||@everyone @here||",
            ["embeds"] = {
                {
                    ["title"] = "**Pet Sniped**",
                    ["description"] = "🤵 Account: "..Player.Name.."\n💎 Diamonds Left: "..tostring(GetTotalDiamonds()).."\n🐶 Pet Information:\n```👤 Name: "..Pet.Name.."\n🔢 Quantity: "..tostring(Pet.Quantity).."\n🏷️ Price: "..tostring(Pet.Price).."```",
                    ["type"] = "rich",
                    ["color"] = tonumber(0x0080ff),
                    ["thumbnail"] = {
                        ["url"] = GetFileFromImageAsync(Pet.Image)
                    },
                    ["footer"] = {
                        ["text"] = "Pluto Booth Sniper"
                    },
                }
            }
        }),
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })
end

Booths.ChildAdded:Connect(function(Booth)
    if Booth:IsA("Model") and Booth.Name ~= "Booth" then
    local Pets = Booth.Pets:WaitForChild("BoothTop").PetScroll
    local User = Booth.Info:WaitForChild("BoothBottom").Frame.Top.Text
    User = string.gsub(User, "'s Booth!", "")
    User = GetUserNameFromDisplayNameAsync(User)
    User = Players:GetUserIdFromNameAsync(User)

    if User then
        Pets.ChildAdded:Connect(function(Item)
            if Item:IsA("Frame") then
                local Diamonds = GetTotalDiamonds()
                local MaximumPrice = false
                
                local ItemID = Item.Name
                local Price = Item.Buy.Cost.Text
                local Icon = Item.Holder.ItemSlot.Icon.Image
                local Quantity = Item.Holder.ItemSlot.Quantity.Text
                
                Price = StringToInt(Price)

                Quantity = string.gsub(Quantity, "x", "")
                Quantity = tonumber(Quantity)

                if table.find(HugeIDs, Icon) then
                    MaximumPrice = _G.Configuration.MaximumHugeAmount
                elseif table.find(TitanicIDs, Icon) then
                    MaximumPrice = _G.Configuration.MaximumTitanicAmount
                end

                local ItemName = GetNameByIconAsync(Icon)

                if MaximumPrice and Quantity and Price and Diamonds then
                    if Price <= MaximumPrice then
                        if Diamonds >= Price * Quantity then
                            repeat
                                wait()
                            until not Item:FindFirstChild("CircularBar")
                            
                            wait(0.1)
                            Network:WaitForChild("Booths_RequestPurchase"):InvokeServer(User, {[ItemID] = Quantity})
                            SendWebhook({Name = ItemName, Quantity = Quantity, Price = Price, Image = Icon})
                        else
                            local MaxQuantity = math.floor(Diamonds / Price)
                            if MaxQuantity > 0 then
                                Network:WaitForChild("Booths_RequestPurchase"):InvokeServer(User, {[ItemID] = MaxQuantity})
                                SendWebhook({Name = ItemName, Quantity = MaxQuantity, Price = Price, Image = Icon})
                            else
                                print("Insufficient diamonds to purchase item:", ItemName)
                            end
                        end
                    end
                end
            end
        end)
    end
    end
end)

for i, Booth in pairs(Booths:GetChildren()) do
    local Pets = Booth.Pets.BoothTop.PetScroll
    local User = Booth.Info.BoothBottom.Frame.Top.Text
    User = string.gsub(User, "'s Booth!", "")
    User = GetUserNameFromDisplayNameAsync(User)
    User = Players:GetUserIdFromNameAsync(User)

    if User then
        Pets.ChildAdded:Connect(function(Item)
            if Item:IsA("Frame") then
                local Diamonds = GetTotalDiamonds()
                local MaximumPrice = false
                
                local ItemID = Item.Name
                local Price = Item.Buy.Cost.Text
                local Icon = Item.Holder.ItemSlot.Icon.Image
                local Quantity = Item.Holder.ItemSlot.Quantity.Text
                
                Price = StringToInt(Price)

                Quantity = string.gsub(Quantity, "x", "")
                Quantity = tonumber(Quantity)

                if table.find(HugeIDs, Icon) then
                    MaximumPrice = _G.Configuration.MaximumHugeAmount
                elseif table.find(TitanicIDs, Icon) then
                    MaximumPrice = _G.Configuration.MaximumTitanicAmount
                end

                local ItemName = GetNameByIconAsync(Icon)

                if MaximumPrice and Quantity and Price and Diamonds then
                    if Price <= MaximumPrice then
                        if Diamonds >= Price * Quantity then
                            repeat
                                wait()
                            until not Item:FindFirstChild("CircularBar")

                            wait(0.1)
                            Network:WaitForChild("Booths_RequestPurchase"):InvokeServer(User, {[ItemID] = Quantity})
                            SendWebhook({Name = ItemName, Quantity = Quantity, Price = Price, Image = Icon})
                        else
                            local MaxQuantity = math.floor(Diamonds / Price)
                            if MaxQuantity > 0 then
                                Network:WaitForChild("Booths_RequestPurchase"):InvokeServer(User, {[ItemID] = MaxQuantity})
                                SendWebhook({Name = ItemName, Quantity = MaxQuantity, Price = Price, Image = Icon})
                            else
                                print("Insufficient diamonds to purchase item:", ItemName)
                            end
                        end
                    end
                end
            end
        end)
    end
end
