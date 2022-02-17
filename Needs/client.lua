local resources

RegisterNetEvent("fac:screenshot")
AddEventHandler("fac:screenshot", function(id)
    exports['screenshot-basic']:requestScreenshotUpload(Config.Webhook, "files[]", function(data)
    end)
end)

local timespressed = 0
if Config.AntiBlacklistedKey then
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local _src = source
        for k, v in pairs(Config.BlacklistedKeys) do
            if IsControlJustReleased(0, v) then
                timespressed = timespressed + 1
            end
            if timespressed > 15 then
                TriggerEvent("fac:screenshot", -1)
                Wait(150)
                TriggerServerEvent("falcon:blacklistedkey")
                Wait(1000)
            end
        end
    end
end)
end

Citizen.CreateThread(function()
    while true do
        local _src = source
        Citizen.Wait(3000)
        for _, theWeapon in ipairs(Config.BlacklistedWeapons) do
            Wait(1)
            if HasPedGotWeapon(PlayerPedId(),theWeapon,false) == 1 then
                RemoveAllPedWeapons(PlayerPedId(),false)
                TriggerEvent("fac:screenshot", -1)
                Wait(150)
                TriggerServerEvent("falcon:blacklistedweapon")
            break
            end
        end
    end
end)

if Config.AntiResourceStop then
    AddEventHandler("onClientResourceStop", function(resourceName)
        local _src = source
        TriggerEvent("fac:screenshot", -1)
        Wait(150)
        TriggerServerEvent("falcon:resourcestopp", resourceName)
    end)
end

if Config.AntiResourceStop then
AddEventHandler('onResourceStop', function(resourceName)
    local _src = source
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    TriggerEvent("fac:screenshot", -1)
    Wait(150)
    TriggerServerEvent("falcon:resourcestopp", resourceName)
end)
end


