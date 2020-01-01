local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil

local PlayerData = {}

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterNetEvent( 'lootanim' )
AddEventHandler( 'lootanim', function()
    
    ClearPedSecondaryTask(GetPlayerPed(-1))
    loadAnimDict( "amb@prop_human_bum_bin@enter" ) 
    TaskPlayAnim( GetPlayerPed(-1), "amb@prop_human_bum_bin@enter", "enter", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
		if IsControlJustReleased(0, Keys['E']) then
			local ped = PlayerPedId()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			local target, distance = ESX.Game.GetClosestPlayer()
            if IsPlayerDead(closestPlayer) then 
                if closestPlayer ~= -1 and closestDistance <= 1.5 then
					
					TriggerEvent("lootanim")
					exports['progressBars']:startUI(5500, 'Searching Body')
					Citizen.Wait(5500)					
                    OpenBodySearchMenu(closestPlayer)
					Citizen.Wait(850)
					ClearPedTasks(GetPlayerPed(-1))
					elseif distance < 20 and distance > 2.0 then
                      ESX.ShowNotification(_U('too_far'))
				end
			end
		end
	end
end)


function OpenBodySearchMenu(player)
	TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(player), GetPlayerName(player))
end