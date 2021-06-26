RegisterCommand("call", function(source, a, b)
    local c = tonumber(source)
    local d = a[1]
    if d == nil or d == '' then
        TriggerClientEvent('mythic_notify:client:SendAlert', c, {
            type = 'inform',
            text = 'You must enter a valid number!',
            length = 4000
        })
        return
    end
    TriggerClientEvent('phone:comandoLlamar', c, d)
end, false)
RegisterCommand("h", function(source, a, b)
    local c = tonumber(source)
    TriggerClientEvent('phone:hangupcall', c)
end, false)
RegisterCommand("a", function(source, a, b)
    local c = tonumber(source)
    TriggerClientEvent('phone:answercall', c)
end, false)
RegisterServerEvent('phone:llamarContacto')
AddEventHandler('phone:llamarContacto', function(d, e)
    local c = tonumber(source)
    local f = getPlayerID(source)
    local g = getNumberPhone(f)
    if d == nil or d == '' then return end
    local h = getIdentifierByPhoneNumber(d)
    local i = obtenerContactos(g)
    local j = h ~= nil and h ~= f;
    local k = false;
    if j == true then
        getSourceFromIdentifier(h, function(l)
            if l ~= nill then
                k = true;
                TriggerClientEvent('phone:intentoLlamar', c, c, l)
                TriggerClientEvent('phone:reciboLlamado', l, c, g)
            end
        end)
    else
        TriggerClientEvent('phone:intentoLlamar', c, c, nil)
    end
    if not k then TriggerClientEvent('phone:intentoLlamar', c, c, nil) end
end)
RegisterServerEvent('phone:ContestoLlamado')
AddEventHandler('phone:ContestoLlamado', function(l)
    local c = tonumber(source)
    TriggerClientEvent('phone:InicioLlamado', l, l, c)
end)
RegisterServerEvent('phone:cortarLlamado')
AddEventHandler('phone:cortarLlamado', function(l)
    TriggerClientEvent('phone:cortarLlamadoOtro', l)
end)
RegisterServerEvent('phone:ponerEnEspera')
AddEventHandler('phone:ponerEnEspera',
                function(l, m) TriggerClientEvent('OnHold:Client', l, m) end)
