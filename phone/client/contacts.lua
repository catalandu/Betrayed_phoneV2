local a = {}
local b = {}
local c = {}
local d = true;
local e = false;
function Mute() return d end
function ResetContacts()
    b = {}
    SendNUIMessage({emptyContacts = true})
end
function getContactName(f)
    if #b ~= 0 then
        for g, h in pairs(b) do
            if h ~= nil then
                if h.number ~= nil and h.number == f then
                    return h.name
                end
            end
        end
    end
    return f
end
function EstaAgendado(f)
    if #b ~= 0 then
        for g, h in pairs(b) do
            if h ~= nil then
                if h.number ~= nil and h.number == f then
                    return true
                end
            end
        end
    end
    return false
end
RegisterNetEvent("phone:NumerosActivos")
AddEventHandler("phone:NumerosActivos", function(i)
    ResetContacts()
    if GuiEnabled() then TriggerServerEvent('phone:obtenerContactos') end
    c = i
end)
RegisterNetEvent('phone:cargarContactos')
AddEventHandler('phone:cargarContactos', function(j)
    ResetContacts()
    local k = function(l, m)
        return string.sub(l.name, 1, 1) < string.sub(m.name, 1, 1)
    end;
    table.sort(j, k)
    if #j ~= 0 then
        for g, h in pairs(j) do
            if h ~= nil then
                local n = {}
                if c[h.number] then
                    n = {name = h.name, number = h.number, activated = 1}
                else
                    n = {name = h.name, number = h.number, activated = 0}
                end
                table.insert(b, n)
                SendNUIMessage({newContact = true, contact = n})
            end
        end
    else
        SendNUIMessage({emptyContacts = true})
    end
end)
RegisterNetEvent('phone:agregarContacto')
AddEventHandler('phone:agregarContacto', function(o, f)
    if o ~= nil and f ~= nil then
        TriggerServerEvent('phone:agregarContacto', o, f)
    else
        PhoneSendNotification(_U('put_name_number'))
    end
end)
RegisterNetEvent('phone:nuevoContacto')
AddEventHandler('phone:nuevoContacto', function(o, f)
    PhoneSendNotification(_U('saved_contact'))
    TriggerServerEvent('phone:obtenerContactos')
end)
RegisterNetEvent('phone:borrarContacto')
AddEventHandler('phone:borrarContacto',
                function(o, f) TriggerServerEvent('phone:obtenerContactos') end)
