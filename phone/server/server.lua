ESX = nil;
TriggerEvent('esx:getSharedObject', function(a) ESX = a end)
function getPlayerID(source)
    local b = ESX.GetPlayerFromId(source)
    return b.identifier
end
function getIdentifiant(c) for d, e in ipairs(c) do return e end end
function getPhoneRandomNumber()
    local f = math.random(100, 999)
    local g = math.random(0, 9999)
    local h = string.format("%03d-%04d", f, g)
    return h
end
function getNumberPhone(i)
    local j = MySQL.Sync.fetchAll(
                  "SELECT users.phone_number FROM users WHERE users.identifier = @identifier",
                  {['@identifier'] = i})
    if j[1] ~= nil then return j[1].phone_number end
    return nil
end
function getOrGeneratePhoneNumber(k, i, l)
    local k = k;
    local i = i;
    local m = getNumberPhone(i)
    if m == '0' or m == nil then
        repeat
            m = getPhoneRandomNumber()
            local c = getIdentifierByPhoneNumber(m)
            local n = getDataByPhoneNumber(m)
        until c == nil and n == nil;
        MySQL.Async.insert(
            "UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier",
            {['@myPhoneNumber'] = m, ['@identifier'] = i}, function()
                MySQL.Async.execute(
                    'INSERT INTO phone (`numero`,`contactos`,`mensajes`,`galeria`,`apps`, `fondo`) VALUES (@numero,@contactos,@mensajes,@galeria,@apps,@fondo)',
                    {
                        ['@numero'] = m,
                        ['@contactos'] = json.encode({}),
                        ['@mensajes'] = json.encode({}),
                        ['@galeria'] = json.encode({}),
                        ['@fondo'] = json.encode(Config.DefaultBackground),
                        ['@apps'] = json.encode({})
                    }, function()
                        MySQL.Async.execute(
                            'INSERT INTO phone_twitter (`nombre`) VALUES (@nombre)',
                            {['@nombre'] = obtenerUserTwitter(i)},
                            function() l(m) end)
                    end)
            end)
    else
        local o = getDataByPhoneNumber(m)
        if o == nil then
            MySQL.Async.execute(
                'INSERT INTO phone (`numero`,`contactos`,`mensajes`,`galeria`,`apps`, `fondo`) VALUES (@numero,@contactos,@mensajes,@galeria,@apps,@fondo)',
                {
                    ['@numero'] = m,
                    ['@contactos'] = json.encode({}),
                    ['@mensajes'] = json.encode({}),
                    ['@galeria'] = json.encode({}),
                    ['@fondo'] = json.encode(Config.DefaultBackground),
                    ['@apps'] = json.encode({})
                }, function()
                    MySQL.Async.execute(
                        'INSERT INTO phone_twitter (`nombre`) VALUES (@nombre)',
                        {['@nombre'] = obtenerUserTwitter(i)},
                        function() l(m) end)
                end)
        else
            l(m)
        end
    end
end
function getContactName(p, q)
    if #q ~= 0 then
        for r, e in pairs(q) do
            if e ~= nil then
                if e.number ~= nil and e.number == p then
                    return e.name
                end
            end
        end
    end
    return p
end
function getIdentifierByPhoneNumber(s)
    local j = MySQL.Sync.fetchAll(
                  "SELECT users.identifier FROM users WHERE users.phone_number = @phone_number",
                  {['@phone_number'] = s})
    if j[1] ~= nil then return j[1].identifier end
    return nil
end
function getDataByPhoneNumber(s)
    local j = MySQL.Sync.fetchAll(
                  "SELECT phone.numero FROM phone WHERE numero = @numero",
                  {['@numero'] = s})
    if j[1] ~= nil then return j[1].numero end
    return nil
end
function getSourceFromIdentifier(i, l)
    local t = ESX.GetPlayers()
    for r, u in pairs(t) do
        local v = ESX.GetPlayerFromId(u).identifier;
        if v == i then
            l(r)
            break
            return
        end
    end
    l(nil)
end
function obtenerContactos(s)
    local j = MySQL.Sync.fetchAll(
                  "SELECT phone.contactos FROM phone WHERE numero = @numero",
                  {['@numero'] = s})
    if j[1] ~= nil then return json.decode(j[1].contactos) or {} end
    return {}