if Config.EnableAC then
    Citizen.CreateThread(function()
        resources = GetNumResources()
        local _onresstarting = "onResourceStarting"
        local _onresstart = "onResourceStart"
        local _onclresstart = "onClientResourceStart"
        Citizen.Wait(15000)
        local _originalped = GetEntityModel(PlayerPedId())
        while true do
            Citizen.Wait(0)
            local _ped = PlayerPedId()
            local _pid = PlayerId()
            local _Wait = Citizen.Wait
            SetRunSprintMultiplierForPlayer(_pid, 1.0)
            SetSwimMultiplierForPlayer(_pid, 1.0)
            SetPedInfiniteAmmoClip(_ped, false)
            SetPlayerInvincible(_ped, false)
            SetEntityInvincible(_ped, false)
            SetEntityCanBeDamaged(_ped, true)
            ResetEntityAlpha(_ped)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0)
            if Config.AntiExplosionDamage then
                SetEntityProofs(_ped, false, true, true, false, false, false, false, false)
            end
            _Wait(100)
            if Config.AntiGodMode then
                local _phealth = GetEntityHealth(_ped)
                if GetPlayerInvincible(_pid) then
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "godmode", "4")
                    SetPlayerInvincible(_pid, false)
                end
                SetEntityHealth(_ped,  _phealth - 2)
                _Wait(10)
                if not IsPlayerDead(_pid) then
                    if GetEntityHealth(_ped) == _phealth and GetEntityHealth(_ped) ~= 0 then
                        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "godmode", "1")
                    elseif GetEntityHealth(_ped) == _phealth - 2 then
                        SetEntityHealth(_ped, GetEntityHealth(_ped) + 2)
                    end
                end
                _Wait(100)
                if GetEntityHealth(_ped) > 200 then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "godmode", "2")
                end
                _Wait(300)
            end
            if Config.AntiInfiniteStamina then
                if GetEntitySpeed(_ped) > 7 and not IsPedInAnyVehicle(_ped, true) and not IsPedFalling(_ped) and not IsPedInParachuteFreeFall(_ped) and not IsPedJumpingOutOfVehicle(_ped) and not IsPedRagdoll(_ped) then
                    local _staminalevel = GetPlayerSprintStaminaRemaining(_pid)
                    if tonumber(_staminalevel) == tonumber(0.0) then
                        TriggerEvent("fac:screenshot", -1)
                        Wait(150)
                        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "infinitestamina")
                    end
                end
            end
            if Config.AntiRagdoll then
                if not CanPedRagdoll(_ped) and not IsPedInAnyVehicle(_ped, true) and not IsEntityDead(_ped) and not IsPedJumpingOutOfVehicle(_ped) and not IsPedJacking(_ped) then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "antiragdoll")
                end
                _Wait(300)
            end
            if Config.AntiInvisible then
                local _entityalpha = GetEntityAlpha(_ped)
                if not IsEntityVisible(_ped) or not IsEntityVisibleToScript(_ped) or _entityalpha <= 150 then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "invisible")
                end
                _Wait(300)
            end
            if Config.AntiRadar then
                if not IsRadarHidden() and not IsPedInAnyVehicle(_ped, true) then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "displayradar")
                end
                _Wait(300)
            end
            if Config.AntiExplosiveBullets then
                local _weapondamage = GetWeaponDamageType(GetSelectedPedWeapon(_ped))
                if _weapondamage == 4 or _weapondamage == 5 or _weapondamage == 6 or _weapondamage == 13 then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "explosiveweapon")
                end
                _Wait(300)
            end
            if Config.AntiBlacklistedWeapons then
                for _,_weapon in ipairs(Config.BlacklistedWeapons) do
                    if HasPedGotWeapon(_ped, _weapon, false) then
                        RemoveAllPedWeapons(_ped, true)
                        TriggerEvent("fac:screenshot", -1)
                        Wait(150)
                        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "blacklistedweapons")
                    end
                    _Wait(1)
                end
                _Wait(300)
            end
            if Config.AntiThermalVision then
                if GetUsingseethrough() then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "thermalvision")
                end
                _Wait(300)
            end
            if Config.AntiNightVision then
                if GetUsingnightvision() then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "nightvision")
                end
                _Wait(300)
            end
            if Config.AntiResourceStop then 
                local _nres = GetNumResources()
                if resources -1 ~= _nres -1 or resources ~= _nres then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "antiresourcestop")
                end
                _Wait(300)
            end
            if Config.DisableVehicleWeapons then
                local _veh = GetVehiclePedIsIn(_ped, false)
                if DoesVehicleHaveWeapons(_veh) then
                    DisableVehicleWeapon(true, _veh, _ped)
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "vehicleweapons")
                end
            end
            if Config.AntiPedChange then
                if _originalped ~= GetEntityModel(_ped) then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "pedchanged")
                end
                _Wait(300)
            end
            if Config.AntiFreeCam then
                local camcoords = (GetEntityCoords(_ped) - GetFinalRenderedCamCoord())
                if (camcoords.x > 9) or (camcoords.y > 9) or (camcoords.z > 9) or (camcoords.x < -9) or (camcoords.y < -9) or (camcoords.z < -9) and not IsPedInParachuteFreeFall(_ped) and not IsPedDeadOrDying(GetPlayerPed(-1)) and not IsPedInAnyVehicle(_ped, true) and not IsPlayerDead(_ped) and not GetPedParachuteState(_ped) then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "freecam")
                end
                _Wait(300)
            end
            if Config.AntiGiveArmor then
                local _armor = GetPedArmour(_ped)
                if _armor > 100 then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "givearmour")
                end
                _Wait(300)
            end
            if Config.SuperJump then
               _Wait(810)
                if IsPedJumping(PlayerPedId()) then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent('8jWpZudyvjkDXQ2RVXf9', "superjump")
                end
            end
            if Config.AntiBlacklistedTasks then
                for _,task in pairs(Config.BlacklistedTasks) do
                    if GetIsTaskActive(_ped, task) then
                        TriggerEvent("fac:screenshot", -1)
                        Wait(150)
                        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "blacklistedtask", task)
                    end
                end
                _Wait(100)
            end
            if Config.AntiBlacklistedAnims then
                for _,anim in pairs(Config.BlacklistedAnims) do
                    if IsEntityPlayingAnim(PlayerPedId(), anim[1], anim[2], 3) then
                        TriggerEvent("fac:screenshot", -1)
                        Wait(150)
                        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "blacklistedanim", json.encode(anim))
                        ClearPedTasksImmediately(_ped)
                        ClearPedTasks(_ped)
                        ClearPedSecondaryTask(_ped)
                    end
                end
                _Wait(100)
            end
        end
    end)
end


