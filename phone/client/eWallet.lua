ESX = nil;
local a = {}
local b = ""
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(c) ESX = c end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().accounts == nil or ESX.GetPlayerData().job == nil or
        ESX.GetPlayerData().money == nil do Citizen.Wait(10) end
    a = ESX.GetPlayerData()
    ESX.TriggerServerCallback('esx_license:getLicenses', function(d)
        for e, f in pairs(d) do b = b .. "<b>" .. f.label .. "</b><br>" end
    end, GetPlayerServerId(PlayerId()))
end)
RegisterNUICallback('btnAccount', function()
    local g = ESX.GetPlayerData()
    local h = g.accounts;
    local i = g.job;
    local j = h[tablefindKeyVal(h, "name", "bank")].money;
    local k = h[tablefindKeyVal(h, "name", "black_money")].money;
    local l = i.label .. " - " .. i.grade_label;
    local m = b;
    local n =
        "<div class='accountbubble'>  <div class='h6'>Accounts</div> <b>Bank</b>: $" ..
            j .. " <br><br> <b>Dirty</b>: $" .. k ..
            " </div> <div class='accountbubble'>  <div class='h6'>Work related</div> <b> Job</b>: " ..
            l ..
            "<br></div> <div class='accountbubble'><div class='h6'>Licenses</div>" ..
            m .. " </div>"
    SendNUIMessage({openSection = "account", InfoString = n})
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(i) a.job = i end)
function miTrabajo() return ESX.GetPlayerData().job.name end
