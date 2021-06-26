local a = false;
local b = config.servicios;
RegisterNUICallback('assistAlerts', function(c, d)
    if not a then
        a = true;
        for e, f in pairs(b) do
            SendNUIMessage({
                nuevoServicio = true,
                servicio = {id = e, nombre = f}
            })
        end
    end
    SendNUIMessage({openSection = "alerts"})
    d('ok')
end)
