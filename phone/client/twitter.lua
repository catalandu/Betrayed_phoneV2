local a = {}
local b = nil;
local c = true;
RegisterNUICallback('btnNotifyToggle', function(d, e)
    c = not c;
    if c then
        TriggerEvent("DoLongHudText", "Activated Popups")
    else
        TriggerEvent("DoLongHudText", "Popups Off")
    end
end)
RegisterNetEvent("phone:userTwitter")
AddEventHandler("phone:userTwitter", function(f) b = f end)
RegisterNetEvent("tryTweet")
AddEventHandler("tryTweet", function(g, h, f)
    if hasPhone() then TriggerServerEvent("AllowTweet", g, h) end
end)
RegisterNetEvent('phone:actualizaTweets')
AddEventHandler('phone:actualizaTweets', function(i, j)
    local k = b;
    a = i;
    if #a == 0 or j then return end
    if a[#a]["handle"] == k then
        SendNUIMessage({openSection = "twatter", twats = a, myhandle = k})
    end
    if appInstalada("twatter") then
        if string.find(a[#a]["message"], k) then
            if a[#a]["handle"] ~= k then
                SendNUIMessage({openSection = "newtweet"})
            end
            if phoneNotifications then
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0,
                          0, 1)
                TriggerEvent("DoLongHudText",
                             "You were just mentioned in a tweet on your phone.",
                             15)
            end
        end
        if c and not GuiEnabled() then
            SendNUIMessage({
                openSection = "notify",
                handle = a[#a]["handle"],
                message = a[#a]["message"]
            })
        end
    end
end)
function AbrirTwitter()
    local k = b;
    SendNUIMessage({openSection = "twatter", twats = a, myhandle = k})
end
RegisterNUICallback('btnTwatter', function()
    local k = b;
    if k == nil then
        TriggerServerEvent('phone:getUser')
        print("no tiene user")
    else
        SendNUIMessage({openSection = "twatter", twats = a, myhandle = k})
    end
end)
RegisterNUICallback('newTwatSubmit', function(d, e)
    local k = b;
    TriggerServerEvent('phone:twittear', k, d.twat)
end)
