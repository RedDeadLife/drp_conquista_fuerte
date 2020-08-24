VORP = exports.vorp_inventory:vorp_inventoryApi()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

RegisterNetEvent("drp_asalto:startToRob")
AddEventHandler("drp_asalto:startToRob", function()
    local _source = source
    TriggerEvent('vorp:getCharacter', _source, function(user)
        local count = VORP.getItemCount(_source, "orden_presidente")

        if count >= 1 then
         
            VORP.subItem(_source,"orden_presidente", 1)
            TriggerClientEvent('drp_asalto:startTimer', _source)
            TriggerClientEvent('drp_asalto:startAnimation', _source)
        else
            TriggerClientEvent("vorp:TipBottom", _source, "Necesitas la orden presidencial", 6000)
        end     
    end)
end)

RegisterNetEvent("drp_asalto:payout")
AddEventHandler("drp_asalto:payout", function()
    TriggerEvent('vorp:getCharacter', source, function(user)
        local _source = source
        local _user = user
           TriggerEvent("vorp:addMoney",source, 0, 1500, _user)
    end)
    TriggerClientEvent("vorp:Tip",source, 'El Estado te ha enviado como recompensa: 1500$', 5000)

end)
