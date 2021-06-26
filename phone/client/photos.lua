local a = {}
local b = false;
RegisterNetEvent("phone:cargarGaleria")
AddEventHandler("phone:cargarGaleria", function(c) a = c end)
RegisterNUICallback('btnGaleria', function(d, e)
    for f, g in pairs(a) do
        if f and f ~= false and g and g ~= false then
            SendNUIMessage({newFoto = true, foto = {id = g}})
        end
    end
end)
RegisterNUICallback('abrirfoto', function(d, e)
    if d.chat then
        b = d.chat;
        SendNUIMessage({
            openSection = "fotogrande",
            foto = d.id,
            guardada = a[tablefind(a, d.id)],
            chat = d.chat
        })
    else
        b = false;
        SendNUIMessage({
            openSection = "fotogrande",
            foto = d.id,
            guardada = a[tablefind(a, d.id)]
        })
    end
end)
RegisterNUICallback('btnVChat', function(d, e)
    if b ~= false then
        if b == "twitter" then
            AbrirTwitter()
        else
            abrirultimochat(b)
        end
    else
        for f, g in pairs(a) do
            if f and f ~= false and g and g ~= false then
                SendNUIMessage({newFoto = true, foto = {id = g}})
            end
        end
    end
end)
RegisterNUICallback('copiarURL', function(d, e) end)
RegisterNUICallback('guardarfoto', function(d, e)
    a[#a + 1] = d.url;
    TriggerServerEvent('phone:ActualizarGaleria', a)
    if not d.chat then b = false end
    SendNUIMessage({
        openSection = "fotogrande",
        foto = d.url,
        guardada = a[tablefind(a, d.url)],
        chat = b
    })
end)
RegisterNUICallback('errorimg', function(d, e) end)
RegisterNUICallback('BaseURLFondo', function(d, e)
    TriggerServerEvent('phone:actualizarURLFondo', tostring(d.fondo))
end)
RegisterNUICallback('actualizarURLFondo', function(d, e)
    TriggerServerEvent('phone:actualizarURLFondo', tostring(d.fondo))
end)
RegisterNUICallback('borrarfoto', function(d, e)
    table.remove(a, tablefind(a, d.url))
    TriggerServerEvent('phone:ActualizarGaleria', a)
    if not d.chat then b = false end
    SendNUIMessage({
        openSection = "fotogrande",
        foto = d.url,
        guardada = a[tablefind(a, d.url)],
        chat = b
    })
end)
RegisterNUICallback('cerrarfoto', function(d, e)
    TriggerEvent('phone:abrir')
    if not d.chat then b = false end
    SendNUIMessage({
        openSection = "fotogrande",
        foto = d.id,
        guardada = a[tablefind(a, d.id)],
        chat = b
    })
end)
RegisterNUICallback('btnCamara', function(d, e)
    local h = false;
    CreateMobilePhone(1)
    CellCamActivate(true, true)
    takePhoto = true;
    Citizen.Wait(0)
    if guiEnabled == true then
        SetNuiFocus(false, false)
        guiEnabled = false
    end
    while takePhoto do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 27) then
            frontCam = not frontCam;
            CellFrontCamActivate(frontCam)
        elseif IsControlJustPressed(1, 177) then
            DestroyMobilePhone()
            CellCamActivate(false, false)
            e(json.encode({url = nil}))
            takePhoto = false;
            break
        elseif IsControlJustPressed(1, 176) and not h then
            h = true;
            if Mute() then
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0,
                                   'foto', 0.5)
            end
            exports['screenshot-basic']:requestScreenshotUpload(
                "https://discord.com/api/webhooks/821528067822190662/pcAqw95niZ8MYm63xxaKwg-jHDJarz7LpMnR1RamnXm4rY1UN9Fg9rHvbF8dnCNGtxFZ",
                'files[]', function(d)
                    local i = json.decode(d)
                    local j = i.attachments[1].proxy_url;
                    DestroyMobilePhone()
                    CellCamActivate(false, false)
                    TriggerEvent('phone:abrir')
                    SendNUIMessage({
                        openSection = "fotogrande",
                        foto = j,
                        guardada = a[tablefind(a, j)]
                    })
                end)
            takePhoto = false
        end
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
    end
    Citizen.Wait(1000)
end)
function CellFrontCamActivate(k)
    return Citizen.InvokeNative(0x2491A93618B7D838, k)
end
