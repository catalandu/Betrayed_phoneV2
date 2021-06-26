FirstSpawn = true 

-- AddEventHandler('onClientResourceStart', function(resname)
-- 	if resname == GetCurrentResourceName() then
-- 		TriggerServerEvent('phone:restart')
-- 	end
-- end)

-- AddEventHandler('esx:onPlayerSpawn', function()
-- 	if FirstSpawn then
-- 		FirstSpawn = false 
--       	TriggerServerEvent('phone:restart')
-- 	end
-- end)

function PhoneSetCallChannel(id)
	exports["mumble-voip"]:SetCallChannel(id)
end

function PhoneSendNotification(msg)
	ESX.ShowNotification(msg)
end


function CallService(service, msg, coords)
	-- Your trigger here
	-- Example: TriggerServerEvent('MF_Trackables:NotifyAll',msg,coords,service,true,GetPlayerServerId(PlayerId()))
end