function obter_endereco(slot)
    local endereco_base = 0x02024284
    local tamanho_slot = 0x64

    return endereco_base + (slot - 1)*tamanho_slot
end

function pre_damage(slot, valor)
    if slot >= 1 and slot <= 6 then
        local endereco = obter_endereco(slot)

        local end_hp_atual = endereco + 0x56
        local end_hp_max = endereco + 0x58

        local hp_max = emu:read16(end_hp_max)
        if valor > 0 and valor <= hp_max then
            emu:write16(end_hp_atual, valor)
            console:log("HP alterado para: " .. valor)
        else
            console:log("Erro, não foi possível alterar o HP")
        end
    end
end

