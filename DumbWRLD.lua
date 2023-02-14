-- Check if the script is already running
-- If it is, then don't run it again

if _G.DumbWRLDState then
    print("DumbWRLD is already running!")
    return
end

-- Set the state to true

_G.DumbWRLDState = true

-- API CALLS

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pastis444/DumbWRLD/master/bracketv3.lua"))()
local api = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pastis444/DumbWRLD/master/xlpapi.lua"))()
local bssapi = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pastis444/DumbWRLD/master/bssapi.lua"))()

if not isfolder("DumbWRLD") then makefolder("DumbWRLD") end
if isfile('DumbWRLD.txt') == false then (syn and syn.request or http_request)({ Url = "http://127.0.0.1:6463/rpc?v=1",Method = "POST",Headers = {["Content-Type"] = "application/json",["Origin"] = "https://discord.com"},Body = game:GetService("HttpService"):JSONEncode({cmd = "INVITE_BROWSER",args = {code = "fU3jdejJxK"},nonce = game:GetService("HttpService"):GenerateGUID(false)}),writefile('DumbWRLD.txt', "discord")})end

-- Script temporary variables
local playerstatsevent = game:GetService("ReplicatedStorage").Events.RetrievePlayerStats
local statstable = playerstatsevent:InvokeServer()
local monsterspawners = game:GetService("Workspace").MonsterSpawners
local rarename
function rtsg() tab = game.ReplicatedStorage.Events.RetrievePlayerStats:InvokeServer() return tab end
function maskequip(mask) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = mask, ["Category"] = "Accessory"} game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end
local lasttouched = nil
local done = true
local hi = false
function oldmasks() local tab = game.ReplicatedStorage.Events.RetrievePlayerStats:InvokeServer() local oldmaskTab = tab["EquippedAccessories"] local oldmask = oldmaskTab["Hat"] return oldmask end

-- Script tables

local temptable = {
    version = "1.0.0",
    blackfield = "Ant Field",
    redfields = {},
    bluefields = {},
    whitefields = {},
    shouldiconvertballoonnow = false,
    balloondetected = false,
    puffshroomdetected = false,
    magnitude = 70,
    starttime = os.time(),
    blacklist = {
        ""
    },
    running = false,
    configname = "",
    tokenpath = game:GetService("Workspace").Collectibles,
    started = {
        vicious = false,
        mondo = false,
        windy = false,
        ant = false,
        commando = false,
        monsters = false
    },
    detected = {
        vicious = false,
        windy = false
    },
    tokensfarm = false,
    converting = false,
    honeystart = 0,
    grib = nil,
    gribpos = CFrame.new(0,0,0),
    honeycurrent = statstable.Totals.Honey,
    dead = false,
    float = false,
    pepsigodmode = false,
    pepsiautodig = false,
    alpha = false,
    beta = false,
    myhiveis = false,
    invis = false,
    windy = nil,
    sprouts = {
        detected = false,
        coords
    },
    cache = {
        autofarm = false,
        killmondo = false,
        vicious = false,
        windy = false
    },
    allplanters = {},
    planters = {
        planter = {},
        cframe = {},
        activeplanters = {
            type = {},
            id = {}
        }
    },
    monstertypes = {"Ladybug", "Rhino", "Spider", "Scorpion", "Mantis", "Werewolf"},
    ["stopapypa"] = function(path, part)
        local Closest
        for i,v in next, path:GetChildren() do
            if v.Name ~= "PlanterBulb" then
                if Closest == nil then
                    Closest = v.Soil
                else
                    if (part.Position - v.Soil.Position).magnitude < (Closest.Position - part.Position).magnitude then
                        Closest = v.Soil
                    end
                end
            end
        end
        return Closest
    end,
    coconuts = {},
    crosshairs = {},
    crosshair = false,
    coconut = false,
    act = 0,
    popstar = 0,
    ['touchedfunction'] = function(v)
        if lasttouched ~= v then
            if v.Parent.Name == "FlowerZones" then
                if v:FindFirstChild("ColorGroup") then
                    if tostring(v.ColorGroup.Value) == "Red" then
                        maskequip("Demon Mask")
                    elseif tostring(v.ColorGroup.Value) == "Blue" then
                        maskequip("Diamond Mask")
                    end
                else
                    maskequip("Gummy Mask")
                end
                lasttouched = v
            end
        end
    end,
    runningfor = 0,
    oldtool = rtsg()["EquippedCollector"],
    oldequippedmask = oldmasks(),
    ['gacf'] = function(part, st)
        coordd = CFrame.new(part.Position.X, part.Position.Y+st, part.Position.Z)
        return coordd
    end,
    collecthoneytoken = false
}

local planterst = {
    plantername = {},
    planterid = {}
}

for i,v in next, temptable.blacklist do if v == api.nickname then game.Players.LocalPlayer:Kick("You're blacklisted! Get clapped!") end end
if temptable.honeystart == 0 then temptable.honeystart = statstable.Totals.Honey end


for i,v in next, game:GetService("Workspace").MonsterSpawners:GetDescendants() do if v.Name == "TimerAttachment" then v.Name = "Attachment" end end
for i,v in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do if v.Name == "RoseBush" then v.Name = "ScorpionBush" elseif v.Name == "RoseBush2" then v.Name = "ScorpionBush2" end end
for i,v in next, game:GetService("Workspace").FlowerZones:GetChildren() do if v:FindFirstChild("ColorGroup") then if v:FindFirstChild("ColorGroup").Value == "Red" then table.insert(temptable.redfields, v.Name) elseif v:FindFirstChild("ColorGroup").Value == "Blue" then table.insert(temptable.bluefields, v.Name) end else table.insert(temptable.whitefields, v.Name) end end
local flowertable = {}
for _,z in next, game:GetService("Workspace").Flowers:GetChildren() do table.insert(flowertable, z.Position) end
local masktable = {}
for _,v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do if string.match(v.Name, "Mask") then table.insert(masktable, v.Name) end end
local collectorstable = {}
for _,v in next, getupvalues(require(game:GetService("ReplicatedStorage").Collectors).Exists) do for e,r in next, v do table.insert(collectorstable, e) end end
local fieldstable = {}
for _,v in next, game:GetService("Workspace").FlowerZones:GetChildren() do table.insert(fieldstable, v.Name) end
local toystable = {}
for _,v in next, game:GetService("Workspace").Toys:GetChildren() do table.insert(toystable, v.Name) end
local spawnerstable = {}
for _,v in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do table.insert(spawnerstable, v.Name) end
local accesoriestable = {}
for _,v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do if v.Name ~= "UpdateMeter" then table.insert(accesoriestable, v.Name) end end
for i,v in pairs(getupvalues(require(game:GetService("ReplicatedStorage").PlanterTypes).GetTypes)) do for e,z in pairs(v) do table.insert(temptable.allplanters, e) end end
table.sort(fieldstable)
table.sort(accesoriestable)
table.sort(toystable)
table.sort(spawnerstable)
table.sort(masktable)
table.sort(temptable.allplanters)
table.sort(collectorstable)

-- float pad

local floatpad = Instance.new("Part", game:GetService("Workspace"))
floatpad.CanCollide = false
floatpad.Anchored = true
floatpad.Transparency = 1
floatpad.Name = "FloatPad"

-- cococrab

local cocopad = Instance.new("Part", game:GetService("Workspace"))
cocopad.Name = "Coconut Part"
cocopad.Anchored = true
cocopad.Transparency = 1
cocopad.Size = Vector3.new(10, 1, 10)
cocopad.Position = Vector3.new(-307.52117919922, 105.91863250732, 467.86791992188)

-- antfarm

local antpart = Instance.new("Part", workspace)
antpart.Name = "Ant Autofarm Part"
antpart.Position = Vector3.new(96, 47, 553)
antpart.Anchored = true
antpart.Size = Vector3.new(128, 1, 50)
antpart.Transparency = 1
antpart.CanCollide = false

-- config

local DumbWRLD = {
    rares = {},
    priority = {},
    bestfields = {
        red = "Pepper Patch",
        white = "Coconut Field",
        blue = "Stump Field"
    },
    blacklistedfields = {},
    killerDumbWRLD = {},
    bltokens = {},
    toggles = {
        noconvertpollen = false,
        autofarm = false,
        popstarconvert = false,
        farmclosestleaf = false,
        farmbubbles = false,
        autodig = false,
        farmrares = false,
        rgbui = false,
        farmflower = false,
        farmfuzzy = false,
        farmcoco = false,
        farmflame = false,
        farmclouds = false,
        killmondo = false,
        killvicious = false,
        killcommando = false,
        loopspeed = false,
        loopjump = false,
        autoquest = false,
        autoboosters = false,
        autodispense = false,
        clock = false,
        freeantpass = false,
        honeystorm = false,
        autodoquest = false,
        disableseperators = false,
        npctoggle = false,
        loopfarmspeed = false,
        mobquests = false,
        traincrab = false,
        avoidmobs = false,
        farmsprouts = false,
        enabletokenblacklisting = false,
        farmunderballoons = false,
        farmsnowflakes = false,
        collectgingerbreads = false,
        collectcrosshairs = false,
        farmpuffshrooms = false,
        tptonpc = false,
        donotfarmtokens = false,
        convertballoons = false,
        autostockings = false,
        autosamovar = false,
        autoonettart = false,
        autocandles = false,
        autofeast = false,
        autohoneywreath = false,
        autoplanters = false,
        autokillmobs = false,
        autoant = false,
        autoantonquest = false,
        killwindy = false,
        godmode = false,
        autocloudvial = false,
        demonmask = false,
        blueextract = false,
        redextract = false,
        oil = false,
        glue = false,
        glitter = false,
        fielddice = false,
        enzyme = false,
        tropicaldrink = false,
        purplepot = false,
        jellybean = false,
        snowflake = false
    },
    vars = {
        field = "Ant Field",
        convertat = 100,
        farmspeed = 60,
        prefer = "Tokens",
        walkspeed = 70,
        jumppower = 70,
        npcprefer = "All Quests",
        farmtype = "Walk",
        monstertimer = 3,
        Keybind = Enum.KeyCode.RightControl,
        autodigmode = "Normal"
    },
    dispensesettings = {
        blub = false,
        straw = false,
        treat = false,
        coconut = false,
        glue = false,
        rj = false,
        white = false,
        red = false,
        blue = false
    },
    planterat = 100
}

