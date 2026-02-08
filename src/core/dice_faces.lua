-- src/core/dice_faces.lua
-- Sistema di mappatura facce del dado → pigmenti storici
--
-- Mappatura fissa (NON cambiare):
--   1 = BROWN (marroni/terre)
--   2 = GREEN (verdi)
--   3 = BLACK (inchiostri neri)
--   4 = RED (rossi)
--   5 = BLUE (blu)
--   6 = GOLD/YELLOW (gialli/oro)
--
-- BIANCO e VIOLA non sono su facce base: entrano come effetti speciali.

local Pigments = require("src.content.pigments")

local M = {}

-- ══════════════════════════════════════════════════════════════════
-- TABELLA FACCE → PIGMENTI
-- ══════════════════════════════════════════════════════════════════

M.DiceFaces = {
    [1] = {
        family = "BROWN",
        fallback = "OCRA_BRUNA",
        pigments = {
            "OCRA_BRUNA",      -- tier 1
        },
    },
    [2] = {
        family = "GREEN",
        fallback = "VERDERAME",
        pigments = {
            "VERDERAME",       -- tier 2
            "VERGAUT",         -- tier 3
            "MALACHITE",       -- tier 5
        },
    },
    [3] = {
        family = "BLACK",
        fallback = "NERO_CARBONIOSO",
        pigments = {
            "NERO_CARBONIOSO",   -- tier 1
            "NERO_FERROGALLICO", -- tier 1
        },
    },
    [4] = {
        family = "RED",
        fallback = "OCRA_ROSSA",
        pigments = {
            "OCRA_ROSSA",      -- tier 1
            "ROBBIA",          -- tier 3
            "BRAZILWOOD",      -- tier 3
            "MINIO",           -- tier 4
            "VERMIGLIONE",     -- tier 4
            "KERMES",          -- tier 5
            "REALGAR",         -- tier 6
        },
    },
    [5] = {
        family = "BLUE",
        fallback = "GUADO",
        pigments = {
            "GUADO",           -- tier 2
            "AZZURRITE",       -- tier 3
            "LAPISLAZZULI",    -- tier 5
            "BLU_EGIZIO",      -- tier 6
        },
    },
    [6] = {
        family = "GOLD",
        fallback = "OCRA_GIALLA",
        pigments = {
            "OCRA_GIALLA",     -- tier 1
            "RESEDA",          -- tier 2
            "CURCUMA",         -- tier 2
            "CAMOMILLA",       -- tier 2
            "ZAFFERANO",       -- tier 2
            "GIALLORINO",      -- tier 4
            "ORO_FOGLIA",      -- tier 5
            "ORO_POLVERE",     -- tier 5
            "ORPIMENTO",       -- tier 6
            "ORO_MUSIVO",      -- tier 6
        },
    },
}

-- ══════════════════════════════════════════════════════════════════
-- FUNZIONI
-- ══════════════════════════════════════════════════════════════════

--- Ottiene il colore RGB di un pigmento dal database
---@param pigmentName string Nome esatto del pigmento (es. "OCRA_ROSSA")
---@return table {r, g, b} o nil se non trovato
function M.getDieColor(pigmentName)
    local pigment = Pigments.get(pigmentName)
    if pigment and pigment.color then
        return pigment.color
    end
    -- Fallback: grigio neutro se pigmento non trovato
    return {128, 128, 128}
end

--- Ottiene il nome della famiglia colore per una faccia
---@param face number 1-6
---@return string Nome famiglia (BROWN, GREEN, BLACK, RED, BLUE, GOLD)
function M.getFamilyName(face)
    local faceData = M.DiceFaces[face]
    return faceData and faceData.family or "UNKNOWN"
end