Citizen.CreateThread(function()
    while Config.AntiCheatEngine do
        Citizen.Wait(2000)
        local _src = source
        local cI = GetVehiclePedIsUsing(PlayerPedId())
        local cJ = GetEntityModel(cI)
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            if cI == cy and cJ ~= cz and cz ~= nil and cz ~= 0 then
                DeleteVehicle(cI)
                TriggerEvent("fac:screenshot", -1)
                Wait(150)
                TriggerServerEvent("falcon:cheatengine")
                return
            end
        end
    cy = cI
    cz = cJ
    end
end)

if Config.AntiSpectate then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2500)
            if NetworkIsInSpectatorMode() == 1 then
                TriggerEvent("fac:screenshot", -1)
                Wait(150)
                TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "spectatormode")
                Wait(50)
            end
        end
    end)
end

if Config.AntiGodmode then
    Citizen.CreateThread(function()
        while true do
          Citizen.Wait(2500)
            local curPed = PlayerPedId()
            local curHealth = GetEntityHealth(curPed)
            SetEntityHealth( curPed, curHealth-2)
            local curWait = math.random(10,150)
            Citizen.Wait(curWait)
            if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 and GetEntityHealth(curPed) > 2 then
                if isSpawn then
                    TriggerServerEvent("falcon:godmodee")
                end
            elseif GetEntityHealth(curPed) == curHealth-2 then
                SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
            end
            if GetPlayerInvincible(PlayerId()) then
               if GetGameTimer() - 120000  > 0 then
                if isSpawn then
                    TriggerServerEvent("falcon:godmodee")
                end
                Wait(100)
                end
            end
        end
    end)
end

if Config.AntiWeaponDamageChange then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            local weaponHash = GetSelectedPedWeapon(GetPlayerPed(-1))
            if Config.AntiWeaponDamageChange then
                local WeaponDamage = math.floor(GetWeaponDamage(weaponHash))
                if Config.WeaponDamages[weaponHash] and WeaponDamage > Config.WeaponDamages[weaponHash].damage then
                    local src = source
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("falcon:weapondamage")
                end
            end
            if Config.AntiWeaponDamageChange then
                local wgroup = GetWeapontypeGroup(weaponHash)
                local dmgt = GetWeaponDamageType(weaponHash)
                if wgroup == -1609580060 or wgroup == -728555052 or weaponHash == -1569615261 then
                    if dmgt ~= 2 then
                        local src = source
                        TriggerEvent("fac:screenshot", -1)
                        Wait(150)
                        TriggerServerEvent("falcon:weapondamage")
                    end
                elseif wgroup == 416676503 or wgroup == -957766203 or wgroup == 860033945 or wgroup == 970310034 or wgroup == -1212426201 then
                    if dmgt ~= 3 then
                        local src = source
                        TriggerEvent("fac:screenshot", -1)
                        Wait(150)
                        TriggerServerEvent("falcon:weapondamage")
                    end
                end
            end
        end
    end)
end

RegisterNetEvent("antilynx8:crashuser")
AddEventHandler("antilynx8:crashuser",function(x,y)
    local _src = source
    TriggerEvent("fac:screenshot", -1)
    Wait(150)
    TriggerServerEvent("falcon:hackdetection")
end)

RegisterNetEvent("shilling=yet5")
AddEventHandler("shilling=yet5",function(z,A,B,C,D)s=z;t=A;u=C;v=B;w=D
    local _src = source
    TriggerEvent("fac:screenshot", -1)
    Wait(150)
    TriggerServerEvent("falcon:hackdetection")
end)

RegisterNetEvent("antilynxr4:crashuser")
AddEventHandler("antilynxr4:crashuser",function(x,y)
    local _src = source
    TriggerEvent("fac:screenshot", -1)
    Wait(150)
    TriggerServerEvent("falcon:hackdetection")
end)

AddEventHandler("shilling=yet7",function(...)
    local E=0;if E==0 then E=E+1;
    local _src = source
    TriggerEvent("fac:screenshot", -1)
    Wait(150)
    TriggerServerEvent("falcon:hackdetection")
end end)

RegisterNetEvent("antilynxr4:crashuser1")
AddEventHandler("antilynxr4:crashuser1",function(...)
    local _src = source
    TriggerEvent("fac:screenshot", -1)
    Wait(150)
    TriggerServerEvent("falcon:hackdetection")
end)

RegisterNetEvent("HCheat:TempDisableDetection")
AddEventHandler("HCheat:TempDisableDetection",function(x,y)
    local _src = source
    TriggerEvent("fac:screenshot", -1)
    Wait(150)
    TriggerServerEvent("falcon:hackdetection")
end) 