end
function obtenerGaleria(s)
    local j = MySQL.Sync.fetchAll(
                  "SELECT phone.galeria FROM phone WHERE numero = @numero",
                  {['@numero'] = s})
    if j[1] ~= nil then return json.decode(j[1].galeria) or {} end
    return {}
end
function obtenerSMS(s)
    local j = MySQL.Sync.fetchAll(
                  "SELECT phone.mensajes FROM phone WHERE numero = @numero",
                  {['@numero'] = s})
    if j[1] ~= nil then return json.decode(j[1].mensajes) or {} end
    return {}
end
function obtenerFondo(s)
    local j = MySQL.Sync.fetchAll(
                  "SELECT phone.fondo FROM phone WHERE numero = @numero",
                  {['@numero'] = s})
    if j[1] ~= nil then return j[1].fondo end
    return {}
end
function obtenerApps(s)
    local j = MySQL.Sync.fetchAll(
                  "SELECT phone.apps FROM phone WHERE numero = @numero",
                  {['@numero'] = s})
    if j[1] ~= nil then return json.decode(j[1].apps) or {} end
    return {}
end
function obtenerTweets()
    local j = MySQL.Sync.fetchScalar(
                  "SELECT datos FROM phone_twitter WHERE nombre=@nombre",
                  {['@nombre'] = "tweets"})
    return json.decode(j) or {}
end
function obtenerUserTwitter(w)
    local n = MySQL.Sync.fetchAll(
                  'SELECT * FROM users WHERE identifier=@identifier',
                  {['@identifier'] = w})
    while not n do Citizen.Wait(0) end
    if n[1].firstname == nil then
        return nil
    else
        return '@' .. n[1].firstname .. '_' .. n[1].lastname
    end
end
function obtenerNombre(w)
    local n = MySQL.Sync.fetchAll(
                  'SELECT * FROM users WHERE identifier=@identifier',
                  {['@identifier'] = w})
    while not n do Citizen.Wait(0) end
    if n[1].firstname == nil then
        return nil
    else
        return n[1].firstname .. ' ' .. n[1].lastname
    end
end
function guardarTweets(x)
    MySQL.Sync.execute(
        "UPDATE phone_twitter SET datos=@datos WHERE nombre=@nombre",
        {['@datos'] = json.encode(x), ['@nombre'] = "tweets"})
end
function guardarApps(y, z)
    MySQL.Async.insert("UPDATE phone SET apps = @apps WHERE numero = @numero",
                       {['@apps'] = json.encode(z), ['@numero'] = y},
                       function() return true end)
end
function guardarContactos(y, q)
    MySQL.Async.insert(
        "UPDATE phone SET contactos = @contactos WHERE numero = @numero",
        {['@contactos'] = json.encode(q), ['@numero'] = y},
        function() return true end)
end
function guardarGaleria(y, A)
    MySQL.Async.insert(
        "UPDATE phone SET galeria = @galeria WHERE numero = @numero",
        {['@galeria'] = json.encode(A), ['@numero'] = y},
        function() return true end)
end
function guardarSMSs(y, B)
    MySQL.Async.insert(
        "UPDATE phone SET mensajes = @mensajes WHERE numero = @numero",
        {['@mensajes'] = json.encode(B), ['@numero'] = y},
        function() return true end)
end
function guardarFondo(y, C)
    MySQL.Async.insert("UPDATE phone SET fondo = @fondo WHERE numero = @numero",
                       {['@fondo'] = C, ['@numero'] = y},
                       function() return true end)
end
function tablefind(D, E) for F, G in pairs(D) do if G == E then return F end end end
function tablefindKeyVal(D, H, I)
    for F, G in pairs(D) do
        if G ~= nil and G[H] ~= nil and G[H] == I then return F end
    end