--- Filtra pigmenti disponibili per una faccia dato il maxTier sbloccato
---@param face number 1-6
---@param maxTier number Tier massimo sbloccato (1-7)
---@return table Lista di {name, tier, weight} filtrati
local function getAvailablePigments(face, maxTier)
    local faceData = M.DiceFaces[face]
    if not faceData then
        return {}
    end
    
    local available = {}
    for _, pigmentName in ipairs(faceData.pigments) do
        local pigment = Pigments.get(pigmentName)
        if pigment and pigment.tier <= maxTier then
            -- Peso inversamente proporzionale al tier (favorisce tier bassi)
            local weight = 1 / pigment.tier
            table.insert(available, {
                name = pigmentName,
                tier = pigment.tier,
                weight = weight,
            })
        end
    end
    
    return available
end

--- Seleziona un pigmento casuale pesato per una faccia
---@param face number 1-6
---@param maxTier number Tier massimo sbloccato (1-7)
---@param rng? function Funzione RNG opzionale (default: math.random)
---@return string Nome del pigmento selezionato
function M.pickPigmentForFace(face, maxTier, rng)
    rng = rng or math.random
    maxTier = maxTier or 7
    
    local faceData = M.DiceFaces[face]
    if not faceData then
        -- Faccia invalida: fallback generico
        return "OCRA_GIALLA"
    end
    
    local available = getAvailablePigments(face, maxTier)
    
    -- Se nessun pigmento disponibile, usa fallback
    if #available == 0 then
        return faceData.fallback
    end
    
    -- Se un solo pigmento, restituiscilo direttamente
    if #available == 1 then
        return available[1].name
    end
    
    -- Selezione pesata
    local totalWeight = 0
    for _, p in ipairs(available) do
        totalWeight = totalWeight + p.weight
    end
    
    local roll = rng() * totalWeight
    local cumulative = 0
    
    for _, p in ipairs(available) do
        cumulative = cumulative + p.weight
        if roll <= cumulative then
            return p.name
        end
    end
    
    -- Safety fallback
    return available[#available].name
end

--- Genera un set di pigmenti per tutti i dadi di un roll (es. 4d6)
---@param numDice number Numero di dadi
---@param values table Array di valori (1-6) per ogni dado
---@param maxTier number Tier massimo sbloccato
---@param seed? number Seed opzionale per RNG deterministico
---@return table Array di pigmentName per ogni dado
function M.pickPigmentsForRoll(numDice, values, maxTier, seed)
    local rng
    if seed then
        -- RNG deterministico basato su seed
        local state = seed
        rng = function()
            state = (state * 1103515245 + 12345) % 2147483648
            return state / 2147483648
        end
    else
        rng = math.random
    end
    
    local pigments = {}
    for i = 1, numDice do
        local face = values[i] or 1
        pigments[i] = M.pickPigmentForFace(face, maxTier, rng)
    end
    
    return pigments
end

--- Ottiene tutti i pigmenti di una famiglia (per UI/inventario)
---@param face number 1-6
---@return table Array di pigmentName
function M.getAllPigmentsForFace(face)
    local faceData = M.DiceFaces[face]
    if not faceData then
        return {}
    end
    return faceData.pigments
end

--- Debug: stampa info su una faccia
---@param face number 1-6
---@param maxTier number Tier massimo sbloccato
function M.debugPrintFace(face, maxTier)
    local faceData = M.DiceFaces[face]
    if not faceData then
        log("Faccia invalida:", face)
        return
    end
    
    log(string.format("=== Faccia %d (%s) ===", face, faceData.family))
    log("Fallback:", faceData.fallback)
    log("Pigmenti disponibili (maxTier=" .. maxTier .. "):")
    
    local available = getAvailablePigments(face, maxTier)
    for _, p in ipairs(available) do
        local pigment = Pigments.get(p.name)
        local color = pigment and pigment.color or {0,0,0}
        log(string.format("  - %s (tier %d, peso %.2f) RGB(%d,%d,%d)",
            p.name, p.tier, p.weight, color[1], color[2], color[3]))
    end
end

return M
