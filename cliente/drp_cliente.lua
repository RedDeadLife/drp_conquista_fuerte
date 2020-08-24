local robtime = 1200 -- Time to rob (in seconds) now its 10mins
local timerCount = robtime
local isRobbing = false
local timers = false


function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
	SetTextFontForCurrentCommand(15) -- Cambiar tipo de fuente: 1,2,3,...
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	--Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end

--Robbery startpoint
Citizen.CreateThread(function()
    while true do
	Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local betweencoords = GetDistanceBetweenCoords(coords, -4207.02, -3582.37, 49.43, true)
		if betweencoords < 2.0 then
			DrawTxt(Config.rob, 0.07, 0.05, 0.3, 0.3, true, 255, 255, 255, 255, true)
			if IsControlJustReleased(0, 0xC7B5340A) then		
			TriggerServerEvent("drp_asalto:startToRob", function() --Getting the item lockpick
			isRobbing = true
			end)	
			end
		end
	end
end)

RegisterNetEvent('drp_asalto:startAnimation')
AddEventHandler('drp_asalto:startAnimation', function()    
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 3500, true, false, false, false)
    exports['progressBars']:startUI(3500, "Inspeccionando...")
    Citizen.Wait(3500)
    --RequestModel("hotchkiss_cannon", true)
    --CreateVehicle("hotchkiss_cannon", -4207.02, -3582.37, 119.49, 49.43, true, false, false, false)
    ClearPedTasksImmediately(PlayerPedId())
    ClearPedSecondaryTask(PlayerPedId())
    Citizen.Wait(1000)
    TriggerEvent("drp_asalto:startTheEvent", function()
    end)
end)

--Startingthetimerandrob
RegisterNetEvent("drp_asalto:startTimer")
AddEventHandler("drp_asalto:startTimer",function()
	timers = true
	TriggerEvent("drp_asalto:startTimers")
		while timers do
		Citizen.Wait(0)
		DrawTxt("Asalta el fuerte durante... "..timerCount.." segundos", 0.15, 0.10, 0.3, 0.3, true, 255, 255, 255, 255, true)
		local playerPed = PlayerPedId()
		local playerdead = IsPlayerDead(playerped)
		if playerdead then
			timers = false
		end
		local coords = GetEntityCoords(playerPed)
		local betweencoords = GetDistanceBetweenCoords(coords, -4207.02, -3582.37, 49.43, true)
		if betweencoords > 2000.0 then
			timers = false
		end
		if timerCount == 0 then
			Citizen.Wait(1000)
			TriggerServerEvent("drp_asalto:payout", function()
		end)
		end
	end
end)

AddEventHandler("drp_asalto:startTimers",function()
Citizen.CreateThread(function()
    while timers do
    
	Citizen.Wait(1000)
    if timerCount >= 0 then
        timerCount = timerCount - 1
	else
		timers = false
    end
	end
end)
end)

function DrawText(text,x,y)
    SetTextScale(0.35,0.35)
    SetTextColor(255,255,255,255)--r,g,b,a
    SetTextCentre(true)
    SetTextDropshadow(1,0,0,0,200)
    SetTextFontForCurrentCommand(0)
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y)
end

RegisterNetEvent("drp_asalto:startTheEvent") -- Spawning the npc (locations are at config)
AddEventHandler("drp_asalto:startTheEvent",function(num,typey)
    while not HasModelLoaded( GetHashKey("G_M_O_UniExConfeds_01") ) do
        Wait(500)
        RequestModel( GetHashKey("G_M_O_UniExConfeds_01") )
    end
	local playerPed = PlayerPedId()
	AddRelationshipGroup('NPC')
	AddRelationshipGroup('PlayerPed')
	for k,v in pairs(Config.npcspawn) do
		pedy = CreatePed(GetHashKey("G_M_O_UniExConfeds_01"),v.x,v.y,v.z,0, true, false, 0, 0)
		SetPedRelationshipGroupHash(pedy, 'NPC')
        GiveWeaponToPed_2(pedy, 0x64356159, 500, true, 1, false, 0.0)
		Citizen.InvokeNative(0x283978A15512B2FE, pedy, true)
		Citizen.InvokeNative(0xF166E48407BAC484, pedy, PlayerPedId(), 0, 0)
		FreezeEntityPosition(pedy, false)
		TaskCombatPed(pedy,playerped, 0, 16)
	end
end)