end
local J = {}
local K = {}
local L = {}
AddEventHandler('onServerResourceStart', function(M)
    if M == GetCurrentResourceName() then K = obtenerTweets() end
end)
AddEventHandler('esx:playerLoaded', function(source)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    getOrGeneratePhoneNumber(k, i, function(m)
        J[m] = true;
        TriggerClientEvent("phone:NumerosActivos", -1, J)
        TriggerClientEvent("phone:cargarContactos", k, obtenerContactos(m))
        TriggerClientEvent("phone:cargarSMS", k, obtenerSMS(m), m)
        TriggerClientEvent("phone:cargarGaleria", k, obtenerGaleria(m))
        TriggerClientEvent("phone:cargarFondo", k, obtenerFondo(m))
        TriggerClientEvent("phone:cargarApps", k, obtenerApps(m))
        TriggerClientEvent("phone:miNumero", k, m)
        TriggerClientEvent("phone:userTwitter", k, obtenerUserTwitter(i))
        TriggerClientEvent("phone:actualizaTweets", k, K, true)
        TriggerClientEvent('phone:listaAmarillas', k, L)
    end)
end)
RegisterServerEvent('phone:restart')
AddEventHandler('phone:restart', function(source)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    getOrGeneratePhoneNumber(k, i, function(m)
        J[m] = true;
        TriggerClientEvent("phone:NumerosActivos", -1, J)
        TriggerClientEvent("phone:cargarContactos", k, obtenerContactos(m))
        TriggerClientEvent("phone:cargarSMS", k, obtenerSMS(m), m)
        TriggerClientEvent("phone:cargarGaleria", k, obtenerGaleria(m))
        TriggerClientEvent("phone:cargarFondo", k, obtenerFondo(m))
        TriggerClientEvent("phone:cargarApps", k, obtenerApps(m))
        TriggerClientEvent("phone:miNumero", k, m)
        TriggerClientEvent("phone:userTwitter", k, obtenerUserTwitter(i))
        TriggerClientEvent("phone:actualizaTweets", k, K, true)
        TriggerClientEvent('phone:listaAmarillas', k, L)
    end)
end)
AddEventHandler('playerDropped', function()
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    J[h] = false;
    TriggerClientEvent("phone:NumerosActivos", -1, J)
end)
RegisterServerEvent('phone:oculto')
AddEventHandler('phone:oculto', function(I)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    J[h] = I;
    TriggerClientEvent("phone:NumerosActivos", -1, J)
end)
RegisterServerEvent('phone:getUser')
AddEventHandler('phone:getUser', function()
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    TriggerClientEvent("phone:userTwitter", k, obtenerUserTwitter(i))
end)
RegisterServerEvent('phone:obtenerContactos')
AddEventHandler('phone:obtenerContactos', function()
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    local q = obtenerContactos(h)
    TriggerClientEvent("phone:cargarContactos", k, q)
end)
RegisterServerEvent('phone:agregarContacto')
AddEventHandler('phone:agregarContacto', function(N, y)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    local q = obtenerContactos(h)
    local O = {name = N, number = y}
    table.insert(q, O)
    guardarContactos(h, q)
    TriggerClientEvent("phone:nuevoContacto", k, N, y)
    local P = obtenerSMS(h)
    local Q = false;
    print(y)
    for R, e in pairs(P) do
        if e.receiver == y or e.sender == y then
            Q = true;
            e.name = getContactName(y, q)
        end
    end
    print(Q)
    if Q then
        guardarSMSs(h, P)
        TriggerClientEvent("phone:cargarSMSbg", k, P, h)
    end
end)
RegisterServerEvent('phone:removerContacto')
AddEventHandler('phone:removerContacto', function(N, y)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    local q = obtenerContactos(h)
    local O = {name = N, number = y}
    table.remove(q, tablefind(q, O))
    guardarContactos(h, q)
    TriggerClientEvent("phone:borrarContacto", k, N, y)
    local P = obtenerSMS(h)
    local Q = false;
    print(y)
    for R, e in pairs(P) do
        if e.receiver == y or e.sender == y then
            Q = true;
            e.name = getContactName(y, q)
        end
    end
    print(Q)
    if Q then
        guardarSMSs(h, P)
        TriggerClientEvent("phone:cargarSMSbg", k, P, h)
    end
end)
RegisterServerEvent('phone:obtenerSMS')
AddEventHandler('phone:obtenerSMS', function()
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    local P = obtenerSMS(h)
    TriggerClientEvent("phone:cargarSMS", k, P, h)
end)
RegisterServerEvent('phone:obtenerSMSc')
AddEventHandler('phone:obtenerSMSc', function()
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    local P = obtenerSMS(h)
    TriggerClientEvent("phone:cargarSMSbg", k, P, h)
end)
RegisterServerEvent('phone:enviarSMS')
AddEventHandler('phone:enviarSMS', function(y, S, T)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    if y == h then
        TriggerClientEvent('mythic_notify:client:SendAlert', k, {
            type = 'error',
            text = 'You cannot send messages to yourself',
            length = 2500
        })
        return
    end
    local U = getIdentifierByPhoneNumber(y)
    local P = obtenerSMS(h)
    local V = obtenerSMS(y)
    local q = obtenerContactos(h)
    local W = obtenerContactos(y)
    local X = false;
    if T ~= false and T ~= nil then
        X = {["x"] = T.x, ["y"] = T.y, ["z"] = T.z}
    end
    local Y = {
        id = tonumber(#P + 1),
        name = getContactName(y, q),
        sender = h,
        receiver = y,
        recipient = false,
        date = os.date(),
        message = S,
        gps = X
    }
    local Z = {
        id = tonumber(#V + 1),
        name = getContactName(h, W),
        sender = h,
        receiver = y,
        recipient = true,
        date = os.date(),
        message = S,
        gps = X
    }
    table.insert(V, Z)
    guardarSMSs(y, V)
    if y ~= h then
        table.insert(P, Y)
        guardarSMSs(h, P)
        TriggerClientEvent("phone:nuevoSMS", k, Y, false)
    end
    if U ~= nil then
        getSourceFromIdentifier(U, function(_)
            if tonumber(_) ~= nil then
                TriggerClientEvent("phone:nuevoSMS", tonumber(_), Z, true)
            end
        end)
    end
end)
RegisterServerEvent('phone:borrarChat')
AddEventHandler('phone:borrarChat', function(y)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    local P = obtenerSMS(h)
    repeat
        local Q = false;
        for R, e in pairs(P) do
            if e.recipient then
                if e.sender == y then
                    Q = true;
                    table.remove(P, R)
                end
            else
                if e.receiver == y then
                    Q = true;
                    table.remove(P, R)
                end
            end
        end
    until Q == false;
    for R, e in pairs(P) do e.id = tonumber(R) end
    guardarSMSs(h, P)
    TriggerClientEvent("phone:cargarSMS", k, P, h)
end)
RegisterServerEvent('phone:ActualizarGaleria')
AddEventHandler('phone:ActualizarGaleria', function(A)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    guardarGaleria(h, A)
end)
RegisterServerEvent('phone:actualizarURLFondo')
AddEventHandler('phone:actualizarURLFondo', function(a0)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    guardarFondo(h, a0)
    TriggerClientEvent("phone:cargarFondo", k, obtenerFondo(h))
end)
RegisterServerEvent('phone:actualizaApps')
AddEventHandler('phone:actualizaApps', function(z)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    guardarApps(h, z)
end)
RegisterServerEvent('phone:twittear')
AddEventHandler('phone:twittear', function(u, a1)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    K[#K + 1] = {["handle"] = u, ["message"] = a1}
    guardarTweets(K)
    TriggerClientEvent('phone:actualizaTweets', -1, K)
end)
RegisterServerEvent('phone:paginasAmarillas')
AddEventHandler('phone:paginasAmarillas', function(a2)
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    local h = getNumberPhone(i)
    local N = obtenerNombre(i)
    for R, e in pairs(L) do if e.steam == i then table.remove(L, R) end end
    table.insert(L, {
        ["phonenumber"] = h,
        ["job"] = a2,
        ["name"] = N,
        ["steam"] = i
    })
    TriggerClientEvent('phone:listaAmarillas', -1, L)
    TriggerClientEvent('phone:actAmarillas', k)
end)
RegisterServerEvent('phone:borrarAmarilla')
AddEventHandler('phone:borrarAmarilla', function()
    local k = tonumber(source)
    local i = ESX.GetPlayerFromId(source).identifier;
    for R, e in pairs(L) do if e.steam == i then table.remove(L, R) end end
    TriggerClientEvent('phone:listaAmarillas', -1, L)
    TriggerClientEvent('phone:actAmarillas', k)
end)
RegisterServerEvent('phone:confirmaAsistencia')
AddEventHandler('phone:confirmaAsistencia', function(a3, a4)
    print("here")
    TriggerClientEvent('phone:confirmaAsist', a3, a4)
end)
RegisterServerEvent('tp:checkPhoneCount')
AddEventHandler('tp:checkPhoneCount', function()
    local a5 = source;
    local b = ESX.GetPlayerFromId(a5)
    if b.getInventoryItem('phone').count >= 1 then
        TriggerClientEvent('tp:heHasPhone', a5)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, {
            type = 'error',
            text = 'You dont have a phone, Buy one at your local store',
            length = 7000
        })
    end
end)
