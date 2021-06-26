ESX=nil;
Citizen.CreateThread(
  function()
      while ESX==nil do 
        TriggerEvent('esx:getSharedObject',function(a)ESX=a end)
        Citizen.Wait(100)
      end 
  end
)
function GetDeathStatus()
    return IsPlayerDead(PlayerPedId())
end


function loading()
    SendNUIMessage({openSection="error",textmessage="Loading please wait."})
end;

function doTimeUpdate()
    local c,d=GetClockHours(),GetClockMinutes()
    local e=c.." : "..d
    SendNUIMessage({openSection="timeheader",timestamp=e})
end;

function tablefind(f,g)
    for h,i in pairs(f)do 
        if i==g then 
            return h 
        end 
    end 
end;

function hasPhone()
    return true
end

function tablefindKeyVal(f,j,k)
    for h,i in pairs(f)do 
        if i~=nil and i[j]~=nil and i[j]==k then 
            return h 
        end 
    end 
end;

function drawTxt(l,m,n,o,p,q,r,s,t,u)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(p,p)
    SetTextColour(r,s,t,u)
    SetTextDropShadow(0,0,0,0,255)
    SetTextEdge(2,0,0,0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(q)
    DrawText(l-n/2,m-o/2+0.005)
end
