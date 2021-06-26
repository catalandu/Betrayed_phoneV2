local a = false;
local b = false;
local c = GetEntityCoords(PlayerPedId())
local d = false;
local e = false;
local f = nil;
local g = {}
RegisterNUICallback('btnPhoneNumber', function()
    SendNUIMessage({openSection = "calls"})
    for h = 1, #g do
        SendNUIMessage({
            openSection = "addcall",
            typecall = g[h]["type"],
            phonenumber = g[h]["number"],
            contactname = g[h]["name"]
        })
    end
end)
myID = 0;
mySourceID = 0;
mySourceHoldStatus = false;
callStatus = 0;
costCount = 1;
function Llamado() return callStatus end
Citizen.CreateThread(function()
    local i = true;
    while true do
        local j = GuiEnabled()
        if j then
            SendNUIMessage({openSection = "callStatus", status = callStatus})
            DisableControlAction(0, 1, j)
            DisableControlAction(0, 2, j)
            DisableControlAction(0, 14, j)
            DisableControlAction(0, 15, j)
            DisableControlAction(0, 16, j)
            DisableControlAction(0, 17, j)
            DisableControlAction(0, 99, j)
            DisableControlAction(0, 100, j)
            DisableControlAction(0, 115, j)
            DisableControlAction(0, 116, j)
            DisableControlAction(0, 142, j)
            DisableControlAction(0, 106, j)
            if IsDisabledControlJustReleased(0, 142) then
                SendNUIMessage({type = "click"})
            end
        else
        end
        Citizen.Wait(1)
    end
end)
RegisterNUICallback('btnAnswer', function()
    closeGui()
    TriggerEvent("phone:answercall")
end)
RegisterNUICallback('btnHangup', function()
    closeGui()
    TriggerEvent("phone:hangup")
end)
RegisterNUICallback('callContact', function(k, l)
    closeGui()
    d = false;
    if callStatus == 0 and not GetDeathStatus() and hasPhone() then
        callStatus = 1;
        TriggerEvent("phone:iniciarLlamadaLoop")
        TriggerServerEvent('phone:llamarContacto', k.number, true)
    else
        TriggerEvent("DoLongHudText",
                     "It seems that you are in a call, I inherit the phone, scribe /h to restore your calls.",
                     2)
    end
    l('ok')
end)
RegisterNUICallback('callNumber', function(k)
    closeGui()
    local m = k.callnum;
    if callStatus == 0 and not GetDeathStatus() and hasPhone() then
        callStatus = 1;
        TriggerEvent("phone:iniciarLlamadaLoop")
        TriggerServerEvent('phone:llamarContacto', k.number, true)
    else
        TriggerEvent("DoLongHudText",
                     "It seems that you are in a call, I inherit the phone, scribe /h to restore your calls.",
                     2)
    end
    TriggerServerEvent("phone:llamarContacto", m, true)
end)
RegisterNetEvent('phone:comandoLlamar')
AddEventHandler('phone:comandoLlamar', function(n)
    d = false;
    if callStatus == 0 and not GetDeathStatus() and hasPhone() then
        callStatus = 1;
        TriggerEvent("phone:iniciarLlamadaLoop")
        g[#g + 1] = {["type"] = 2, ["number"] = n, ["name"] = getContactName(n)}
        TriggerServerEvent('phone:llamarContacto', n, true)
    else
        TriggerEvent("DoLongHudText",
                     "It seems that you are in a call, I inherit the phone, scribe /h to restore your calls.",
                     2)
    end
end)
RegisterNetEvent('phone:iniciarLlamadaLoop')
AddEventHandler('phone:iniciarLlamadaLoop', function()
    local o = PlayerPedId()
    RequestAnimDict("cellphone@")
    while not HasAnimDictLoaded("cellphone@") do Citizen.Wait(0) end
    local p = 0;
    costCount = 1;
    a = false;
    Citizen.Wait(200)
    ClearPedTasks(o)
    TriggerEvent("attachItemPhone", "phone01")
    TriggerEvent("DoLongHudText", "[E] Call waiting.", 10)
    if mySourceHoldStatus then
        print("The other person left you waiting")
    else
        print("The other person is not waiting")
    end
    while callStatus ~= 0 do
        local e = GetDeathStatus()
        if e then
            print("I finish the call because I'm dead?")
            endCall()
        end
        if IsEntityPlayingAnim(o, "cellphone@", "cellphone_call_listen_base", 3) and
            not IsPedRagdoll(PlayerPedId()) then
        else
            if IsPedRagdoll(PlayerPedId()) then Citizen.Wait(1000) end
            TaskPlayAnim(o, "cellphone@", "cellphone_call_listen_base", 1.0,
                         1.0, -1, 49, 0, 0, 0, 0)
        end
        Citizen.Wait(1)
        p = p + 1;
        if d then
            local q = GetDistanceBetweenCoords(c, GetEntityCoords(
                                                   PlayerPedId()), true)
            if q > 2.0 then
                TriggerEvent("DoLongHudText", "You walked too far away.", 10)
                print("I finish the call because I walked too far away?")
                endCall()
            end
        end
        if IsControlJustPressed(0, 38) then
            TriggerEvent("phone:holdToggle")
        end
        if b then
            if p == 800 then
                p = 0;
                TriggerEvent("DoLongHudText", "Call waiting.", 10)
            end
        end
        local r = GetSelectedPedWeapon(PlayerPedId())
        noweapon = GetHashKey("WEAPON_UNARMED")
        if noweapon ~= r then
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"),
                                true)
        end
    end
    ClearPedTasks(o)
    TaskPlayAnim(o, "cellphone@", "cellphone_call_out", 2.0, 2.0, 800, 49, 0, 0,
                 0, 0)
    Citizen.Wait(700)
    TriggerEvent("destroyPropPhone")
end)
RegisterNetEvent('phone:callactive')
AddEventHandler('phone:callactive', function()
    Citizen.Wait(100)
    local s = false;
    local u = false;
    while callStatus == 3 do
        local v = ""
        Citizen.Wait(1)
        if b then
            v = v .. "Is on hold | "
            if not s then
                TriggerEvent("DoLongHudText", "You have put the call on hold.",
                             888)
                s = true
            end
        else
            v = v .. "Active call | "
            if s then
                TriggerEvent("DoLongHudText", "Your call is no longer on hold.",
                             888)
                s = false
            end
        end
        if mySourceHoldStatus then
            v = v .. "You are waiting"
            if not u then
                TriggerEvent("DoLongHudText", "They left you on hold.", 2)
                u = true
            end
        else
            v = v .. "Active call"
            if u then
                TriggerEvent("DoLongHudText", "You are no longer waiting.", 2)
                u = false
            end
        end
        drawTxt(0.97, 1.46, 1.0, 1.0, 0.33, v, 255, 255, 255, 255)
    end
end)
RegisterNetEvent('phone:failedCall')
AddEventHandler('phone:failedCall', function()
    t("The call failed")
    endCall()
end)
RegisterNetEvent('phone:hangup')
AddEventHandler('phone:hangup', function(d)
    TriggerEvent("DoLongHudText", "You hung up!", 10)
    callTimer = 0;
    if d then
        t("Hang up anonymous call")
        endCall2()
    else
        t("End call")
        endCall()
    end
end)
RegisterNetEvent('phone:hangupcall')
AddEventHandler('phone:hangupcall', function()
    TriggerEvent("DoLongHudText", "You hung up!", 10)
    callTimer = 0;
    if d then
        t("Hang up anonymous call")
        endCall2()
    else
        t("End call")
        endCall()
    end
end)
RegisterNetEvent('phone:cortarLlamadoOtro')
AddEventHandler('phone:cortarLlamadoOtro', function()
    TriggerEvent("DoLongHudText", "Your call is over!", 2)
    myID = 0;
    mySourceID = 0;
    mySourceHoldStatus = false;
    callStatus = 0;
    b = false;
    PhoneSetCallChannel(0)
    f = nil
end)
RegisterNetEvent('phone:answercall')
AddEventHandler('phone:answercall', function()
    if callStatus == 2 and not GetDeathStatus() then
        answerCall()
        TriggerEvent("phone:iniciarLlamadaLoop")
        TriggerEvent("DoLongHudText", "You have answered a call.", 1)
        callTimer = 0
    else
        TriggerEvent("DoLongHudText",
                     "They are not calling you, you are injuring or it took too long.",
                     2)
    end
end)
RegisterNetEvent('phone:intentoLlamar')
AddEventHandler('phone:intentoLlamar', function(w, x)
    TriggerEvent("DoLongHudText", "You have started a call.", 1)
    myID = w;
    mySourceID = x;
    initiatingCall()
    if not d then end
end)
RegisterNetEvent('phone:InicioLlamado')
AddEventHandler('phone:InicioLlamado', function(w, x)
    myID = w;
    mySourceID = x;
    callStatus = 3;
    callTimer = 0;
    PhoneSetCallChannel(w + 120)
    f = w + 120;
    TriggerEvent("phone:callactive")
end)
RegisterNetEvent('phone:reciboLlamado')
AddEventHandler('phone:reciboLlamado', function(w, y)
    local z = getContactName(y)
    g[#g + 1] = {["type"] = 1, ["number"] = y, ["name"] = z}
    if callStatus == 0 then
        myID = 0;
        mySourceID = w;
        callStatus = 2;
        receivingCall(z)
    else
        TriggerEvent("DoLongHudText", 'You are receiving a call from ' .. z ..
                         ' but you are currently in one, sending "occupied".', 2)
    end
end)
RegisterNetEvent('phone:holdToggle')
AddEventHandler('phone:holdToggle', function()
    if myID == nil then myID = 0 end
    if myID ~= 0 then
        if not b then
            TriggerEvent("DoLongHudText", "Call waiting.", 10)
            b = true;
            PhoneSetCallChannel(0)
            TriggerServerEvent("phone:ponerEnEspera", mySourceID, true)
        else
            TriggerEvent("DoLongHudText", "It is no longer on hold.", 10)
            TriggerServerEvent("phone:ponerEnEspera", mySourceID, false)
            b = false;
            PhoneSetCallChannel(f)
        end
    else
        if mySourceID ~= 0 then
            if not b then
                TriggerEvent("DoLongHudText", "Call waiting.", 10)
                b = true;
                PhoneSetCallChannel(0)
                TriggerServerEvent("phone:ponerEnEspera", mySourceID, true)
            else
                TriggerEvent("DoLongHudText", "Is no longer on hold.", 10)
                TriggerServerEvent("phone:ponerEnEspera", mySourceID, false)
                b = false;
                PhoneSetCallChannel(f)
            end
        end
    end
end)
RegisterNetEvent('OnHold:Client')
AddEventHandler('OnHold:Client', function(A)
    mySourceHoldStatus = A;
    if mySourceHoldStatus then
        PhoneSetCallChannel(0)
        TriggerEvent("DoLongHudText", "They just put you on hold.")
    else
        if not b then PhoneSetCallChannel(f) end
        TriggerEvent("DoLongHudText", "Your call is back on the line.")
    end
end)
callTimer = 0;
function initiatingCall()
    callTimer = 8;
    TriggerEvent("DoLongHudText", "You are making a call, wait.", 1)
    while callTimer > 0 and callStatus == 1 do
        if Mute() then
            if d and callTimer < 7 then
                TriggerEvent("InteractSound_CL:PlayOnOne", "payphoneringing",
                             0.5)
            elseif not d then
                TriggerEvent("InteractSound_CL:PlayOnOne", "llamando", 0.5)
            end
        else
        end
        Citizen.Wait(2500)
        callTimer = callTimer - 1
    end
    if callStatus == 1 or callTimer == 0 then endCall() end
end
function receivingCall(z)
    callTimer = 8;
    while callTimer > 0 and callStatus == 2 do
        if hasPhone() then
            TriggerEvent("DoLongHudText", "Call from: " .. z .. " /a | /h", 10)
            if Mute() then
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0,
                                   'recibeLlamada', 0.5)
            end
        end
        Citizen.Wait(3000)
        callTimer = callTimer - 1
    end
    if callStatus ~= 3 then endCall() end
