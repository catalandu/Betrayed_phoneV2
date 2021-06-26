local a = 0;
local b = GetHashKey("prop_amb_phone")
RegisterNetEvent('attachItemPhone')
AddEventHandler('attachItemPhone', function(c)
    if c == "tablet01" then
        b = GetHashKey("prop_cs_tablet")
    else
        b = GetHashKey("prop_amb_phone")
    end
    deletePhone()
    RequestModel(b)
    while not HasModelLoaded(b) do Citizen.Wait(1) end
    a = CreateObject(b, 1.0, 1.0, 1.0, 1, 1, 0)
    local d = GetPedBoneIndex(PlayerPedId(), 28422)
    AttachEntityToEntity(a, PlayerPedId(), d, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                         1, 1, 0, 0, 2, 1)
end)
RegisterNetEvent('destroyPropPhone')
AddEventHandler('destroyPropPhone', function(e) deletePhone() end)
function deletePhone()
    if a ~= 0 then
        Citizen.InvokeNative(0xAE3CBE5BF394C9C9,
                             Citizen.PointerValueIntInitialized(a))
        a = 0
    end
end
RegisterNetEvent('animation:sms')
AddEventHandler('animation:sms', function(e, f)
    local g = PlayerPedId()
    inPhone = e;
    RequestAnimDict("cellphone@")
    while not HasAnimDictLoaded("cellphone@") do Citizen.Wait(0) end
    if Llamado() ~= 0 then return end
    local h = false;
    if not h then
        TaskPlayAnim(g, "cellphone@", "cellphone_text_in", 2.0, 3.0, -1, 49, 0,
                     0, 0, 0)
    end
    Citizen.Wait(300)
    if inPhone then
        TriggerEvent("attachItemPhone", "phone01")
        Citizen.Wait(150)
        while inPhone do
            local i = false;
            if i then
                closeGui()
                inPhone = false
            end
            local h = false;
            if not h and
                not IsEntityPlayingAnim(g, "cellphone@",
                                        "cellphone_text_read_base", 3) and
                not IsEntityPlayingAnim(g, "cellphone@",
                                        "cellphone_swipe_screen", 3) then
                TaskPlayAnim(g, "cellphone@", "cellphone_text_read_base", 2.0,
                             3.0, -1, 49, 0, 0, 0, 0)
            end
            Citizen.Wait(1)
            if Llamado() ~= 0 then break end
        end
        local h = false;
        if not h then ClearPedTasks(PlayerPedId()) end
    else
        if f then
            TaskPlayAnim(g, "cellphone@", "cellphone_text_read_base", 2.0, 1.0,
                         5.0, 49, 0, 0, 0, 0)
        else
            local h = false;
            if not h then
                Citizen.Wait(100)
                ClearPedTasks(PlayerPedId())
                TaskPlayAnim(g, "cellphone@", "cellphone_text_out", 2.0, 1.0,
                             5.0, 49, 0, 0, 0, 0)
                Citizen.Wait(400)
                TriggerEvent("destroyPropPhone")
                Citizen.Wait(400)
                ClearPedTasks(PlayerPedId())
            else
                TriggerEvent("destroyPropPhone")
            end
        end
    end
end)
