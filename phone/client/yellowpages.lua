local a = {}
local b = {}
RegisterNetEvent('phone:listaAmarillas')
AddEventHandler('phone:listaAmarillas', function(c) a = c end)
local d = {
    ["taxi"] = "taxi",
    ["mechanic"] = "mechanic",
    ["police"] = "police",
    ["ambulance"] = "ambulance"
}
RegisterNUICallback('newPostSubmit', function(e, f)
    local g = miTrabajo()
    print(g)
    if d[g] == nil then
        TriggerServerEvent('phone:paginasAmarillas', e.advert)
    else
        TriggerServerEvent('phone:paginasAmarillas', d[g] .. " | " .. e.advert)
    end
end)
RegisterNUICallback('deleteYP',
                    function() TriggerServerEvent('phone:borrarAmarilla') end)
RegisterNetEvent('phone:actAmarillas')
AddEventHandler('phone:actAmarillas', function()
    b = {}
    for h = 1, #a do
        local i = "<b>" .. a[tonumber(h)].job .. "</b> <br> Telephone " ..
                      a[tonumber(h)].phonenumber;
        local j = {id = tonumber(h), name = a[tonumber(h)].name, message = i}
        table.insert(b, j)
    end
    SendNUIMessage({openSection = "notificationsYP", list = b})
end)
RegisterNUICallback('assistance', function(e, f)
    SendNUIMessage({openSection = "assistance"})
    f('ok')
end)
RegisterNUICallback('notificationsYP', function()
    b = {}
    for h = 1, #a do
        local i = "<b>" .. a[tonumber(h)].job .. "</b> <br> Telephone " ..
                      a[tonumber(h)].phonenumber;
        local j = {id = tonumber(h), name = a[tonumber(h)].name, message = i}
        table.insert(b, j)
    end
    SendNUIMessage({openSection = "notificationsYP", list = b})
end)