end
function answerCall()
    if mySourceID ~= 0 then
        PhoneSetCallChannel(mySourceID + 120)
        f = mySourceID + 120;
        local B = GetPlayerFromServerId(mySourceID)
        TriggerServerEvent("phone:ContestoLlamado", mySourceID)
        callStatus = 3;
        TriggerEvent("phone:callactive")
    end
end
function endCall()
    callTimer = 0;
    TriggerEvent("InteractSound_CL:PlayOnOne", "demo", 0.0)
    if mySourceID ~= 0 then
        TriggerServerEvent("phone:cortarLlamado", mySourceID)
    end
    myID = 0;
    mySourceID = 0;
    callStatus = 0;
    b = false;
    mySourceHoldStatus = false;
    d = false;
    PhoneSetCallChannel(0)
    f = nil;
    SendNUIMessage({openSection = "callStatus", status = callStatus})
end
function endCall2()
    callTimer = 0;
    if mySourceID ~= 0 then
        TriggerServerEvent("phone:cortarLlamado", mySourceID)
    end
    myID = 0;
    mySourceID = 0;
    callStatus = 0;
    b = false;
    mySourceHoldStatus = false;
    d = false;
    PhoneSetCallChannel(0)
    f = nil;
    SendNUIMessage({openSection = "callStatus", status = callStatus})
end
local C = {
    [1] = 1158960338,
    [2] = -78626473,
    [3] = 1281992692,
    [4] = -1058868155,
    [5] = -429560270,
    [6] = -2103798695,
    [7] = 295857659
}
function checkForPayPhone()
    for h = 1, #C do
        local D = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0,
                                         C[h], 0, 0, 0)
        if DoesEntityExist(D) then return true end
    end
    return false
end
RegisterNetEvent('phone:makepayphonecall')
AddEventHandler('phone:makepayphonecall', function(n)
    if not checkForPayPhone() then
        TriggerEvent("DoLongHudText", "You are not near a payphone.", 2)
        return
    end
    c = GetEntityCoords(PlayerPedId())
    d = true;
    if callStatus == 0 and not GetDeathStatus() and hasPhone() then
        callStatus = 1;
        TriggerEvent("phone:iniciarLlamadaLoop")
        TriggerEvent("InteractSound_CL:PlayOnOne", "payphonestart", 0.5)
        TriggerServerEvent('phone:llamarContacto', n, false)
    else
        TriggerEvent("DoLongHudText",
                     "It seems that you are already on a call, injured or without a phone, write /colgar to restore your calls.",
                     2)
    end
end)
function t(E) print(E) end
