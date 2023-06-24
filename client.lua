ESX = nil
PlayerData = nil
local robbingInProgress = false
local robbingTXTDRW = false
local randmsg = ''
local txtDrawCoords = nil
local robbedPeds = {}

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if not robbingInProgress then
			if IsPedArmed(ped, 6) and not IsPedInAnyVehicle(ped, false) then 
				local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
				local job = PlayerData.job.name
				if aiming and not IsPedAPlayer(targetPed) and not IsPedInAnyVehicle(targetPed, false) and not Config.blacklistedJobs[job] then
					local luck = math.random(1,100)
					if luck > Config.runAwayPercentage then
						if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and not IsEntityDead(targetPed) then
							local robbingCanceled = false
							local distance = GetDistanceBetweenCoords(GetEntityCoords(ped, true), GetEntityCoords(targetPed, true), false)
							if distance < 6 then -- IsPedFacingPed(targetPed, ped, 60.0)
								if robbedPeds[targetPed] == nil then
									randmsg = math.random(1, #Config.msgNPC)
									print(targetPed)
									robbingInProgress = true
									LoadAnim('missfbi5ig_22')
									LoadAnim('oddjobs@shop_robbery@rob_till')
									SetPedDropsWeaponsWhenDead(targetPed, false)
									ClearPedTasks(targetPed)
									TaskSetBlockingOfNonTemporaryEvents(targetPed, true)
									SetPedFleeAttributes(targetPed, 0, 0)
									SetPedCombatAttributes(targetPed, 17, 1)
									SetPedSeeingRange(targetPed, 0.0)
									SetPedHearingRange(targetPed, 0.0)
									SetPedAlertness(targetPed, 0)
									SetPedKeepTask(targetPed, true)
									FreezeEntityPosition(targetPed, true)
									Notif('Keep your gun drawn to rob')
									robbingTXTDRW = true
									txtDrawCoords = GetEntityCoords(targetPed, true)
									TaskTurnPedToFaceEntity(targetPed, ped, -1)
									TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_anxious_scientist", 8.0, -1, -1, 12, 1, 0, 0, 0)
									Wait(1500)
									TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_loop_scientist", 8.0, 1.0, Config.robbingTime + 5000, 1)
									local aiming2, targetPed2 = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
									if not aiming2 or targetPed2 ~= targetPed then
										robbingCanceled = true
										TaskReactAndFleePed(targetPed, ped)
										return
									end
									Wait(2000)
									local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), GetEntityCoords(targetPed, true), false)
									if not IsEntityDead(targetPed) and distance < 6 and not robbingCanceled then
										txtDrawCoords = nil
										robbingTXTDRW = false
										PlaySoundFrontend(-1, 'YES', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
										Notif('The person is complying with your orders')
										FreezeEntityPosition(targetPed, false)
										FreezeEntityPosition(ped, true)
										ClearPedTasks(targetPed)
										TaskGoToEntity(targetPed, ped, -1, 1.5, 1.0, 100, 0)
										Wait(4000)
										FreezeEntityPosition(ped, false) 
										TaskTurnPedToFaceEntity(ped, targetPed, -1) 
										TaskTurnPedToFaceEntity(targetPed, ped, -1) 
										FreezeEntityPosition(ped, true) 
										Wait(1500)
										ClearPedTasks(targetPed)
										FreezeEntityPosition(targetPed, true)
										FreezeEntityPosition(ped, false)
										TaskPlayAnim(targetPed, "missfbi5ig_22", "hands_up_loop_scientist", 8.0, 1.0, Config.robbingTime, 1)
										TaskPlayAnim(ped, "oddjobs@shop_robbery@rob_till", "loop", 8.0, 1.0, Config.robbingTime, 1)
										PlaySoundFrontend(-1, 'Grab_Parachute', 'BASEJUMPS_SOUNDS', 1)
										if Config.useProgressBars then
											exports['progressBars']:startUI(Config.robbingTime, "Theft in progress..")
										else
											Notif('Theft in progress..')
										end
										Citizen.Wait(Config.robbingTime)
										ClearPedTasksImmediately(ped)
										TriggerServerEvent('an_robnpc:reward')
										FreezeEntityPosition(targetPed, false)
										robbedPeds[targetPed] = true
										TaskReactAndFleePed(targetPed, ped)
										SetPedKeepTask(targetPed, true)
										robbingInProgress = false
									else
										Notif('The person ran away')
										PlaySoundFrontend(-1, 'Out_Of_Bounds_Timer', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', 1)
										FreezeEntityPosition(targetPed, false)
										TaskReactAndFleePed(targetPed, ped)
										SetPedKeepTask(targetPed, true)
										robbingInProgress = false
										txtDrawCoords = nil
										robbingTXTDRW = false
										return
									end
								else
									Notif('That person was Robbed recently!')
								end
							end
						end
					else
						if DoesEntityExist(targetPed) then
							TaskReactAndFleePed(targetPed, ped)
							SetPedKeepTask(targetPed, true)
						end
						robbingInProgress = false
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if robbingInProgress and robbingTXTDRW and txtDrawCoords ~= nil then
			draw3DTEXT(txtDrawCoords.x, txtDrawCoords.y, txtDrawCoords.z + 0.2, "~r~[~w~ROB~r~]~w~: "..Config.msgNPC[randmsg])
		end
	end
end)

-- Event
RegisterNetEvent('an_robnpc:notif')
AddEventHandler('an_robnpc:notif', function(msg)
	Notif(msg)
end)

-- Function
function Notif(msg)
	if Config.useMythicNotify then
		exports['mythic_notify']:SendAlert('inform', msg, Config.notifTime, { ['background-color'] = '#2B6483', ['color'] = '#fff' })
	else
		ESX.ShowNotification(msg)
	end
end

function LoadAnim(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function draw3DTEXT(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.32, 0.32)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextOutline(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
end