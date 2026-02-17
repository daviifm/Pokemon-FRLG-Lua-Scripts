# Pokemon-FRLG-Lua-Scripts
Coleção de scripts em Lua desenvolvidos para Pokémon Fire Red e Leaf Green (GBA), com foco em facilitar e melhorar a experiência em desafios Nuzlocke.

Esses scripts foram criados para uso em emuladores compatíveis com execução de scripts Lua (como BizHawk, mGBA com suporte, etc.), mas principalmente com foco no mGBA.

Baseado nos scripts do Rigoroud Red.

# 📌 Funções Principais

---

# 📤 `exportall()`

## 🎯 O que faz

Exporta todos os Pokémon da party (slots 1–6) para o console do emulador.

Mostra:

- Espécie (ID)
    
- Ability
    
- Level
    
- Nature
    
- Item
    
- IVs
    
- Golpes
    

---

## 🧪 Sintaxe correta

`exportall()`

Sem parâmetros.

---

# 🩸 `pre_damage(slot, valor)`

## 🎯 O que faz

Define manualmente o HP atual de um Pokémon da party.

---

## 🧪 Sintaxe correta

`pre_damage(slot, novoHP)`

### 📌 Exemplos

`pre_damage(1, 1) pre_damage(3, 25)`

---

## ⚠️ Regras

- `slot` → número entre 1 e 6
    
- `valor` → número maior que 0 e menor ou igual ao HP máximo
    

---

# ⚔️ `edge(slot)`

## 🎯 O que faz

Define a experiência do Pokémon para ficar a **1 ponto de EXP do próximo nível**.

---

## 🧪 Sintaxe correta

`edge(slot)`

### 📌 Exemplos

`edge(1) edge(4)`

---

# 👥 `edge_party()`

## 🎯 O que faz

Aplica `edge()` automaticamente em todos os Pokémon da party.

---

## 🧪 Sintaxe correta

`edge_party()`

---

# ☠️ `aplicar_status(nome, slot)`

## 🎯 O que faz

Aplica um status negativo manualmente no Pokémon escolhido.

---

## 🧪 Sintaxe correta

`aplicar_status("NomeDoStatus", slot)`

---

## 📌 Status válidos

- `"Sleep"`
    
- `"Poison"`
    
- `"Burn"`
    
- `"Freeze"`
    
- `"Paralysis"`
    
- `"BadPoison"`
    

---

## 📌 Exemplos

`aplicar_status("Burn", 1) aplicar_status("Poison", 3) aplicar_status("Sleep", 2)`

---

## ⚠️ Possíveis erros

- Status inválido → `Erro: Não conheço o status`
    
- Slot inválido → `Número de slot inválido`
    

---

# 💤 Atalhos de Status

São versões simplificadas de `aplicar_status`.

---

## 😴 Sleep

`sleep(slot)`

---

## ☠️ Poison

`poison(slot)`

---

## 🔥 Burn

`burn(slot)`

---

## ❄️ Freeze

`freeze(slot)`

---

## ⚡ Paralysis

`paralyze(slot)`

---

## 🧪 Toxic

`badpoison(slot)`