RegisterNetEvent('phone:deleteSMS')
AddEventHandler('phone:deleteSMS', function(p)
    table.remove(a, tablefindKeyVal(a, 'id', tonumber(p)))
    PhoneSendNotification(_U('message_removed'))
end)
RegisterNetEvent('phone:loadSMSOther')
AddEventHandler('phone:loadSMSOther', function(q, r)
    openGui()
    a = {}
    if #q ~= 0 then
        for g, h in pairs(q) do
            if h ~= nil then
                local s = false;
                if h.receiver == r then s = true end
                local t = {
                    id = tonumber(h.id),
                    name = getContactName(h.sender),
                    sender = tonumber(h.sender),
                    receiver = tonumber(h.receiver),
                    recipient = s,
                    date = tonumber(h.date),
                    message = h.message,
                    gps = h.gps
                }
                table.insert(a, t)
            end
        end
    end
    SendNUIMessage({openSection = "messagesOther", list = a})
end)
RegisterNetEvent('phone:nuevoSMS')
AddEventHandler('phone:nuevoSMS', function(u, v)
    local t = u;
    table.insert(a, t)
    SendNUIMessage({newSMS = true, sms = t})
    if v and hasPhone() then
        if not GuiEnabled() then SendNUIMessage({openSection = "newsms"}) end
        if d then
            TriggerEvent("DoLongHudText", "You just received a new SMS.", 16)
            PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
        end
    end
end)
RegisterNUICallback('btnMute', function()
    if d then
        PhoneSendNotification(_U('notifications_off'))
    else
        PhoneSendNotification(_U('notifications_on'))
    end
    d = not d
end)
RegisterNUICallback('btnOculto', function()
    if e then
        PhoneSendNotification(_U('hidden_off'))
        TriggerServerEvent('phone:oculto', true)
        e = false
    else
        PhoneSendNotification(_U('hidden_on'))
        TriggerServerEvent('phone:oculto', false)
        e = true
    end
end)
RegisterNetEvent('phone:cargarSMS')
AddEventHandler('phone:cargarSMS', function(q, r)
    a = {}
    if #q ~= 0 then
        for g, h in pairs(q) do
            if h ~= nil then
                local t = {
                    id = tonumber(h.id),
                    name = h.name,
                    sender = h.sender,
                    receiver = h.receiver,
                    recipient = h.recipient,
                    date = h.date,
                    message = h.message,
                    gps = h.gps
                }
                table.insert(a, t)
            end
        end
    end
    SendNUIMessage({openSection = "messages", list = a})
end)
RegisterNetEvent('phone:cargarSMSbg')
AddEventHandler('phone:cargarSMSbg', function(q, r)
    a = {}
    if #q ~= 0 then
        for g, h in pairs(q) do
            if h ~= nil then
                local t = {
                    id = tonumber(h.id),
                    name = h.name,
                    sender = h.sender,
                    receiver = h.receiver,
                    recipient = h.recipient,
                    date = h.date,
                    message = h.message,
                    gps = h.gps
                }
                table.insert(a, t)
            end
        end
    end
    SendNUIMessage({openSection = "updateMessages", list = a})
end)
local w = {}
RegisterNetEvent('phone:confirmaAsist')
AddEventHandler('phone:confirmaAsist', function(x)
    if w[config.servicios[x]] then
        w[config.servicios[x]] = false;
        local y = _U('service_attending')
        local y = y:gsub('{service}', config.servicios[x])
        PhoneSendNotification(y)
    end
end)
RegisterNetEvent('phone:enviarSMS')
AddEventHandler('phone:enviarSMS', function(f, t, z)
    if f ~= nil and t ~= nil then
        if tablefind(config.servicios, f) then
            if not w[f] then
                w[f] = true;
                local A = t;
                if f == "Police" then A = "911 | " .. t end
                local B = GetEntityCoords(PlayerPedId())
                CallService(tablefind(config.servicios, f), A, B)
                Citizen.Wait(180000)
                w[f] = false
            else
                PhoneSendNotification(_U('already_called_service'))
            end
        else
            if z then
                TriggerServerEvent('phone:enviarSMS', f, t,
                                   GetEntityCoords(PlayerPedId()))
            else
                TriggerServerEvent('phone:enviarSMS', f, t, false)
            end
            TriggerEvent("InteractSound_CL:PlayOnOne", "sendsms", 0.5)
            TriggerEvent("DoLongHudText", "Message sent.", 16)
        end
    else
        PhoneSendNotification(_U('put_number_message'))
    end
end)
RegisterNUICallback('contacts', function(C, D)
    if #a == 0 then TriggerServerEvent('phone:obtenerSMSc') end
    if #b == 0 then TriggerServerEvent('phone:obtenerContactos') end
    SendNUIMessage({openSection = "contacts"})
    D('ok')
end)
RegisterNUICallback('newContact', function(C, D)
    SendNUIMessage({openSection = "newContact"})
    D('ok')
end)
RegisterNUICallback('newContactSubmit', function(C, D)
    TriggerEvent('phone:agregarContacto', C.name, C.number)
    D('ok')
end)
RegisterNUICallback('removeContact', function(C, D)
    TriggerServerEvent('phone:removerContacto', C.name, C.number)
    D('ok')
end)
RegisterNUICallback('messages', function(C, D)
    loading()
    if #a == 0 then
        TriggerServerEvent('phone:obtenerSMS')
    else
        SendNUIMessage({openSection = "messages", list = a})
    end
    D('ok')
end)
RegisterNUICallback('messageRead', function(C, D)
    SendNUIMessage({
        openSection = "messageRead",
        list = a,
        senderN = C.number,
        agendado = EstaAgendado(C.number)
    })
    D('ok')
end)
function abrirultimochat(E)
    SendNUIMessage({
        openSection = "messageRead",
        list = a,
        senderN = E,
        agendado = EstaAgendado(E)
    })
end
RegisterNUICallback('messageDelete', function(C, D)
    TriggerServerEvent('phone:removeSMS', C.id, C.number)
    D('ok')
end)
RegisterNUICallback('newMessage', function(C, D)
    SendNUIMessage({openSection = "newMessage"})
    D('ok')
end)
RegisterNUICallback('messageReply', function(C, D)
    SendNUIMessage({openSection = "newMessageReply", number = C.number})
    D('ok')
end)
RegisterNUICallback('newMessageSubmit', function(C, D)
    if not GetDeathStatus() then
        TriggerEvent('phone:enviarSMS', C.number, C.message, C.gps)
        D('ok')
    else
        TriggerEvent("DoLongHudText", "You can't do this hurt.", 2)
    end
end)
RegisterNUICallback('marcarUbicacion', function(C, D)
    PhoneSendNotification(_U('location_marked'))
    SetNewWaypoint(tonumber(C.coords.x), tonumber(C.coords.y))
end)
RegisterNUICallback('borrarChat', function(C, D)
    TriggerServerEvent('phone:borrarChat', C.number)
end)
