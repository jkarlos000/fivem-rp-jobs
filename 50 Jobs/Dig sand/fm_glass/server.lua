ESX = nil
local playersProcessing = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('fm_glass:sell')
AddEventHandler('fm_glass:sell', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = config.items[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		return
	end

	if xItem.count < amount then
		return
	end

	price = ESX.Math.Round(price * amount)
	xPlayer.addMoney(price)

	xPlayer.removeInventoryItem(xItem.name, amount)

end)


RegisterServerEvent('fm_glass:process')
AddEventHandler('fm_glass:process', function()
	if not playersProcessing[source] then
		local _source = source

		playersProcessing[_source] = ESX.SetTimeout(5000, function()
			
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xMin, xMax = xPlayer.getInventoryItem('Sand_a'), xPlayer.getInventoryItem('glass_b')
			if xMax.limit ~= -1 and (xMax.count + 1) >= xMax.limit then
				--
			elseif xMin.count < 1 then
				--
			else
				xPlayer.removeInventoryItem('Sand_a', 1)
				xPlayer.addInventoryItem('glass_b', 1)
			end

			playersProcessing[_source] = nil
		end)
	end
end)

function CancelProcessing(playerID)
	if playersProcessing[playerID] then
		ESX.ClearTimeout(playersProcessing[playerID])
		playersProcessing[playerID] = nil
	end
end

RegisterServerEvent('fm_glass:cancelProcessing')
AddEventHandler('fm_glass:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