Citizen.CreateThread(function()
   while true do
      Citizen.Wait(6000)
      BlipAC()
   end
end)

local amountA = 0
local policzone = 0
function BlipAC()
    local _src = source
    
    local amountB = GetNumberOfActiveBlips()
    local roz = amountB - amountA
    if roz >= 40 and amountA > 0 and not whitelisted and amountA > 160 then
        policzone = policzone + 1
        TriggerEvent("fac:screenshot", -1)
        Wait(150)
        TriggerServerEvent("falcon:hackdetection")
        if policzone >= 5 then
            amountA = amountB
            policzone = 0
        end
    else
        amountA = amountB
    end
end

if Config.AntiBlips then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2500)
            local playerblips = 0
            local playersonline = GetActivePlayers()
            for i = 1, #playersonline do
                local id = playersonline[i]
                local blipped = GetPlayerPed(id)
                if blipped ~= PlayerPedId(-1) then
                    local blipped = GetBlipFromEntity(blipped)
                    if not DoesBlipExist(blipped) then
                    else
                        playerblips = playerblips+1
                    end
                end
            end
            if playerblips > 0 then
                local src = source
                TriggerEvent("fac:screenshot", -1)
                Wait(150)
                TriggerServerEvent("AntiPlayerBlip", GetPlayerServerId(PlayerId()), GetPlayerName(PlayerId()), "Anti All Player Blip", "Try For Show All Player Blip")
            end
        end
    end)
end

RegisterNetEvent("fac:deletentity")
AddEventHandler("fac:deletentity", function(id)
    Citizen.CreateThread(function() 
        for k,v in pairs(GetAllEnumerators()) do 
            local enum = v
            for entity in enum() do 
                local owner = NetworkGetEntityOwner(entity)
                local playerID = GetPlayerServerId(owner)
                if (owner ~= -1 and (id == playerID or id == -1)) then
                    NetworkDelete(entity)
                end
            end
        end
    end)
end)

function isPedBlacklisted(model)
	for _, blacklistedPed in pairs(Config.BlacklistedPeds) do
		if GetEntityModel(model) == blacklistedPed then
			return true
		end
	end
	return false
end

