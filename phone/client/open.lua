local a = false;
local b = false;
local c = false;
local d = {}
local e = nil;
local f = 'nui://phone/html/fondo.jpg'
RegisterNetEvent("phone:cargarFondo")
AddEventHandler("phone:cargarFondo", function(g) f = g end)
RegisterNetEvent("phone:miNumero")
AddEventHandler("phone:miNumero", function(h) e = h end)
function openGuiNow()
    if hasPhone() then
        GiveWeaponToPed(PlayerPedId(), 0xA2719263, 0, 0, 1)
        c = true;
        SetNuiFocus(true)
        SendNUIMessage({openPhone = true, fondo = f, numero = e})
        TriggerEvent('phoneEnabled', true)
        TriggerEvent('animation:sms', true)
        if a == false then
            ResetContacts()
            TriggerServerEvent('phone:obtenerContactos')
            a = true
        end
        doTimeUpdate()
    else
        closeGui()
        TriggerEvent("DoLongHudText", "You don't have a phone.", 2)
    end
    b = false
end
function openGui()
    if b then return end
    if hasPhone() then
        GiveWeaponToPed(PlayerPedId(), 0xA2719263, 0, 0, 1)
        c = true;
        SetNuiFocus(true)
        SendNUIMessage({openPhone = true, fondo = f, numero = e})
        TriggerEvent('phoneEnabled', true)
        TriggerEvent('animation:sms', true)
        if a == false then
            ResetContacts()
            TriggerServerEvent('phone:obtenerContactos')
            a = true
        end
        doTimeUpdate()
    else
        closeGui()
        closeGui()
        TriggerEvent("DoLongHudText", "You don't have a phone.", 2)
    end
    Citizen.Wait(2000)
    b = false
end
function closeGui()
    SetNuiFocus(false, false)
    SendNUIMessage({openPhone = false})
    c = false;
    TriggerEvent('animation:sms', false)
    TriggerEvent('phoneEnabled', false)
    b = true;
    Citizen.Wait(2000)
    b = false;
    insideDelivers = false
end
function closeGui2()
    SetNuiFocus(false)
    SendNUIMessage({openPhone = false})
    c = false;
    b = true;
    Citizen.Wait(2000)
    b = false
end
RegisterNetEvent('phone:addnotification')
AddEventHandler('phone:addnotification', function(i, j)
    if not c then SendNUIMessage({openSection = "newemail"}) end
    d[#d + 1] = {["name"] = i, ["message"] = j}
end)
RegisterNUICallback('notifications', function()
    lstnotifications = {}
    for k = 1, #d do
        local l = {
            id = tonumber(k),
            name = d[tonumber(k)].name,
            message = d[tonumber(k)].message
        }
        table.insert(lstnotifications, l)
    end
    SendNUIMessage({openSection = "notifications", list = lstnotifications})
end)
function refreshmail()
    lstnotifications = {}
    for k = 1, #d do
        local l = {
            id = tonumber(k),
            name = d[tonumber(k)].name,
            message = d[tonumber(k)].message
        }
        table.insert(lstnotifications, l)
    end
    SendNUIMessage({openSection = "notifications", list = lstnotifications})
end
RegisterNetEvent('phone:abrir')
AddEventHandler('phone:abrir', function() openGui() end)
RegisterNUICallback('close', function(m, n)
    closeGui()
    n('ok')
end)
RegisterNetEvent('phone:close')
AddEventHandler('phone:close', function(o, j) closeGui() end)
function GuiEnabled() return c end
