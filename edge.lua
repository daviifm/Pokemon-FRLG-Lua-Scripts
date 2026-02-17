function obter_endereco(slot)
    local endereco_base = 0x02024284
    local tamanho_slot = 0x64

    return endereco_base + (slot - 1)*tamanho_slot
end

local posicoes_G = {
    -- 0 a 5: G é o primeiro
    0, 0, 0, 0, 0, 0, 
    
    -- 6 e 7
    1, 1, 
    
    -- 8 e 9
    2, 3,

    -- 10 a 17
    2, 3, 1, 1, 2, 3, 2, 3,

    -- 18 a 23
    1, 1, 2, 3, 2, 3
}

curve = {
3,3,3,3,3,3,3,3,3,0, 0,0,0,0,0,3,3,3,0,0, 0,0,0,0,0,0,0,0,3,3, 3,3,3,3,4,4,0,0,4,4, 0,0,3,3,3,0,0,0,0,0,
0,0,0,0,0,0,0,5,5,3, 3,3,3,3,3,3,3,3,3,3, 3,5,5,3,3,3,0,0,0,0, 0,0,0,0,0,0,0,0,0,5, 5,4,4,4,0,0,0,0,0,0,
0,5,5,0,0,0,0,0,0,0, 5,5,4,0,0,0,0,0,0,5, 5,0,0,0,0,0,5,5,5,5, 4,0,0,0,0,0,0,0,0,0, 0,4,5,5,5,5,5,5,5,5,
3,3,3,3,3,3,3,3,3,3, 0,0,0,0,4,4,4,4,0,5, 5,0,4,4,4,4,0,0,3,3, 3,3,4,4,0,3,3,3,3,4, 3,3,0,0,0,0,0,0,0,4,
0,0,0,0,0,0,3,0,4,4, 0,0,3,5,3,0,0,0,0,5, 5,4,5,5,5,5,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 5,4,5,5,5,5,5,5,5,5,
3,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,3,3,3,3, 3,3,3,3,3,0,0,0,0,0, 0,0,0,0,3,3,3,3,3,3,
1,1,1,4,4,2,2,4,0,0, 0,0,2,2,4,4,3,0,0,0, 0,5,0,0,4,2,2,1,1,5, 5,3,3,3,2,2,5,5,0,0, 3,3,3,3,3,0,0,4,4,4,
4,4,0,0,4,0,0,2,2,0, 1,1,3,5,5,5,1,1,5,3, 3,3,2,2,2,3,4,4,1,2, 5,5,5,5,0,1,2,1,1,1, 1,5,5,5,5,5,5,5,5,5,
5,5,5,5,5,5,5,5,5,5, 4}

function obter_ordem(slot)
    local endereco = obter_endereco(slot)
    local end_pid = endereco + 0x00
    local num_pid = emu:read32(end_pid)
    pid = num_pid % 24
    return pid
    
end

function obter_endereco_exp(slot)
    local endereco_base = obter_endereco(slot)
    local pid = emu:read32(endereco_base) -- O PID fica no offset 0
    
    
    local resto = pid % 24
    
    
    local posicao_bloco = posicoes_G[resto + 1]
    
    local endereco_exp = endereco_base + 32 + (posicao_bloco * 12) + 4
    
    return endereco_exp
end

-- Rigred copy
function slowCurve(n)
	return math.floor((5*(n^3))/4)
end
function fastCurve(n)
	return math.floor((4*(n^3))/5)
end
function medfastCurve(n)
	return n^3
end
function medslowCurve(n)
	return math.floor((6 * (n)^3) / 5) - (15 * (n)^2) + (100 * n) - 140
end
function erraticCurve(n)
	if (n<=50) then
		return math.floor(((100 - n)*n^3)/50)
	end
	if (n<=68) then
		return math.floor(((150 - n)*n^3)/50)
	end
	if (n<=98) then
		return math.floor(math.floor((1911 - 10 * n) / 3) * n^23 / 500)
	end
	return math.floor((160 - n) * n^3 / 100)
end
function flutuatingCurve(n)
	if (n<15) then
	  return math.floor((math.floor((n + 1) / 3) + 24) * n^3 / 50)
	end
	if (n<=36) then
		return math.floor((n + 14) * n^3 / 50)
	end
	return math.floor((math.floor(n / 2) + 32) * n^3 / 50)
end

function expRequired(species,level)
	expCurve = curve[species]
	if (expCurve == 0) then return medfastCurve(level) end
	if (expCurve == 1) then return erraticCurve(level) end
	if (expCurve == 2) then return flutuatingCurve(level) end
	if (expCurve == 3) then return medslowCurve(level) end
	if (expCurve == 4) then return fastCurve(level) end
	if (expCurve == 5) then return slowCurve(level) end
end

function calcLevel(exp, species)
	level = 1
	while (exp>=expRequired(species,level+1)) do
		level=level+1
	end
	return level
end
-- Rigred Copy fim

function calcular_checksum(endereco_base, chave)
    local soma = 0
    
    -- Ler 12 blocos de 32 bits (total 48 bytes)
    for i = 0, 11 do
        -- 1. Ler o bloco de 32 bits
        local valor_encriptado = emu:read32(endereco_base + 32 + (i * 4))
        
        -- 2. Descriptografar (Limpar o dado)
        local valor_decifrado = valor_encriptado ~ chave
        
        -- 3. Separar em duas partes de 16 bits (Alta e Baixa)
        local parte_baixa = valor_decifrado & 0xFFFF
        local parte_alta = (valor_decifrado >> 16) & 0xFFFF
        
        -- 4. Somar
        soma = soma + parte_baixa + parte_alta
    end
    
    return soma % 0x10000
end

function edge(slot)
    local endereco_exp = obter_endereco_exp(slot)
    local endereco_base = obter_endereco(slot)
    
    local pid = emu:read32(endereco_base)
    local otid = emu:read32(endereco_base + 4) -- O OTID fica logo após o PID

    -- XOR
    local chave = pid ~ otid

    -- Lemos os 32 bits onde estão Espécie e Item juntos
    local dado_embaralhado = emu:read32(endereco_exp - 4)
    
    -- Aplicamos a chave para "limpar" o dado
    local dado_limpo = dado_embaralhado ~ chave

    -- O ID da espécie são os primeiros 16 bits desse dado limpo
    local id_especie = dado_limpo & 0xFFFF

    local id_especie = dado_limpo & 0xFFFF
    local nivel = emu:read8(endereco_base + 0x54)

    console:log("Lendo dados -> Espécie ID: " .. id_especie .. " | Nível: " .. nivel)

    local exp_alvo = expRequired(id_especie, nivel + 1)
    local exp_edge = exp_alvo - 1

    emu:write32(endereco_exp, chave ~ exp_edge)
    local novo_checksum = calcular_checksum(endereco_base, chave)
    
    emu:write16(endereco_base + 0x1C, novo_checksum)

    console:log("Sucesso! Pokémon preparado para o nível " .. nivel + 1)
    
end

function edge_party()
    local end_party_size = 0x02024029
    local party_size = emu:read8(end_party_size)
    for i = 1, party_size do
        edge(i)
    end
    console:log("Party edged!")
    
end
