ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('an_robnpc:reward')
AddEventHandler('an_robnpc:reward', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local luck = math.random(1,10)
	local rand = math.random(1, #Config.Items)
	if luck >= Config.Items[rand].chance then
		for k,v in pairs(Config.Items) do
			xPlayer.addInventoryItem(Config.Items[rand].name, 1)
			TriggerClientEvent('an_robnpc:notif', src, 'You stole x1 '..ESX.GetItemLabel(Config.Items[rand].name)..' from this person')
		end
	end
	local cashAmount = math.random(Config.minCashAmount, Config.maxCashAmount)
	xPlayer.addMoney(cashAmount)
	TriggerClientEvent('an_robnpc:notif', src, 'You robbed $'..cashAmount..' from this person')
end)