local defaultDumbWRLD = DumbWRLD

local buffTable = {
    "Blue Extract";
    "Red Extract";
    "Oil";
    "Enzymes";
    "Glue";
    "Glitter";
    "Tropical Drink";
    "Purple Potion";
    "Snowflake"
}

local buffs = {
    timers = {
        blueextract = 0,
        redextract = 0,
        oil = 0,
        enzyme = 0,
        glue = 0,
        glitter = 0,
        fielddice = 0,
        tropicaldrink = 0,
        purplepot = 0,
        jellybean = 0,
        snowflake = 0
    },
    name = {
        blueextract = "Blue Extract",
        redextract = "Red Extract",
        oil = "Oil",
        enzyme = "Enzymes",
        glue = "Glue",
        glitter = "Glitter",
        fielddice = "Field Dice",
        tropicaldrink = "Tropical Drink",
        purplepot = "Purple Potion",
        jellybean = "Jelly Beans",
        snowflake = "Snowflake"
    }
}
local extrasvars = {
    demoncounter = 0,
    popstarmustconvert = false,
    popstartimer = 3,
    field = "Sunflower Field",
    timers = {
        popstar = 0
    }
}
-- functions

function itemtimers(item)
    if item == "glitter" then
        if DumbWRLD.toggles.fielddice then
            glittercounter = rtsg()['Totals']['EggUses']['Glitter']
            if os.time() - buffs.timers[item] >= 1680 then
                disableall()
                fieldselected = game:GetService("Workspace").FlowerZones[extrasvars.field]
                fieldpos = CFrame.new(fieldselected.Position.X, fieldselected.Position.Y+3, fieldselected.Position.Z)
                fieldposition = fieldselected.Position
                api.tween(2, fieldpos)
                game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=buffs.name[item]})
                if glittercounter < rtsg()['Totals']['EggUses']['Glitter'] then buffs.timers[item] = os.time() end
                enableall()
            elseif os.time() - buffs.timers[item] >= 840 then
                enoughdice = rtsg()['Eggs']['FieldDice'] > 0
                n = 0
                keyset = {}
                boostlvl = 0
                tempboostlvl = 0
                for i,v in pairs(rtsg()['Modifiers']['PollenBonus']) do
                    n=n+1
                    keyset[n]=i
                    if string.match(keyset[n], 'Zone:'..extrasvars.field) then boostlvl = math.floor(rtsg()['Modifiers']['PollenBonus']['Zone:'.. extrasvars.field .. ',']['Mods'][1]['Value']+0.5) tempboostlvl = math.floor(rtsg()['Modifiers']['PollenBonus']['Zone:'.. extrasvars.field .. ',']['Mods'][1]['Value']+0.5) end
                end
                if boostlvl ~= 0 and boostlvl ~= 4 then
                    repeat
                        enoughdice = rtsg()['Eggs']['FieldDice'] > 0
                        game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=buffs.name['fielddice']})
                        tempboostlvl = math.floor(rtsg()['Modifiers']['PollenBonus']['Zone:'.. extrasvars.field .. ',']['Mods'][1]['Value']+0.5)
                        wait(1)
                    until tempboostlvl == boostlvl + 1 or not enoughdice
                elseif boostlvl == 4 then
                    repeat
                        enoughdice = rtsg()['Eggs']['FieldDice'] > 0
                        game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=buffs.name['fielddice']})
                        tempboostlvl = math.floor(rtsg()['Modifiers']['PollenBonus']['Zone:'.. extrasvars.field .. ',']['Mods'][1]['Value']+0.5)
                        wait(1)
                    until os.time() - math.floor(rtsg()['Modifiers']['PollenBonus']['Zone:'.. extrasvars.field .. ',']['Mods'][1]['Start']) <= 20 or not enoughdice
                end
            end
        else
            glittercounter = rtsg()['Totals']['EggUses']['Glitter']
            if os.time() - buffs.timers[item] >= 910 then
                fieldselected = game:GetService("Workspace").FlowerZones[extrasvars.field]
                fieldpos = CFrame.new(fieldselected.Position.X, fieldselected.Position.Y+3, fieldselected.Position.Z)
                fieldposition = fieldselected.Position
                api.tween(2, fieldpos)
                game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=buffs.name[item]})
                if glittercounter < rtsg()['Totals']['EggUses']['Glitter'] then buffs.timers[item] = os.time() end
            end
        end
    elseif item == "fielddice" then
        if not DumbWRLD.toggles.glitter then
            if os.time() - buffs.timers[item] >= 900 then
                n = 0
                keyset = {}
                fielddicelanded = false
                enoughdice = rtsg()['Eggs']['FieldDice'] > 0
                repeat
                    enoughdice = rtsg()['Eggs']['FieldDice'] > 0
                    game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=buffs.name['fielddice']})
                    for i,v in pairs(rtsg()['Modifiers']['PollenBonus']) do
                        n=n+1
                        keyset[n]=i
                        wait(1)
                        if string.match(keyset[n], 'Zone:'..extrasvars.field) then fielddicelanded = true end
                    end
                until fielddicelanded or not enoughdice
                buffs.timers[item] = os.time()
            end
        end
    elseif item == "snowflake" then
        if os.time() - buffs.timers[item] >= 10 then
            game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=buffs.name[item]})
            buffs.timers[item] = os.time()
        end
    elseif item == "purplepot" then
        if os.time() - buffs.timers[item] >= 905 then
            game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=buffs.name[item]})
            buffs.timers[item] = os.time()
        end
    elseif item == "jellybean" then
        if os.time() - buffs.timers[item] >= 31 then
            game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=buffs.name[item]})
            buffs.timers[item] = os.time()
        end
    else
        if os.time() - buffs.timers[item] >= 605 then
            game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=buffs.name[item]})
            buffs.timers[item] = os.time()
        end
    end
end

function popstarcounter()
    if extrasvars.timers.popstar == 0 then extrasvars.timers.popstar = os.time() end
    if os.time() - extrasvars.timers.popstar >= 60 then
        print('Pop Timers checked : ', os.time() - extrasvars.timers.popstar)
        if not rtsg()['Abilities']['Pop Star']['OnCooldown'] then
            print('Pop Star OnCooldown :', rtsg()['Abilities']['Pop Star']['OnCooldown'])
            extrasvars.timers.popstar = os.time()
            temptable.popstar = temptable.popstar + 1
            if temptable.popstar >= extrasvars.popstartimer then
                print('All the conditions have been checked, error is somewhere else :', temptable.popstar >= extrasvars.popstartimer)
                extrasvars.popstarmustconvert = true
            end
        end
    end
end

function statsget() local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() return stats end
function farm(trying)
    if DumbWRLD.toggles.loopfarmspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = DumbWRLD.vars.farmspeed end
    api.humanoid():MoveTo(trying.Position)
    repeat task.wait() until (trying.Position-api.humanoidrootpart().Position).magnitude <=4 or not IsToken(trying) or not temptable.running
end

function disableall()
    if DumbWRLD.toggles.autofarm and not temptable.converting then
        temptable.cache.autofarm = true
        DumbWRLD.toggles.autofarm = false
    end
    if DumbWRLD.toggles.killmondo and not temptable.started.mondo then
        DumbWRLD.toggles.killmondo = false
        temptable.cache.killmondo = true
    end
    if DumbWRLD.toggles.killvicious and not temptable.started.vicious then
        DumbWRLD.toggles.killvicious = false
        temptable.cache.vicious = true
    end
    if DumbWRLD.toggles.killwindy and not temptable.started.windy then
        DumbWRLD.toggles.killwindy = false
        temptable.cache.windy = true
    end
end

function enableall()
    if temptable.cache.autofarm then
        DumbWRLD.toggles.autofarm = true
        temptable.cache.autofarm = false
    end
    if temptable.cache.killmondo then
        DumbWRLD.toggles.killmondo = true
        temptable.cache.killmondo = false
    end
    if temptable.cache.vicious then
        DumbWRLD.toggles.killvicious = true
        temptable.cache.vicious = false
    end
    if temptable.cache.windy then
        DumbWRLD.toggles.killwindy = true
        temptable.cache.windy = false
    end
end