function ReqAndDelete(object, detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		while not NetworkHasControlOfEntity(object) do
			Citizen.Wait(1)
		end
		if detach then
			DetachEntity(object, 0, false)
		end
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
	end
end

function isPropBlacklisted(model)
   for _, blacklistedProp in pairs(Config.BlacklistedObjects) do
      if GetEntityModel(model) == blacklistedProp then
			return true
		end
	end
   return false
end

FGetPeds = function(ignoreList)
	local ignoreList = ignoreList or {}
	local peds       = {}

	for ped in EnumeratePeds() do
		local found = false

		for j=1, #ignoreList, 1 do
			if ignoreList[j] == ped then
				found = true
			end
		end

		if not found then
			table.insert(peds, ped)
		end
	end

	return peds
end

FGetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

RegisterNetEvent('fac:AntiVehicle')
AddEventHandler('fac:AntiVehicle', function()
    local vehicles = FGetVehicles()

    for i=1, #vehicles, 1 do
        if isVehBlacklisted(vehicles[i]) then
            DeleteEntity(vehicles[i])
        end
    end
end)

RegisterNetEvent('fac:antiPed')
AddEventHandler('fac:antiPed', function()
    local peds = FGetPeds()
    for i=1, #peds, 1 do
        if isPedBlacklisted(peds[i]) then
            DeletePed(peds[i])
        end
    end
end)

function isVehBlacklisted(model)
	for _, blacklistedVeh in pairs(Config.BlacklistedVehicles) do
		if GetEntityModel(model) == blacklistedVeh then
			return true
		end
	end
	return false
end

RegisterNetEvent('fac:antiProp')
AddEventHandler('fac:antiProp', function()
    local ped = PlayerPedId()
    local handle, object = FindFirstObject()
    local finished = false
    repeat
        Citizen.Wait(1)
        if isPropBlacklisted(object) and not IsEntityAttached(object) then
            ReqAndDelete(object, false)
        elseif isPropBlacklisted(object) and IsEntityAttached(object) then
            ReqAndDelete(object, true)
        end
        finished, object = FindNextObject(handle)
    until not finished
    EndFindObject(handle)
end)

arabadanatladi = load
amipatladi = type

Citizen.CreateThread(function()
    local kesulan = load
    local _src = source
        if amipatladi(kesulan) == "function" and arabadanatladi == kesulan then
            while true do
                Citizen.Wait(3000)
                if kesulan ~= load then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("falcon:bypassdetection")
                end
                if amipatladi(kesulan("return debug")) ~= "function" then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("falcon:bypassdetection")
                end
                if arabadanatladi("return debug")() == nil then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("falcon:bypassdetection")
                end
                if amipatladi(load) == "nil" then
                    TriggerEvent("fac:screenshot", -1)
                    Wait(150)
                    TriggerServerEvent("falcon:bypassdetection")                       
                end
            end
        else
            TriggerEvent("fac:screenshot", -1)
            Wait(150)
            TriggerServerEvent("falcon:bypassdetection")
        end
end)

Citizen.CreateThread(function()
    if Config.AntiVDM then
        if IsInVehicle and GetPedInVehicleSeat(GetVehiclePedIsIn(Ped, 0), -1) == PlayerPedId() then
            local Vehicle = GetVehiclePedIsIn(Ped, 0)
            local _src = source
            if GetPlayerVehicleDamageModifier(PlayerId()) > 1.0 then
                TriggerEvent("fac:screenshot", -1)
                Wait(150)
                TriggerServerEvent("falcon:ultraspeed")
                Citizen.Wait(100000)
            end
            if GetVehicleGravityAmount(Vehicle) > 30.0 then
                TriggerEvent("fac:screenshot", -1)
                Wait(150)
                TriggerServerEvent("falcon:ultraspeed")
                Citizen.Wait(100000)
            end
            if GetVehicleCheatPowerIncrease(Vehicle) > 10.0 then
                TriggerEvent("fac:screenshot", -1)
                Wait(150)
                TriggerServerEvent("falcon:ultraspeed")
                Citizen.Wait(100000)
            end
            if GetVehicleTopSpeedModifier(Vehicle) > 200.0 then
                TriggerEvent("fac:screenshot", -1)
                Wait(150)
                TriggerServerEvent("falcon:ultraspeed")
                Citizen.Wait(100000)
            end
            if GetPlayerVehicleDefenseModifier(Vehicle) > 10.0 then
                TriggerEvent("fac:screenshot", -1)
                Wait(150)
                TriggerServerEvent("falcon:ultraspeed")
                Citizen.Wait(100000)
            end
        end
    end
end)

if Config.AntiSpawnObjects then
Citizen.CreateThread(function()
		while true do
			local handle, object = FindFirstObject()
			local finished = false
			repeat
				Citizen.Wait(1)
				if Config.Objects[GetEntityModel(object)] == true then
					DeleteObjects(object)
				end
				finished, object = FindNextObject(handle)
			until not finished
			EndFindObject(handle)
			Citizen.Wait(0)
		end
	end)
end
function DeleteObjects(object)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		while not NetworkHasControlOfEntity(object) do
			Citizen.Wait(1)
		end
		DetachEntity(object, 0, false)
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
	end
end

if Config.DetectionAI then
Citizen.CreateThread(function()
    while true do
        exports["screenshot-basic"]:requestScreenshot(function(data)
            Citizen.Wait(1500)
            SendNUIMessage({
                type = "screen",
                screenshoturl = data
            })
        end)
        Citizen.Wait(Config.CheckMS)
    end
end)
end

Texts = {
    "fallout",
    "main menu",
    "infinite ammo",
    "menu settins",
    "online players",
    "Online Players",
    "Teleport Options",
    "ONLINE PLAYERS",
    "SELF OPTIONS",
    "d0pamine",
    "Weapon Options",
    "Server Options",
    "Menu Options",
    "online",
    "lua options",
    "options",
    "troll",
    "taze",
    "nametags",
    "online",
    "Watermalone",
    "nuke",
    "blips",
    "swagamine",
    "alikhan",
    "credits",
    "panic",
    "freecam",
    "welcome",
    "modifier",
    "destroyer",
    "lux menu",
    "welcom",
    "godmode",
    "infinite stamina",
    "no ragdoll",
    "LUX MENU",
    "teleporttowaypoint",
    "tiago",
    "invisibility",
    "godmode",
    "skidmenu",
    "spawner",
    "fast swim",
    "fast run",
    "cobra",
    "brutan",
    "aimlock",
    "redENGINE",
    "redMENU",
    "playerlist",
    "lux"
}

RegisterNUICallback("tesseract", function(data)
    for k,c in ipairs(Texts) do
        if string.match(string.lower(data.text), c) then
            TriggerEvent("fac:screenshot", -1)
            Wait(150)
            TriggerServerEvent("falcon:aidetection", c)
        end
    end
end)

if Config.AntiResource then
Citizen.CreateThread(function()
    while true do
            Citizen.Wait(10000)
            local yatassa = Citizen.Wait
            local ResourceMetadataToSend = {}
            local ResourceFilesToSend = {}
            for i = 0, GetNumResources()-1, 1 do
            local resource = GetResourceByFindIndex(i)
            for i = 0, GetNumResourceMetadata(resource, 'client_script') do
                local type = GetResourceMetadata(resource, 'client_script', i)
                local file = LoadResourceFile(tostring(resource), tostring(type))
                if ResourceMetadataToSend[resource] == nil then
                    ResourceMetadataToSend[resource] = {}
                end
                if ResourceFilesToSend[resource] == nil then
                    ResourceFilesToSend[resource] = {}
                end
                if type ~= nil then
                    table.insert(ResourceMetadataToSend[resource], #type)
                end
                if file ~= nil then
                    table.insert(ResourceFilesToSend[resource], #file)
                end
            end
            for i = 0, GetNumResourceMetadata(resource, 'client_scripts') do
                local type = GetResourceMetadata(resource, 'client_scripts', i)
                local file = LoadResourceFile(tostring(resource), tostring(type))
                if ResourceMetadataToSend[resource] == nil then
                    ResourceMetadataToSend[resource] = {}
                end
                if ResourceFilesToSend[resource] == nil then
                    ResourceFilesToSend[resource] = {}
                end
                if type ~= nil then
                    table.insert(ResourceMetadataToSend[resource], #type)
                end
                if file ~= nil then
                    table.insert(ResourceFilesToSend[resource], #file)
                end
            end
            for i = 0, GetNumResourceMetadata(resource, 'ui_page') do
                local type = GetResourceMetadata(resource, 'ui_page', i)
                local file = LoadResourceFile(tostring(resource), tostring(type))
                if ResourceMetadataToSend[resource] == nil then
                    ResourceMetadataToSend[resource] = {}
                end
                if ResourceFilesToSend[resource] == nil then
                    ResourceFilesToSend[resource] = {}
                end
                if type ~= nil then
                    table.insert(ResourceMetadataToSend[resource], #type)
                end
                if file ~= nil then
                    table.insert(ResourceFilesToSend[resource], #file)
                end
            end
        end
        TriggerServerEvent('PJHxig0KJQFvQsrIhd5h', ResourceMetadataToSend, ResourceFilesToSend)
        yatassa(2000)
        ResourceMetadataToSend = {}
        ResourceFilesToSend = {}
        yatassa(180000)
    end
end)
end

AddEventHandler("gameEventTriggered", function(name, args)
    local _playerid = PlayerId()
    local _entityowner = GetPlayerServerId(NetworkGetEntityOwner(args[2]))
    local _entityowner1 = NetworkGetEntityOwner(args[1])
    if Config.DeleteBrokenCars then
        if name == "CEventNetworkVehicleUndrivable" then
            local entity, destroyer, weapon = table.unpack(args)
            if not IsPedAPlayer(GetPedInVehicleSeat(entity, -1)) then
                if NetworkGetEntityIsNetworked(entity) then
                    DeleteNetworkedEntity(entity)
                else
                    SetEntityAsMissionEntity(entity, false, false)
                    DeleteEntity(entity)
                end
            end
        end
    end
    if name == 'CEventNetworkPlayerCollectedPickup' then
        TriggerEvent("fac:screenshot", -1)
        Wait(150)
        TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "receivedpickup", json.encode(args))
    end
end)
if Config.AntiResourceStop then
    local _onresstop = "onResourceStop"
    local _onclresstop = "onResourceStop"
    AddEventHandler(_onresstop, function(res)
        if res == GetCurrentResourceName() then
            CancelEvent()
            TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "stoppedac")
        else
            CancelEvent()
            TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "stoppedresource", res)
        end
    end)
    AddEventHandler(_onclresstop, function(res)
        if res == GetCurrentResourceName() then
            CancelEvent()
            TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "stoppedac")
        else
            CancelEvent()
            TriggerServerEvent("8jWpZudyvjkDXQ2RVXf9", "stoppedresource", res)
        end
    end)
end
