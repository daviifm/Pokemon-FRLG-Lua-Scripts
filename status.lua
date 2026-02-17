local meus_status = {
    ["Sleep"] = 1,
    ["Poison"] = 8,
    ["Burn"] = 16,
    ["Freeze"] = 32,
    ["Paralysis"] = 64,
    ["BadPoison"] = 136
}

function obter_endereco(slot)
    local endereco_base = 0x020242d4
    local tamanho_slot = 0x64

    return endereco_base + (slot - 1)*tamanho_slot
end

function aplicar_status(nome, slot)
    if slot >= 1 and slot <= 6 then
        local valor = meus_status[nome]
        local endereco = obter_endereco(slot) 
        if valor then
            emu:write32(endereco, valor)
            console:log("Sucesso! Status aplicado: " .. nome)
        else
            console:log("Erro: Não conheço o status " .. nome)
        end
    else
        console:log("Número de slot inválido")
    end
end

function sleep(slot)
    aplicar_status("Sleep", slot)
end

function poison(slot)
    aplicar_status("Poison", slot)
end

function burn(slot)
    aplicar_status("Burn", slot)
end

function freeze(slot)
    aplicar_status("Freeze", slot)
end

function paralyze(slot)
    aplicar_status("Paralysis", slot)
end

function badpoison(slot)
    aplicar_status("BadPoison", slot)
end