function gettoken(v3)
    if not v3 then
        v3 = fieldposition
    end
    task.wait()
    for e,r in next, game:GetService("Workspace").Collectibles:GetChildren() do
        itb = false
        if r:FindFirstChildOfClass("Decal") and DumbWRLD.toggles.enabletokenblacklisting then
            if api.findvalue(DumbWRLD.bltokens, string.split(r:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
                itb = true
            end
        end
        if tonumber((r.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and not itb and (v3-r.Position).magnitude <= temptable.magnitude then
            farm(r)
        end
    end
end

function makesprinklers()
    sprinkler = rtsg().EquippedSprinkler
    e = 1
    if sprinkler == "Basic Sprinkler" or sprinkler == "The Supreme Saturator" then
        e = 1
    elseif sprinkler == "Silver Soakers" then
        e = 2
    elseif sprinkler == "Golden Gushers" then
        e = 3
    elseif sprinkler == "Diamond Drenchers" then
        e = 4
    end
    for i = 1, e do
        k = api.humanoid().JumpPower
        if e ~= 1 then api.humanoid().JumpPower = 70 api.humanoid().Jump = true task.wait(.2) end
        game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
        if e ~= 1 then api.humanoid().JumpPower = k task.wait(1) end
    end
end

function killmobs()
    for i,v in pairs(game:GetService("Workspace").MonsterSpawners:GetChildren()) do
        if v:FindFirstChild("Territory") then
            if v.Name ~= "Commando Chick" and v.Name ~= "CoconutCrab" and v.Name ~= "StumpSnail" and v.Name ~= "TunnelBear" and v.Name ~= "King Beetle Cave" and not v.Name:match("CaveMonster") and not v:FindFirstChild("TimerLabel", true).Visible then
                if extrasvars.demoncounter == 0 then
                    temptable.oldequippedmask = rtsg()["EquippedAccessories"]["Hat"]
                end
                if DumbWRLD.toggles.demonmask then
                    extrasvars.demoncounter = extrasvars.demoncounter + 1
                    maskequip('Demon Mask')
                end
                if v.Name:match("Werewolf") then
                    monsterpart = game:GetService("Workspace").Territories.WerewolfPlateau.w
                elseif v.Name:match("Mushroom") then
                    monsterpart = game:GetService("Workspace").Territories.MushroomZone.Part
                else
                    monsterpart = v.Territory.Value
                end
                api.humanoidrootpart().CFrame = monsterpart.CFrame
                repeat api.humanoidrootpart().CFrame = monsterpart.CFrame avoidmob() task.wait(1) until v:FindFirstChild("TimerLabel", true).Visible
                for i = 1, 4 do gettoken(monsterpart.Position) end
                if DumbWRLD.toggles.demonmask then
                    extrasvars.demoncounter = extrasvars.demoncounter - 1
                end
                if extrasvars.demoncounter == 0 then
                    maskequip(temptable.oldequippedmask)
                end
            end
        end
    end
end

function IsToken(token)
    if not token then
        return false
    end
    if not token.Parent then return false end
    if token then
        if token.Orientation.Z ~= 0 then
            return false
        end
        if token:FindFirstChild("FrontDecal") then
        else
            return false
        end
        if not token.Name == "C" then
            return false
        end
        if not token:IsA("Part") then
            return false
        end
        return true
    else
        return false
    end
end

function check(ok)
    if not ok then
        return false
    end
    if not ok.Parent then return false end
    return true
end

function getplanters()
    table.clear(planterst.plantername)
    table.clear(planterst.planterid)
    for i,v in pairs(debug.getupvalues(require(game:GetService("ReplicatedStorage").LocalPlanters).LoadPlanter)[4]) do
        if v.GrowthPercent >= (DumbWRLD.planterat/100) and v.IsMine then
            table.insert(planterst.plantername, v.Type)
            table.insert(planterst.planterid, v.ActorID)
        end
    end
end

function farmant()
    antpart.CanCollide = true
    temptable.started.ant = true
    anttable = {left = true, right = false}
    temptable.oldtool = rtsg()['EquippedCollector']
    if extrasvars.demoncounter == 0 then
        temptable.oldequippedmask = rtsg()["EquippedAccessories"]["Hat"]
    end
    if DumbWRLD.toggles.demonmask then
        extrasvars.demoncounter = extrasvars.demoncounter + 1
        maskequip('Demon Mask')
    end
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip",{["Mute"] = true,["Type"] = "Spark Staff",["Category"] = "Collector"})
    game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge")
    DumbWRLD.toggles.autodig = true
    acl = CFrame.new(127, 48, 547)
    acr = CFrame.new(65, 48, 534)
    task.wait(1)
    game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
    api.humanoidrootpart().CFrame = api.humanoidrootpart().CFrame + Vector3.new(0, 15, 0)
    task.wait(3)
    repeat
        task.wait()
        for i,v in next, game.Workspace.Toys["Ant Challenge"].Obstacles:GetChildren() do
            if v:FindFirstChild("Root") then
                if (v.Root.Position-api.humanoidrootpart().Position).magnitude <= 40 and anttable.left then
                    api.humanoidrootpart().CFrame = acr
                    anttable.left = false anttable.right = true
                    wait(.1)
                elseif (v.Root.Position-api.humanoidrootpart().Position).magnitude <= 40 and anttable.right then
                    api.humanoidrootpart().CFrame = acl
                    anttable.left = true anttable.right = false
                    wait(.1)
                end
            end
        end
    until game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value == false
    task.wait(1)
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip",{["Mute"] = true,["Type"] = temptable.oldtool,["Category"] = "Collector"})
    if DumbWRLD.toggles.demonmask then
        extrasvars.demoncounter = extrasvars.demoncounter - 1
    end
    if extrasvars.demoncounter == 0 then
        maskequip(temptable.oldequippedmask)
    end
    temptable.started.ant = false
    antpart.CanCollide = false
end

function collectplanters()
    getplanters()
    for i,v in pairs(planterst.plantername) do
        if api.partwithnamepart(v, game:GetService("Workspace").Planters) and api.partwithnamepart(v, game:GetService("Workspace").Planters):FindFirstChild("Soil") then
            soil = api.partwithnamepart(v, game:GetService("Workspace").Planters).Soil
            api.humanoidrootpart().CFrame = soil.CFrame
            game:GetService("ReplicatedStorage").Events.PlanterModelCollect:FireServer(planterst.planterid[i])
            task.wait(.5)
            game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = v.." Planter"})
            for i = 1, 5 do gettoken(soil.Position) end
            task.wait(2)
        end
    end
end

function getprioritytokens()
    task.wait()
    if temptable.running == false then
        for e,r in next, game:GetService("Workspace").Collectibles:GetChildren() do
            if r:FindFirstChildOfClass("Decal") then
                local aaaaaaaa = string.split(r:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]
                if aaaaaaaa ~= nil and api.findvalue(DumbWRLD.priority, aaaaaaaa) then
                    if r.Name == game.Players.LocalPlayer.Name and not r:FindFirstChild("got it") or tonumber((r.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and not r:FindFirstChild("got it") then
                        farm(r) local val = Instance.new("IntValue",r) val.Name = "got it" break
                    end
                end
            end
        end
    end
end

function gethiveballoon()
    task.wait()
    result = false
    for i,hive in next, game:GetService("Workspace").Honeycombs:GetChildren() do
        task.wait()
        if hive:FindFirstChild("Owner") and hive:FindFirstChild("SpawnPos") then
            if tostring(hive.Owner.Value) == game.Players.LocalPlayer.Name then
                for e,balloon in next, game:GetService("Workspace").Balloons.HiveBalloons:GetChildren() do
                    task.wait()
                    if balloon:FindFirstChild("BalloonRoot") then
                        if (balloon.BalloonRoot.Position-hive.SpawnPos.Value.Position).magnitude < 15 then
                            result = true
                            break
                        end
                    end
                end
            end
        end
    end
    return result
end

function converthoney()
    task.wait(0)
    if temptable.converting and not DumbWRLD.toggles.noconvertpollen then
        if game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or (game:GetService("Players").LocalPlayer.SpawnPos.Value.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 10 then
            api.tween(1, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 9))
            task.wait(.9)
            if game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or (game:GetService("Players").LocalPlayer.SpawnPos.Value.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 10 then game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking") end
            task.wait(.1)
        end
    end
end

function closestleaf()
    for i,v in next, game.Workspace.Flowers:GetChildren() do
        if temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

function getbubble()
    for i,v in next, game.workspace.Particles:GetChildren() do
        if string.find(v.Name, "Bubble") and temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

function getballoons()
    for i,v in next, game:GetService("Workspace").Balloons.FieldBalloons:GetChildren() do
        if v:FindFirstChild("BalloonRoot") and v:FindFirstChild("PlayerName") then
            if v:FindFirstChild("PlayerName").Value == game.Players.LocalPlayer.Name then
                if tonumber((v.BalloonRoot.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
                    api.walkTo(v.BalloonRoot.Position)
                end
            end
        end
    end
end

function getflower()
    flowerrrr = flowertable[math.random(#flowertable)]
    if tonumber((flowerrrr-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and tonumber((flowerrrr-fieldposition).magnitude) <= temptable.magnitude/1.4 then
        if temptable.running == false then
            if DumbWRLD.toggles.loopfarmspeed then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = DumbWRLD.vars.farmspeed
            end
            api.walkTo(flowerrrr)
        end
    end
end

function getcloud()
    for i,v in next, game:GetService("Workspace").Clouds:GetChildren() do
        e = v:FindFirstChild("Plane")
        if e and tonumber((e.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            api.walkTo(e.Position)
        end
    end
end

function getcoco(v)
    if temptable.coconut then repeat task.wait() until not temptable.coconut end
    temptable.coconut = true
    api.tween(.1, v.CFrame)
    repeat task.wait() api.walkTo(v.Position) until not v.Parent
    task.wait(.1)
    temptable.coconut = false
    table.remove(temptable.coconuts, table.find(temptable.coconuts, v))
end

function getfuzzy()
    pcall(function()
        for i,v in next, game.workspace.Particles:GetChildren() do
            if v.Name == "DustBunnyInstance" and temptable.running == false and tonumber((v.Plane.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
                if v:FindFirstChild("Plane") then
                    farm(v:FindFirstChild("Plane"))
                    break
                end
            end
        end
    end)
end

function getflame()
    for i,v in next, game:GetService("Workspace").PlayerFlames:GetChildren() do
        if tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

function avoidmob()
    for i,v in next, game:GetService("Workspace").Monsters:GetChildren() do
        if v:FindFirstChild("Head") then
            if (v.Head.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 30 and api.humanoid():GetState() ~= Enum.HumanoidStateType.Freefall then
                game.Players.LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end
end

function getcrosshairs(v)
    if v.BrickColor ~= BrickColor.new("Lime green") and v.BrickColor ~= BrickColor.new("Flint") then
        if temptable.crosshair then repeat task.wait() until not temptable.crosshair end
        temptable.crosshair = true
        api.walkTo(v.Position)
        repeat task.wait() api.walkTo(v.Position) until not v.Parent or v.BrickColor == BrickColor.new("Forest green")
        task.wait(.1)
        temptable.crosshair = false
        table.remove(temptable.crosshairs, table.find(temptable.crosshairs, v))
    else
        table.remove(temptable.crosshairs, table.find(temptable.crosshairs, v))
    end
end

function makequests()
    for i,v in next, game:GetService("Workspace").NPCs:GetChildren() do
        if v.Name ~= "Ant Challenge Info" and v.Name ~= "Bubble Bee Man 2" and v.Name ~= "Wind Shrine" and v.Name ~= "Gummy Bear" then if v:FindFirstChild("Platform") then if v.Platform:FindFirstChild("AlertPos") then if v.Platform.AlertPos:FindFirstChild("AlertGui") then if v.Platform.AlertPos.AlertGui:FindFirstChild("ImageLabel") then
            image = v.Platform.AlertPos.AlertGui.ImageLabel
            button = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.ActivateButton.MouseButton1Click
            if image.ImageTransparency == 0 then
                if DumbWRLD.toggles.tptonpc then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z)
                    task.wait(1)
                else
                    api.tween(2,CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z))
                    task.wait(3)
                end
                for b,z in next, getconnections(button) do    z.Function()    end
                task.wait(8)
                if image.ImageTransparency == 0 then
                    for b,z in next, getconnections(button) do    z.Function()    end
                end
                task.wait(2)
            end
        end
        end end end end end
end

local Config = { WindowName = "🌘  DumbWRLD v"..temptable.version, Color = Color3.fromRGB(164, 84, 255)}
print("Loading " ..Config.WindowName.. "...")
local Window = library:CreateWindow(Config, game:GetService("CoreGui"))

local hometab = Window:CreateTab("Home")
local farmtab = Window:CreateTab("Farming")
local combtab = Window:CreateTab("Combat")
local wayptab = Window:CreateTab("Waypoints")
local itemtab = Window:CreateTab("Items")
local misctab = Window:CreateTab("Misc")
local extrtab = Window:CreateTab("Extra")
local setttab = Window:CreateTab("Settings")

local information = hometab:CreateSection("Information")
information:CreateLabel("Thanks you for using our script, "..api.nickname)
information:CreateLabel("Script version: "..temptable.version)
information:CreateLabel("Place version: "..game.PlaceVersion)
information:CreateLabel("⚠️ - Not Safe Function")
information:CreateLabel("⚙ - Configurable Function")
information:CreateLabel("Place version: "..game.PlaceVersion)
information:CreateLabel("Script by weuz_ and mrdevl")
information:CreateLabel("Edited by Pastis444")
local gainedhoneylabel = information:CreateLabel("Gained Honey: 0")
local elapsetime = information:CreateLabel("Time Elapse: 00:00:00")
local windyfavor = information:CreateLabel("Windy Favor: 0")
local changelog = hometab:CreateSection("Changelog")
changelog:CreateLabel("v1.0.0 - Initial Release")
information:CreateButton("Discord Invite", function() setclipboard("https://discord.gg/fU3jdejJxK") end)


local farmo = farmtab:CreateSection("Farming")
local fielddropdown = farmo:CreateDropdown("Field", fieldstable, function(String) DumbWRLD.vars.field = String end) fielddropdown:SetOption(fieldstable[1])
convertatslider = farmo:CreateSlider("Convert At", 0, 100, 100, false, function(Value) DumbWRLD.vars.convertat = Value end)
farmo:CreateToggle("Don't Convert Pollen", nil, function(State) DumbWRLD.toggles.noconvertpollen = State end)
local autofarmtoggle = farmo:CreateToggle("Autofarm ⚙", nil, function(State) DumbWRLD.toggles.autofarm = State end) autofarmtoggle:CreateKeybind("U", function(Key) end)
--farmo:CreateToggle("Convert After x Pop Star ⚙", nil, function(State) DumbWRLD.toggles.popstarconvert = State end):AddToolTip("Default x=3; You can change it in the Settings Tab")
farmo:CreateToggle("Autodig", nil, function(State) DumbWRLD.toggles.autodig = State end)
farmo:CreateToggle("Auto Sprinkler", nil, function(State) DumbWRLD.toggles.autosprinkler = State end)
farmo:CreateToggle("Farm Bubbles", nil, function(State) DumbWRLD.toggles.farmbubbles = State end)
farmo:CreateToggle("Farm Flames", nil, function(State) DumbWRLD.toggles.farmflame = State end)
farmo:CreateToggle("Farm Coconuts & Shower", nil, function(State) DumbWRLD.toggles.farmcoco = State end)
farmo:CreateToggle("Farm Precise Crosshairs", nil, function(State) DumbWRLD.toggles.collectcrosshairs = State end)
farmo:CreateToggle("Farm Fuzzy Bombs", nil, function(State) DumbWRLD.toggles.farmfuzzy = State end)
farmo:CreateToggle("Farm Under Balloons", nil, function(State) DumbWRLD.toggles.farmunderballoons = State end)
farmo:CreateToggle("Farm Under Clouds", nil, function(State) DumbWRLD.toggles.farmclouds = State end)
--farmo:CreateToggle("Farm Closest Leaves", nil, function(State) DumbWRLD.toggles.farmclosestleaf = State end)

local farmt = farmtab:CreateSection("Farming")
farmt:CreateToggle("Auto Dispenser ⚙", nil, function(State) DumbWRLD.toggles.autodispense = State end)
farmt:CreateToggle("Auto Field Boosters ⚙", nil, function(State) DumbWRLD.toggles.autoboosters = State end)
farmt:CreateToggle("Auto Wealth Clock", nil, function(State) DumbWRLD.toggles.clock = State end)
farmt:CreateToggle("Auto Gingerbread Bears", nil, function(State) DumbWRLD.toggles.collectgingerbreads = State end)
farmt:CreateToggle("Auto Samovar", nil, function(State) DumbWRLD.toggles.autosamovar = State end)
farmt:CreateToggle("Auto Stockings", nil, function(State) DumbWRLD.toggles.autostockings = State end)
farmt:CreateToggle("Auto Planters", nil, function(State) DumbWRLD.toggles.autoplanters = State end):AddToolTip("Will re-plant your planters after converting, if they hit x%")
farmt:CreateToggle("Auto Honey Candles", nil, function(State) DumbWRLD.toggles.autocandles = State end)
farmt:CreateToggle("Auto Beesmas Feast", nil, function(State) DumbWRLD.toggles.autofeast = State end)
farmt:CreateToggle("Auto Honey Wreath", nil, function(State) DumbWRLD.toggles.autohoneywreath = State end):AddToolTip("Will go to Honey Wreath when you have a full bag")
farmt:CreateToggle("Auto Onett's Lid Art", nil, function(State) DumbWRLD.toggles.autoonettart = State end)
farmt:CreateToggle("Auto Free Antpasses", nil, function(State) DumbWRLD.toggles.freeantpass = State end)
farmt:CreateToggle("Farm Sprouts", nil, function(State) DumbWRLD.toggles.farmsprouts = State end)
farmt:CreateToggle("Farm Puffshrooms", nil, function(State) DumbWRLD.toggles.farmpuffshrooms = State end)
farmt:CreateToggle("Farm Snowflakes ⚠️", nil, function(State) DumbWRLD.toggles.farmsnowflakes = State end)
farmt:CreateToggle("Teleport To Rares ⚠️", nil, function(State) DumbWRLD.toggles.farmrares = State end)
farmt:CreateToggle("Auto Accept/Confirm Quests ⚙", nil, function(State) DumbWRLD.toggles.autoquest = State end)
farmt:CreateToggle("Auto Do Quests ⚙", nil, function(State) DumbWRLD.toggles.autodoquest = State end)
farmt:CreateToggle("Auto Honeystorm", nil, function(State) DumbWRLD.toggles.honeystorm = State end)


local mobkill = combtab:CreateSection("Combat")
mobkill:CreateToggle("Train Crab", nil, function(State) if State then api.humanoidrootpart().CFrame = CFrame.new(-307.52117919922, 107.91863250732, 467.86791992188) end end)
mobkill:CreateToggle("Train Snail", nil, function(State) fd = game.Workspace.FlowerZones['Stump Field'] if State then api.humanoidrootpart().CFrame = CFrame.new(fd.Position.X, fd.Position.Y-6, fd.Position.Z) else api.humanoidrootpart().CFrame = CFrame.new(fd.Position.X, fd.Position.Y+2, fd.Position.Z) end end)
mobkill:CreateToggle("Kill Mondo", nil, function(State) DumbWRLD.toggles.killmondo = State end)
mobkill:CreateToggle("Kill Vicious", nil, function(State) DumbWRLD.toggles.killvicious = State end)
mobkill:CreateToggle("Kill Windy", nil, function(State) DumbWRLD.toggles.killwindy = State end)
mobkill:CreateToggle("Auto Kill Mobs", nil, function(State) DumbWRLD.toggles.autokillmobs = State end):AddToolTip("Kills mobs after x pollen converting")
mobkill:CreateToggle("Avoid Mobs", nil, function(State) DumbWRLD.toggles.avoidmobs = State end)
mobkill:CreateToggle("Auto Ant", nil, function(State) DumbWRLD.toggles.autoant = State end):AddToolTip("You Need Spark Stuff 😋; Goes to Ant Challenge after pollen converting")
mobkill:CreateToggle("Auto Ant On Quest", nil, function(State) DumbWRLD.toggles.autoantonquest = State end):AddToolTip("You Need Spark Stuff 😋; Goes to Ant Challenge after pollen converting")
mobkill:CreateToggle("Auto Demon Mask", nil, function(State) DumbWRLD.toggles.demonmask = State end):AddToolTip("You Need Demon Mask 😈; Equip Demon Mask to Kill Mob")


local amks = combtab:CreateSection("Auto Kill Mobs Settings")
amks:CreateTextBox('Kill Mobs After x Convertions', 'default = 3', true, function(Value) DumbWRLD.vars.monstertimer = tonumber(Value) end)


local wayp = wayptab:CreateSection("Waypoints")
wayp:CreateDropdown("Field Teleports", fieldstable, function(Option) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").FlowerZones:FindFirstChild(Option).CFrame end)
wayp:CreateDropdown("Monster Teleports", spawnerstable, function(Option) d = game:GetService("Workspace").MonsterSpawners:FindFirstChild(Option) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(d.Position.X, d.Position.Y+3, d.Position.Z) end)
wayp:CreateDropdown("Toys Teleports", toystable, function(Option) d = game:GetService("Workspace").Toys:FindFirstChild(Option).Platform game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(d.Position.X, d.Position.Y+3, d.Position.Z) end)
wayp:CreateButton("Teleport to hive", function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.SpawnPos.Value end)

local useitems = itemtab:CreateSection("Use Items")
useitems:CreateButton("Use All Buffs ⚠️",function() for i,v in pairs(buffTable) do  game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=v}) end end)
useitems:CreateLabel("")
for i,v in pairs(buffTable) do useitems:CreateButton("Use "..v,function() game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"]=v}) end) end

local itemt = itemtab:CreateSection("Auto Use Items")
itemt:CreateToggle("Use Blue Extract", nil, function(State) DumbWRLD.toggles.blueextract = State end)
itemt:CreateToggle("Use Red Extract", nil, function(State) DumbWRLD.toggles.redextract = State end)
itemt:CreateToggle("Use Oil", nil, function(State) DumbWRLD.toggles.oil = State end)
itemt:CreateToggle("Use Enzyme", nil, function(State) DumbWRLD.toggles.enzyme = State end)
itemt:CreateToggle("Use Glue", nil, function(State) DumbWRLD.toggles.glue = State end)
itemt:CreateToggle("Use Glitter", nil, function(State) DumbWRLD.toggles.glitter = State end)
itemt:CreateToggle("Use Field Dice", nil, function(State) DumbWRLD.toggles.fielddice = State end):AddToolTip("WARNING : Can use a LOT of Field Dice (because it's RNG)")
local glitterdropdown = itemt:CreateDropdown("Field for Glitter and Filed Dice", fieldstable, function(String) extrasvars.field = String end) glitterdropdown:SetOption(fieldstable[2])
itemt:CreateToggle("Use Tropical Drink", nil, function(State) DumbWRLD.toggles.tropicaldrink = State end)
itemt:CreateToggle("Use Snowflake", nil, function(State) DumbWRLD.toggles.snowflake = State end)
itemt:CreateToggle("Use Purple Potion", nil, function(State) DumbWRLD.toggles.purplepot = State end)
itemt:CreateToggle("Use Jelly Beans", nil, function(State) DumbWRLD.toggles.jellybean = State end)


local miscc = misctab:CreateSection("Misc")
miscc:CreateButton("Ant Challenge Semi-Godmode", function() api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) task.wait(1) game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge") game.Players.LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(93.4228, 42.3983, 553.128) task.wait(2) game.Players.LocalPlayer.Character.Humanoid.Name = 1 local l = game.Players.LocalPlayer.Character["1"]:Clone() l.Parent = game.Players.LocalPlayer.Character l.Name = "Humanoid" task.wait() game.Players.LocalPlayer.Character["1"]:Destroy() api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) task.wait(8) api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) end)
local wstoggle = miscc:CreateToggle("Walk Speed", nil, function(State) DumbWRLD.toggles.loopspeed = State end) wstoggle:CreateKeybind("K", function(Key) end)
local jptoggle = miscc:CreateToggle("Jump Power", nil, function(State) DumbWRLD.toggles.loopjump = State end) jptoggle:CreateKeybind("L", function(Key) end)
miscc:CreateToggle("Godmode", nil, function(State) DumbWRLD.toggles.godmode = State if State then bssapi:Godmode(true) else bssapi:Godmode(false) end end)
local misco = misctab:CreateSection("Other")
misco:CreateDropdown("Equip Accesories", accesoriestable, function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end)
misco:CreateDropdown("Equip Masks", masktable, function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end)
misco:CreateDropdown("Equip Collectors", collectorstable, function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Collector" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end)
misco:CreateDropdown("Generate Amulet", {"Supreme Star Amulet", "Diamond Star Amulet", "Gold Star Amulet","Silver Star Amulet","Bronze Star Amulet","Moon Amulet"}, function(Option) local A_1 = Option.." Generator" local Event = game:GetService("ReplicatedStorage").Events.ToyEvent Event:FireServer(A_1) end)
misco:CreateButton("Export Stats Table", function() local StatCache = require(game.ReplicatedStorage.ClientStatCache)writefile("Stats_"..api.nickname..".json", StatCache:Encode()) end)
local miscd = misctab:CreateSection("Auto Donate")
miscd:CreateToggle("Auto Cloud Vial", nil, function(State) DumbWRLD.toggles.autocloudvial = State end)


local extras = extrtab:CreateSection("Extras")
extras:CreateButton("Hide nickname", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/not-weuz/Lua/main/nicknamespoofer.lua"))()end)
extras:CreateButton("Boost FPS", function()loadstring(game:HttpGet("https://raw.githubusercontent.com/not-weuz/Lua/main/fpsboost.lua"))()end)
extras:CreateButton("Destroy Decals", function()loadstring(game:HttpGet("https://raw.githubusercontent.com/not-weuz/Lua/main/destroydecals.lua"))()end)
extras:CreateTextBox("Glider Speed", "", true, function(Value) local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() stats.EquippedParachute = "Glider" local module = require(game:GetService("ReplicatedStorage").Parachutes) local st = module.GetStat local glidersTable = getupvalues(st) glidersTable[1]["Glider"].Speed = Value setupvalue(st, st[1]'Glider', glidersTable) end)
extras:CreateTextBox("Glider Float", "", true, function(Value) local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() stats.EquippedParachute = "Glider" local module = require(game:GetService("ReplicatedStorage").Parachutes) local st = module.GetStat local glidersTable = getupvalues(st) glidersTable[1]["Glider"].Float = Value setupvalue(st, st[1]'Glider', glidersTable) end)
extras:CreateButton("Invisibility", function(State) api.teleport(CFrame.new(0,0,0)) wait(1) if game.Players.LocalPlayer.Character:FindFirstChild('LowerTorso') then Root = game.Players.LocalPlayer.Character.LowerTorso.Root:Clone() game.Players.LocalPlayer.Character.LowerTorso.Root:Destroy() Root.Parent = game.Players.LocalPlayer.Character.LowerTorso api.teleport(game:GetService("Players").LocalPlayer.SpawnPos.Value) end end)
extras:CreateToggle("Float", nil, function(State) temptable.float = State end)


local farmsettings = setttab:CreateSection("Autofarm Settings")
farmsettings:CreateTextBox("Autofarming Walkspeed", "Default Value = 60", true, function(Value) DumbWRLD.vars.farmspeed = Value end)
farmsettings:CreateToggle("^ Loop Speed On Autofarming",nil, function(State) DumbWRLD.toggles.loopfarmspeed = State end)
farmsettings:CreateToggle("Don't Walk In Field",nil, function(State) DumbWRLD.toggles.farmflower = State end)
farmsettings:CreateToggle("Convert Hive Balloon",nil, function(State) DumbWRLD.toggles.convertballoons = State end)
farmsettings:CreateToggle("Don't Farm Tokens",nil, function(State) DumbWRLD.toggles.donotfarmtokens = State end)
farmsettings:CreateToggle("Enable Token Blacklisting",nil, function(State) DumbWRLD.toggles.enabletokenblacklisting = State end)
--farmsettings:CreateTextBox('Convert Pollen After x Pop Star', 'default = 3', true, function(Value) extrasvars.popstartimer = tonumber(Value) end)
farmsettings:CreateSlider("Collect Planters At", 0, 100, 100, false, function(Value) DumbWRLD.planterat = Value end)
farmsettings:CreateSlider("Walk Speed", 0, 120, 70, false, function(Value) DumbWRLD.vars.walkspeed = Value end)
farmsettings:CreateSlider("Jump Power", 0, 120, 70, false, function(Value) DumbWRLD.vars.jumppower = Value end)
local raresettings = setttab:CreateSection("Tokens Settings")
raresettings:CreateTextBox("Asset ID", 'rbxassetid', false, function(Value) rarename = Value end)
raresettings:CreateButton("Add Token To Rares List", function()
    table.insert(DumbWRLD.rares, rarename)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Rares List D",true):Destroy()
    raresettings:CreateDropdown("Rares List", DumbWRLD.rares, function(Option) end)
end)
raresettings:CreateButton("Remove Token From Rares List", function()
    table.remove(DumbWRLD.rares, api.tablefind(DumbWRLD.rares, rarename))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Rares List D",true):Destroy()
    raresettings:CreateDropdown("Rares List", DumbWRLD.rares, function(Option) end)
end)
raresettings:CreateButton("Add Token To Blacklist", function()
    table.insert(DumbWRLD.bltokens, rarename)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Tokens Blacklist D",true):Destroy()
    raresettings:CreateDropdown("Tokens Blacklist", DumbWRLD.bltokens, function(Option) end)
end)
raresettings:CreateButton("Remove Token From Blacklist", function()
    table.remove(DumbWRLD.bltokens, api.tablefind(DumbWRLD.bltokens, rarename))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Tokens Blacklist D",true):Destroy()
    raresettings:CreateDropdown("Tokens Blacklist", DumbWRLD.bltokens, function(Option) end)
end)
raresettings:CreateDropdown("Tokens Blacklist", DumbWRLD.bltokens, function(Option) end)
raresettings:CreateDropdown("Rares List", DumbWRLD.rares, function(Option) end)
local dispsettings = setttab:CreateSection("Auto Dispenser & Auto Boosters Settings")
dispsettings:CreateToggle("Royal Jelly Dispenser", nil, function(State) DumbWRLD.dispensesettings.rj = not DumbWRLD.dispensesettings.rj end)
dispsettings:CreateToggle("Blueberry Dispenser", nil,  function(State) DumbWRLD.dispensesettings.blub = not DumbWRLD.dispensesettings.blub end)
dispsettings:CreateToggle("Strawberry Dispenser", nil,  function(State) DumbWRLD.dispensesettings.straw = not DumbWRLD.dispensesettings.straw end)
dispsettings:CreateToggle("Treat Dispenser", nil,  function(State) DumbWRLD.dispensesettings.treat = not DumbWRLD.dispensesettings.treat end)
dispsettings:CreateToggle("Coconut Dispenser", nil,  function(State) DumbWRLD.dispensesettings.coconut = not DumbWRLD.dispensesettings.coconut end)
dispsettings:CreateToggle("Glue Dispenser", nil,  function(State) DumbWRLD.dispensesettings.glue = not DumbWRLD.dispensesettings.glue end)
dispsettings:CreateToggle("Mountain Top Booster", nil,  function(State) DumbWRLD.dispensesettings.white = not DumbWRLD.dispensesettings.white end)
dispsettings:CreateToggle("Blue Field Booster", nil,  function(State) DumbWRLD.dispensesettings.blue = not DumbWRLD.dispensesettings.blue end)
dispsettings:CreateToggle("Red Field Booster", nil,  function(State) DumbWRLD.dispensesettings.red = not DumbWRLD.dispensesettings.red end)
local guisettings = setttab:CreateSection("GUI Settings")
local uitoggle = guisettings:CreateToggle("UI Toggle", nil, function(State) Window:Toggle(State) end) uitoggle:CreateKeybind(tostring(DumbWRLD.vars.Keybind):gsub("Enum.KeyCode.", ""), function(Key) DumbWRLD.vars.Keybind = Enum.KeyCode[Key] end) uitoggle:SetState(true)
guisettings:CreateColorpicker("UI Color", function(Color) Window:ChangeColor(Color) end)
local themes = guisettings:CreateDropdown("Image", {"Default","Hearts","Abstract","Hexagon","Circles","Lace With Flowers","Floral"}, function(Name) if Name == "Default" then Window:SetBackground("2151741365") elseif Name == "Hearts" then Window:SetBackground("6073763717") elseif Name == "Abstract" then Window:SetBackground("6073743871") elseif Name == "Hexagon" then Window:SetBackground("6073628839") elseif Name == "Circles" then Window:SetBackground("6071579801") elseif Name == "Lace With Flowers" then Window:SetBackground("6071575925") elseif Name == "Floral" then Window:SetBackground("5553946656") end end)themes:SetOption("Default")
function killscript()
    -- set all vars to false and kill the gui
    -- this is so the script can be reloaded without having to restart the game
    for i,v in pairs(DumbWRLD.toggles) do
        -- checking if the var is a bool (they all should be, but just in case)
        if type(DumbWRLD.toggles[i]) == "boolean" then
            DumbWRLD.toggles[i] = false
        end
    end
    -- setting the DumbWRLDState to false
    _G.DumbWRLDState = false
    -- killing the gui
    game:GetService("CoreGui"):FindFirstChild(_G.windowname):Destroy()
end
guisettings:CreateButton("Kill GUI", function() killscript() end)
local DumbWRLDs = setttab:CreateSection("Configs")
DumbWRLDs:CreateTextBox("Config Name", 'ex: stumpconfig', false, function(Value) temptable.configname = Value end)
DumbWRLDs:CreateButton("Load Config", function() DumbWRLD = game:service'HttpService':JSONDecode(readfile("DumbWRLD/BSS_"..temptable.configname..".json")) end)
DumbWRLDs:CreateButton("Save Config", function() writefile("DumbWRLD/BSS_"..temptable.configname..".json",game:service'HttpService':JSONEncode(DumbWRLD)) end)
DumbWRLDs:CreateButton("Reset Config", function() DumbWRLD = defaultDumbWRLD end)
local fieldsettings = setttab:CreateSection("Fields Settings")
fieldsettings:CreateDropdown("Best White Field", temptable.whitefields, function(Option) DumbWRLD.bestfields.white = Option end)
fieldsettings:CreateDropdown("Best Red Field", temptable.redfields, function(Option) DumbWRLD.bestfields.red = Option end)
fieldsettings:CreateDropdown("Best Blue Field", temptable.bluefields, function(Option) DumbWRLD.bestfields.blue = Option end)
fieldsettings:CreateDropdown("Field", fieldstable, function(Option) temptable.blackfield = Option end)
fieldsettings:CreateButton("Add Field To Blacklist", function() table.insert(DumbWRLD.blacklistedfields, temptable.blackfield) game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Blacklisted Fields D",true):Destroy() fieldsettings:CreateDropdown("Blacklisted Fields", DumbWRLD.blacklistedfields, function(Option) end) end)
fieldsettings:CreateButton("Remove Field From Blacklist", function() table.remove(DumbWRLD.blacklistedfields, api.tablefind(DumbWRLD.blacklistedfields, temptable.blackfield)) game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Blacklisted Fields D",true):Destroy() fieldsettings:CreateDropdown("Blacklisted Fields", DumbWRLD.blacklistedfields, function(Option) end) end)
fieldsettings:CreateDropdown("Blacklisted Fields", DumbWRLD.blacklistedfields, function(Option) end)
local aqs = setttab:CreateSection("Auto Quest Settings")
aqs:CreateDropdown("Do NPC Quests", {'All Quests', 'Bucko Bee', 'Brown Bear', 'Riley Bee', 'Polar Bear', 'Bee Bear (X-Mas Bear)'}, function(Option) if Option == 'Bee Bear (X-Mas Bear)' then DumbWRLD.vars.npcprefer = 'Snow Cub Reformation' else DumbWRLD.vars.npcprefer = Option end end)
aqs:CreateToggle("Teleport To NPC", nil, function(State) DumbWRLD.toggles.tptonpc = State end)
local pts = setttab:CreateSection("Autofarm Priority Tokens")
pts:CreateTextBox("Asset ID", 'rbxassetid', false, function(Value) rarename = Value end)
pts:CreateButton("Add Token To Priority List", function() table.insert(DumbWRLD.priority, rarename) game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Priority List D",true):Destroy() pts:CreateDropdown("Priority List", DumbWRLD.priority, function(Option) end) end)
pts:CreateButton("Remove Token From Priority List", function() table.remove(DumbWRLD.priority, api.tablefind(DumbWRLD.priority, rarename)) game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Priority List D",true):Destroy() pts:CreateDropdown("Priority List", DumbWRLD.priority, function(Option) end) end)
pts:CreateDropdown("Priority List", DumbWRLD.priority, function(Option) end)

-- script

task.spawn(function() while task.wait() do
    if DumbWRLD.toggles.autofarm then
        --if DumbWRLD.toggles.farmcoco then getcoco() end
        --if DumbWRLD.toggles.collectcrosshairs then getcrosshairs() end
        if DumbWRLD.toggles.farmflame then getflame() end
        if DumbWRLD.toggles.farmfuzzy then getfuzzy() end
    end
end end)

game.Workspace.Particles.ChildAdded:Connect(function(v)
    if not temptable.started.vicious and not temptable.started.ant then
        if v.Name == "WarningDisk" and not temptable.started.vicious and DumbWRLD.toggles.autofarm and not temptable.started.ant and DumbWRLD.toggles.farmcoco and (v.Position-api.humanoidrootpart().Position).magnitude < temptable.magnitude and not temptable.converting then
            table.insert(temptable.coconuts, v)
            getcoco(v)
            gettoken()
        elseif v.Name == "Crosshair" and v ~= nil and v.BrickColor ~= BrickColor.new("Forest green") and not temptable.started.ant and v.BrickColor ~= BrickColor.new("Flint") and (v.Position-api.humanoidrootpart().Position).magnitude < temptable.magnitude and DumbWRLD.toggles.autofarm and DumbWRLD.toggles.collectcrosshairs and not temptable.converting then
            if #temptable.crosshairs <= 3 then
                table.insert(temptable.crosshairs, v)
                getcrosshairs(v)
                gettoken()
            end
        end
    end
end)

task.spawn(function() while task.wait() do
    if DumbWRLD.toggles.autofarm then
        if DumbWRLD.toggles.autoquest then
            makequests()
            wait(0.1)
        end
        temptable.magnitude = 70
        if game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true) then
            local pollenprglbl = game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true)
            maxpollen = tonumber(pollenprglbl.Text:match("%d+$"))
            local pollencount = game.Players.LocalPlayer.CoreStats.Pollen.Value
            pollenpercentage = pollencount/maxpollen*100
            fieldselected = game:GetService("Workspace").FlowerZones[DumbWRLD.vars.field]
            if DumbWRLD.toggles.autodoquest and game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests.Content:FindFirstChild("Frame") then
                for i,v in next, game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests:GetDescendants() do
                    if v.Name == "Description" then
                        if string.match(v.Parent.Parent.TitleBar.Text, DumbWRLD.vars.npcprefer) or DumbWRLD.vars.npcprefer == "All Quests" and not string.find(v.Text, "Puffshroom") and not string.find(v.Text, "Planters") then
                            pollentypes = {'White Pollen', "Red Pollen", "Blue Pollen", "Blue Flowers", "Red Flowers", "White Flowers"}
                            text = v.Text
                            if api.returnvalue(fieldstable, text) and not string.find(v.Text, "Complete!") and not api.findvalue(DumbWRLD.blacklistedfields, api.returnvalue(fieldstable, text)) then
                                d = api.returnvalue(fieldstable, text)
                                fieldselected = game:GetService("Workspace").FlowerZones[d]
                                break
                            elseif api.returnvalue(pollentypes, text) and not string.find(v.Text, 'Complete!') then
                                d = api.returnvalue(pollentypes, text)
                                if d == "Blue Flowers" or d == "Blue Pollen" then
                                    fieldselected = game:GetService("Workspace").FlowerZones[DumbWRLD.bestfields.blue]
                                    break
                                elseif d == "White Flowers" or d == "White Pollen" then
                                    fieldselected = game:GetService("Workspace").FlowerZones[DumbWRLD.bestfields.white]
                                    break
                                elseif d == "Red Flowers" or d == "Red Pollen" then
                                    fieldselected = game:GetService("Workspace").FlowerZones[DumbWRLD.bestfields.red]
                                    break
                                end
                            elseif DumbWRLD.toggles.autoantonquest and string.find(v.Text, "Ants.") and not string.find(v.Text, "Complete!") then
                                if not game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value and rtsg().Eggs.AntPass > 0 then
                                    farmant()
                                    break
                                end
                            end
                        end
                    end
                end
            else
                fieldselected = game:GetService("Workspace").FlowerZones[DumbWRLD.vars.field]
            end
            fieldpos = CFrame.new(fieldselected.Position.X, fieldselected.Position.Y+3, fieldselected.Position.Z)
            fieldposition = fieldselected.Position
            if temptable.sprouts.detected and temptable.sprouts.coords and DumbWRLD.toggles.farmsprouts then
                fieldposition = temptable.sprouts.coords.Position
                fieldpos = temptable.sprouts.coords
            end
            if DumbWRLD.toggles.farmpuffshrooms and game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model") then
                if api.partwithnamepart("Mythic", game.Workspace.Happenings.Puffshrooms) then
                    temptable.magnitude = 25
                    fieldpos = api.partwithnamepart("Mythic", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                    fieldposition = fieldpos.Position
                elseif api.partwithnamepart("Legendary", game.Workspace.Happenings.Puffshrooms) then
                    temptable.magnitude = 25
                    fieldpos = api.partwithnamepart("Legendary", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                    fieldposition = fieldpos.Position
                elseif api.partwithnamepart("Epic", game.Workspace.Happenings.Puffshrooms) then
                    temptable.magnitude = 25
                    fieldpos = api.partwithnamepart("Epic", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                    fieldposition = fieldpos.Position
                elseif api.partwithnamepart("Rare", game.Workspace.Happenings.Puffshrooms) then
                    temptable.magnitude = 25
                    fieldpos = api.partwithnamepart("Rare", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                    fieldposition = fieldpos.Position
                else
                    temptable.magnitude = 25
                    fieldpos = api.getbiggestmodel(game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                    fieldposition = fieldpos.Position
                end
            end
            if tonumber(pollenpercentage) < tonumber(DumbWRLD.vars.convertat) or DumbWRLD.toggles.noconvertpollen then
                if not temptable.tokensfarm then
                    api.tween(2, fieldpos)
                    task.wait(2)
                    temptable.tokensfarm = true
                    if DumbWRLD.toggles.autosprinkler then makesprinklers() end
                else
                    if DumbWRLD.toggles.killmondo then
                        while DumbWRLD.toggles.killmondo and game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") and not temptable.started.vicious and not temptable.started.monsters do
                            temptable.started.mondo = true
                            if extrasvars.demoncounter == 0 then
                                temptable.oldequippedmask = rtsg()["EquippedAccessories"]["Hat"]
                            end
                            if DumbWRLD.toggles.demonmask then
                                extrasvars.demoncounter = extrasvars.demoncounter + 1
                                maskequip('Demon Mask')
                            end
                            while game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") do
                                disableall()
                                game:GetService("Workspace").Map.Ground.HighBlock.CanCollide = false
                                mondopition = game.Workspace.Monsters["Mondo Chick (Lvl 8)"].Head.Position
                                api.tween(1, CFrame.new(mondopition.x, mondopition.y - 40, mondopition.z))
                                task.wait(1)
                                temptable.float = true
                            end
                            task.wait(.5) game:GetService("Workspace").Map.Ground.HighBlock.CanCollide = true temptable.float = false api.tween(.5, CFrame.new(73.2, 176.35, -167)) task.wait(1)
                            for i = 0, 50 do
                                gettoken(CFrame.new(73.2, 176.35, -167).Position)
                            end
                            enableall()
                            api.tween(2, fieldpos)
                            if DumbWRLD.toggles.demonmask then
                                extrasvars.demoncounter = extrasvars.demoncounter - 1
                            end
                            if extrasvars.demoncounter == 0 then
                                maskequip(temptable.oldequippedmask)
                            end
                            temptable.started.mondo = false
                        end
                    end
                    if (fieldposition-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > temptable.magnitude then
                        api.tween(2, fieldpos)
                        task.wait(2)
                        if DumbWRLD.toggles.autosprinkler then makesprinklers() end
                    end
                    getprioritytokens()
                    if DumbWRLD.toggles.avoidmobs then avoidmob() end
                    if DumbWRLD.toggles.farmclosestleaf then closestleaf() end
                    if DumbWRLD.toggles.farmbubbles then getbubble() end
                    if DumbWRLD.toggles.farmclouds then getcloud() end
                    if DumbWRLD.toggles.farmunderballoons then getballoons() end
                    if not DumbWRLD.toggles.donotfarmtokens and done then gettoken() end
                    if not DumbWRLD.toggles.farmflower then getflower() end
                    if DumbWRLD.toggles.popstarconvert then popstarcounter() end
                end
            elseif tonumber(pollenpercentage) >= tonumber(DumbWRLD.vars.convertat) and not DumbWRLD.toggles.convertion and not DumbWRLD.toggles.noconvertpollen then
                if DumbWRLD.toggles.autohoneywreath then
                    wait(2)
                end
                if extrasvars.demoncounter == 0 then
                    temptable.oldequippedmask = rtsg()["EquippedAccessories"]["Hat"]
                end
                extrasvars.demoncounter = extrasvars.demoncounter + 1
                maskequip('Honey Mask')
                temptable.tokensfarm = false
                api.tween(2, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 9))
                task.wait(2)
                temptable.converting = true
                repeat
                    converthoney()
                until game.Players.LocalPlayer.CoreStats.Pollen.Value == 0 or DumbWRLD.toggles.noconvertpollen
                if DumbWRLD.toggles.convertballoons and gethiveballoon() then
                    task.wait(6)
                    repeat
                        task.wait()
                        converthoney()
                    until gethiveballoon() == false or not DumbWRLD.toggles.convertballoons or DumbWRLD.toggles.noconvertpollen
                end
                temptable.converting = false
                temptable.act = temptable.act + 1
                if DumbWRLD.toggles.demonmask then
                    extrasvars.demoncounter = extrasvars.demoncounter - 1
                end
                maskequip(temptable.oldequippedmask)
                temptable.popstar = 0
                extrasvars.popstarmustconvert = false
                task.wait(6)
                if DumbWRLD.toggles.autoant and not game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value and rtsg().Eggs.AntPass > 0 then
                    if temptable.act >= DumbWRLD.vars.monstertimer then farmant() end
                end
                if DumbWRLD.toggles.autoquest then makequests() end
                if DumbWRLD.toggles.autoplanters then collectplanters() end
                if DumbWRLD.toggles.autokillmobs then
                    if temptable.act >= DumbWRLD.vars.monstertimer then
                        temptable.started.monsters = true
                        temptable.act = 0
                        killmobs()
                        temptable.started.monsters = false
                    end
                end
            elseif extrasvars.popstarmustconvert then
                print('Converting :', extrasvars.popstarmustconvert)
                temptable.tokensfarm = false
                api.tween(2, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 9))
                task.wait(2)
                temptable.converting = true
                repeat
                    converthoney()
                until game.Players.LocalPlayer.CoreStats.Pollen.Value == 0 or DumbWRLD.toggles.noconvertpollen
                if DumbWRLD.toggles.convertballoons and gethiveballoon() then
                    task.wait(6)
                    repeat
                        task.wait()
                        converthoney()
                    until gethiveballoon() == false or not DumbWRLD.toggles.convertballoons or DumbWRLD.toggles.noconvertpollen
                end
                temptable.converting = false
                temptable.act = temptable.act + 1
                temptable.popstar = 0
                extrasvars.popstarmustconvert = false
                task.wait(6)
                if DumbWRLD.toggles.autoant and not game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value and rtsg().Eggs.AntPass > 0 then
                    if temptable.act >= DumbWRLD.vars.monstertimer then farmant() end
                end
                if DumbWRLD.toggles.autoquest then makequests() end
                if DumbWRLD.toggles.autoplanters then collectplanters() end
                if DumbWRLD.toggles.autokillmobs then
                    if temptable.act >= DumbWRLD.vars.monstertimer then
                        temptable.started.monsters = true
                        temptable.act = 0
                        killmobs()
                        temptable.started.monsters = false
                    end
                end
            end
        end
    end end end)

task.spawn(function()
    while task.wait(1) do
        if DumbWRLD.toggles.killvicious and temptable.detected.vicious and temptable.converting == false and not temptable.started.monsters then
            temptable.started.vicious = true
            disableall()
            local vichumanoid = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
            for i,v in next, game.workspace.Particles:GetChildren() do
                for x in string.gmatch(v.Name, "Vicious") do
                    if string.find(v.Name, "Vicious") then
                        api.tween(1,CFrame.new(v.Position.x, v.Position.y, v.Position.z)) task.wait(1)
                        api.tween(0.5, CFrame.new(v.Position.x, v.Position.y, v.Position.z)) task.wait(.5)
                    end
                end
            end
            for i,v in next, game.workspace.Particles:GetChildren() do
                for x in string.gmatch(v.Name, "Vicious") do
                    while DumbWRLD.toggles.killvicious and temptable.detected.vicious do task.wait() if string.find(v.Name, "Vicious") then
                        for i=1, 4 do temptable.float = true vichumanoid.CFrame = CFrame.new(v.Position.x+10, v.Position.y, v.Position.z) task.wait(.3)
                        end
                    end end
                end
            end
            enableall()
            task.wait(1)
            temptable.float = false
            temptable.started.vicious = false
        end
    end
end)

task.spawn(function() while task.wait() do
    if DumbWRLD.toggles.killwindy and temptable.detected.windy and not temptable.converting and not temptable.started.vicious and not temptable.started.mondo and not temptable.started.monsters then
        temptable.started.windy = true
        if extrasvars.demoncounter == 0 then
            temptable.oldequippedmask = rtsg()["EquippedAccessories"]["Hat"]
        end
        if DumbWRLD.toggles.demonmask then
            extrasvars.demoncounter = extrasvars.demoncounter + 1
            maskequip('Demon Mask')
        end
        wlvl = "" aw = false awb = false -- some variable for autowindy, yk?
        disableall()
        while DumbWRLD.toggles.killwindy and temptable.detected.windy do
            if not aw then
                for i,v in pairs(workspace.Monsters:GetChildren()) do
                    if string.find(v.Name, "Windy") then wlvl = v.Name aw = true -- we found windy!
                    end
                end
            end
            if aw then
                for i,v in pairs(workspace.Monsters:GetChildren()) do
                    if string.find(v.Name, "Windy") then
                        if v.Name ~= wlvl then
                            temptable.float = false task.wait(5) for i =1, 5 do gettoken(api.humanoidrootpart().Position) end -- collect tokens :yessir:
                            wlvl = v.Name
                        end
                    end
                end
            end
            if not awb then api.tween(1,temptable.gacf(temptable.windy, 5)) task.wait(1) awb = true end
            if awb and temptable.windy.Name == "Windy" then
                api.humanoidrootpart().CFrame = temptable.gacf(temptable.windy, 25) temptable.float = true task.wait()
            end
        end
        enableall()
        temptable.float = false
        if DumbWRLD.toggles.demonmask then
            extrasvars.demoncounter = extrasvars.demoncounter - 1
        end
        if extrasvars.demoncounter == 0 then
            maskequip(temptable.oldequippedmask)
        end
        temptable.started.windy = false
    end
end end)


task.spawn(function() while task.wait(0.5) do
    if DumbWRLD.toggles.blueextract then itemtimers('blueextract') end
    if DumbWRLD.toggles.redextract then itemtimers('redextract') end
    if DumbWRLD.toggles.oil then itemtimers('oil') end
    if DumbWRLD.toggles.enzyme then itemtimers('enzyme') end
    if DumbWRLD.toggles.glue then itemtimers('glue') end
    if DumbWRLD.toggles.tropicaldrink then itemtimers('tropicaldrink') end
    if DumbWRLD.toggles.snowflake then itemtimers('snowflake') end
    if DumbWRLD.toggles.glitter then itemtimers('glitter') end
    if DumbWRLD.toggles.purplepot then itemtimers('purplepot') end
    if DumbWRLD.toggles.fielddice then itemtimers('fielddice') end
    if DumbWRLD.toggles.jellybean then itemtimers('jellybean') end
    if DumbWRLD.toggles.popstarconvert then popstarcounter() end
end end)

task.spawn(function() while task.wait(0.001) do
    if DumbWRLD.toggles.traincrab then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-259, 111.8, 496.4) * CFrame.fromEulerAnglesXYZ(0, 110, 90) temptable.float = true temptable.float = false end
    if DumbWRLD.toggles.farmrares then for k,v in next, game.workspace.Collectibles:GetChildren() do if v.CFrame.YVector.Y == 1 then if v.Transparency == 0 then decal = v:FindFirstChildOfClass("Decal") for e,r in next, DumbWRLD.rares do if decal.Texture == r or decal.Texture == "rbxassetid://"..r then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame break end end end end end end
    if DumbWRLD.toggles.autodig then if game.Players.LocalPlayer then if game.Players.LocalPlayer.Character then if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("ClickEvent", true) then clickevent = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("ClickEvent", true) or nil end end end if clickevent then clickevent:FireServer() end end workspace.NPCs.Onett.Onett["Porcelain Dipper"].ClickEvent:FireServer() end
end end)

game:GetService("Workspace").Particles.Folder2.ChildAdded:Connect(function(child)
    if child.Name == "Sprout" then
        temptable.sprouts.detected = true
        temptable.sprouts.coords = child.CFrame
    end
end)
game:GetService("Workspace").Particles.Folder2.ChildRemoved:Connect(function(child)
    if child.Name == "Sprout" then
        task.wait(30)
        temptable.sprouts.detected = false
        temptable.sprouts.coords = ""
    end
end)

Workspace.Particles.ChildAdded:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = true
    end
end)
Workspace.Particles.ChildRemoved:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = false
    end
end)
game:GetService("Workspace").NPCBees.ChildAdded:Connect(function(v)
    if v.Name == "Windy" then
        task.wait(3) temptable.windy = v temptable.detected.windy = true
    end
end)
game:GetService("Workspace").NPCBees.ChildRemoved:Connect(function(v)
    if v.Name == "Windy" then
        task.wait(3) temptable.windy = nil temptable.detected.windy = false
    end
end)

task.spawn(function() while task.wait(.1) do
    if not temptable.converting then
        if DumbWRLD.toggles.autosamovar then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Samovar")
            platformm = game:GetService("Workspace").Toys.Samovar.Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if DumbWRLD.toggles.autostockings then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Stockings")
            platformm = game:GetService("Workspace").Toys.Stockings.Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if DumbWRLD.toggles.autoonettart then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Onett's Lid Art")
            platformm = game:GetService("Workspace").Toys["Onett's Lid Art"].Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if DumbWRLD.toggles.autocandles then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Honeyday Candles")
            platformm = game:GetService("Workspace").Toys["Honeyday Candles"].Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if DumbWRLD.toggles.autofeast then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Beesmas Feast")
            platformm = game:GetService("Workspace").Toys["Beesmas Feast"].Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
    end
    if game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true) then
        local pollenprglbl = game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true)
        maxpollen = tonumber(pollenprglbl.Text:match("%d+$"))
        local pollencount = game.Players.LocalPlayer.CoreStats.Pollen.Value
        pollenpercentage = pollencount/maxpollen*100
        if tonumber(pollenpercentage) >= tonumber(DumbWRLD.vars.convertat) and not DumbWRLD.toggles.noconvertpollen then
            if DumbWRLD.toggles.autohoneywreath then
                temptable.collecthoneytoken = true
                wait(10)
                temptable.collecthoneytoken = false
            end
        end
    end
end end)

task.spawn(function() while task.wait(.1) do
    if temptable.collecthoneytoken then
        game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Honey Wreath")
        platformm = game:GetService("Workspace").Toys["Honey Wreath"].Platform
        for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
            if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                api.humanoidrootpart().CFrame = v.CFrame
            end
        end
    end
end end)

task.spawn(function() while task.wait(1) do
    temptable.runningfor = temptable.runningfor + 1
    temptable.honeycurrent = statsget().Totals.Honey
    if DumbWRLD.toggles.honeystorm then game.ReplicatedStorage.Events.ToyEvent:FireServer("Honeystorm") end
    if DumbWRLD.toggles.collectgingerbreads then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Gingerbread House") end
    if DumbWRLD.toggles.autodispense then
        if DumbWRLD.dispensesettings.rj then local A_1 = "Free Royal Jelly Dispenser" local Event = game:GetService("ReplicatedStorage").Events.ToyEvent Event:FireServer(A_1) end
        if DumbWRLD.dispensesettings.blub then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Blueberry Dispenser") end
        if DumbWRLD.dispensesettings.straw then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Strawberry Dispenser") end
        if DumbWRLD.dispensesettings.treat then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Treat Dispenser") end
        if DumbWRLD.dispensesettings.coconut then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Coconut Dispenser") end
        if DumbWRLD.dispensesettings.glue then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Glue Dispenser") end
    end
    if DumbWRLD.toggles.autoboosters then
        if DumbWRLD.dispensesettings.white then game.ReplicatedStorage.Events.ToyEvent:FireServer("Field Booster") end
        if DumbWRLD.dispensesettings.red then game.ReplicatedStorage.Events.ToyEvent:FireServer("Red Field Booster") end
        if DumbWRLD.dispensesettings.blue then game.ReplicatedStorage.Events.ToyEvent:FireServer("Blue Field Booster") end
    end
    if DumbWRLD.toggles.clock then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Wealth Clock") end
    if DumbWRLD.toggles.freeantpass then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Free Ant Pass Dispenser") end
    gainedhoneylabel:UpdateText("Gained Honey: "..api.suffixstring(temptable.honeycurrent - temptable.honeystart))
    elapsetime:UpdateText("Time Elapse: "..os.date('!%X', os.time() - temptable.starttime))
    windyfavor:UpdateText("Windy Favor: "..rtsg()['WindShrine']['WindyFavor'])

    if DumbWRLD.toggles.autocloudvial then
        local stats = game:GetService("ReplicatedStorage").Events.RetrievePlayerStats:InvokeServer()
        local lastWindy = stats.SystemTimes.WindShrine
        if os.time(os.date("!*t")) - lastWindy > 3600 then
            local vials = stats.Eggs.CloudVial
            game:GetService("ReplicatedStorage").Events.WindShrineDonation:InvokeServer("CloudVial", vials)
        end
    end
end end)

game:GetService('RunService').Heartbeat:connect(function()
    if DumbWRLD.toggles.autoquest then firesignal(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.ButtonOverlay.MouseButton1Click) end
    if DumbWRLD.toggles.loopspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = DumbWRLD.vars.walkspeed end
    if DumbWRLD.toggles.loopjump then game.Players.LocalPlayer.Character.Humanoid.JumpPower = DumbWRLD.vars.jumppower end
end)

game:GetService('RunService').Heartbeat:connect(function()
    for i,v in next, game.Players.LocalPlayer.PlayerGui.ScreenGui:WaitForChild("MinigameLayer"):GetChildren() do for k,q in next, v:WaitForChild("GuiGrid"):GetDescendants() do if q.Name == "ObjContent" or q.Name == "ObjImage" then q.Visible = true end end end
end)

game:GetService('RunService').Heartbeat:connect(function()
    if temptable.float then game.Players.LocalPlayer.Character.Humanoid.BodyTypeScale.Value = 0 floatpad.CanCollide = true floatpad.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y-3.75, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z) task.wait(0)  else floatpad.CanCollide = false end
end)

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)task.wait(1)vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

task.spawn(function()while task.wait() do
    if DumbWRLD.toggles.farmsnowflakes then
        task.wait(3)
        for i,v in next, temptable.tokenpath:GetChildren() do
            if v:FindFirstChildOfClass("Decal") and v:FindFirstChildOfClass("Decal").Texture == "rbxassetid://6087969886" and v.Transparency == 0 then
                api.humanoidrootpart().CFrame = CFrame.new(v.Position.X, v.Position.Y+3, v.Position.Z)
                break
            end
        end
    end
end end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if DumbWRLD.toggles.autofarm then
            temptable.dead = true
            DumbWRLD.toggles.autofarm = false
            temptable.converting = false
            temptable.farmtoken = false
        end
        if temptable.dead then
            task.wait(25)
            temptable.dead = false
            DumbWRLD.toggles.autofarm = true local player = game.Players.LocalPlayer
            temptable.converting = false
            temptable.tokensfarm = true
        end
    end)
end)

for _,v in next, game.workspace.Collectibles:GetChildren() do
    if string.find(v.Name,"") then
        v:Destroy()
    end
end

task.spawn(function() while task.wait() do
    pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    task.wait(0.00001)
    currentSpeed = (pos-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
    if currentSpeed > 0 then
        temptable.running = true
    else
        temptable.running = false
    end
end end)

hives = game.Workspace.Honeycombs:GetChildren() for i = #hives, 1, -1 do  v = game.Workspace.Honeycombs:GetChildren()[i] if v.Owner.Value == nil then game.ReplicatedStorage.Events.ClaimHive:FireServer(v.HiveID.Value) end end
if _G.autoload then if isfile("DumbWRLD/BSS_".._G.autoload..".json") then DumbWRLD = game:service'HttpService':JSONDecode(readfile("DumbWRLD/BSS_".._G.autoload..".json")) end end
for _, part in next, workspace:FindFirstChild("FieldDecos"):GetDescendants() do if part:IsA("BasePart") then part.CanCollide = false part.Transparency = part.Transparency < 0.5 and 0.5 or part.Transparency task.wait() end end
for _, part in next, workspace:FindFirstChild("Decorations"):GetDescendants() do if part:IsA("BasePart") and (part.Parent.Name == "Bush" or part.Parent.Name == "Blue Flower") then part.CanCollide = false part.Transparency = part.Transparency < 0.5 and 0.5 or part.Transparency task.wait() end end
for i,v in next, workspace.Decorations.Misc:GetDescendants() do if v.Parent.Name == "Mushroom" then v.CanCollide = false v.Transparency = 0.5 end end
for i,v in pairs(game:GetService("Workspace").Decorations.Misc:GetChildren()) do if string.find(v.Name, "Blue Flower") then v:Destroy() end end

