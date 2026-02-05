-- src/content/binders.lua
-- Database leganti/medium storici basato su "The Medieval Manuscript" (Charles)
-- Include leganti per pittura, inchiostri e doratura

local Binders = {}

-- ══════════════════════════════════════════════════════════════════
-- DATABASE LEGANTI
-- ══════════════════════════════════════════════════════════════════
Binders.data = {

    -- ══════════════════════════════════════════════════════════════
    -- LEGANTI PRINCIPALI PER PITTURA
    -- ══════════════════════════════════════════════════════════════
    
    GOMMA_ARABICA = {
        name = "Gomma Arabica",
        name_en = "Gum Arabic",
        tier = 1,
        cost = 0,
        origin = "vegetable_gum",  -- Resina di acacia
        function_desc = "Legante per pigmenti e inchiostri; migliora adesione e fluidità.",
        preparation = "Raccolta e uso in soluzione acquosa.",
        uses = {"pigments", "inks", "shell_gold"},
        risks = nil,  -- Nessun rischio discusso
        effects = {},
        description = "Legante standard per acquerelli medievali. Universale e sicuro.",
    },
    
    MIELE = {
        name = "Miele",
        name_en = "Honey",
        tier = 2,
        cost = 15,
        origin = "organic",
        function_desc = "Adesivo per shell gold; legante generale per pittura.",
        preparation = "Usato direttamente.",
        uses = {"pigments", "shell_gold"},
        risks = nil,
        effects = {
            flexible = true,  -- Mantiene il colore flessibile
            on_stain = "reduce",  -- Riduce impatto macchia
        },
        description = "Mantiene il colore flessibile. Usato per oro in polvere.",
    },
    
    GLAIR = {
        name = "Glair",
        name_en = "Egg White / Glair",
        tier = 1,
        cost = 5,
        origin = "organic_egg",
        function_desc = "Adesivo per foglia d'oro; componente del gesso; legante per pigmenti.",
        preparation = "Montare l'albume, lasciar riposare, usare il liquido.",
        uses = {"gold_leaf", "gesso", "pigments"},
        risks = "foam_bubbles",  -- Attenzione a schiuma e bolle
        effects = {
            shine = true,  -- Aspetto lucido
            gold_adhesion = true,
        },
        description = "Albume montato. Dona lucentezza. Base per doratura.",
    },
    
    TUORLO = {
        name = "Tuorlo d'Uovo",
        name_en = "Egg Yolk / Egg Tempera",
        tier = 1,
        cost = 8,
        origin = "organic_egg",
        function_desc = "Legante proteico-lipidico per fissare pigmenti.",
        preparation = "Separare dal bianco, diluire con acqua.",
        uses = {"pigments"},
        risks = nil,
        effects = {
            durability = 1,  -- Colori più resistenti
            matte_finish = true,
        },
        description = "Tempera all'uovo. Colori opachi ma resistenti.",
    },
    
    GOMMA_VEGETALE = {
        name = "Gomma Vegetale",
        name_en = "Plant Gum",
        tier = 1,
        cost = 3,
        origin = "vegetable_gum",
        function_desc = "Adesivo per foglia d'oro insieme a glair.",
        preparation = "In soluzione.",
        uses = {"gold_leaf"},
        risks = nil,
        effects = {},
        description = "Gomma generica per applicazione foglia d'oro.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- COLLE ANIMALI
    -- ══════════════════════════════════════════════════════════════
    
    COLLA_PESCE = {
        name = "Colla di Pesce",
        name_en = "Fish Glue / Isinglass",
        tier = 2,
        cost = 20,
        origin = "animal",
        function_desc = "Componente adesivo del gesso per doratura.",
        preparation = "Estrazione da vesciche natatorie.",
        uses = {"gesso", "gold_leaf"},
        risks = nil,
        effects = {
            gold_adhesion = true,
            strong_bond = true,
        },
        description = "Ideale per applicare foglia d'oro. Legame forte.",
    },
    
    COLLA_CONIGLIO = {
        name = "Colla di Coniglio",
        name_en = "Rabbit Skin Glue",
        tier = 3,
        cost = 25,
        origin = "animal",
        function_desc = "Componente adesivo del gesso per doratura.",
        preparation = "Estrazione da pelli.",
        uses = {"gesso", "gold_leaf", "heavy_pigments"},
        risks = nil,
        effects = {
            strong_bond = true,
        },
        description = "Legante forte per pigmenti pesanti e doratura.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- GESSO PER DORATURA
    -- ══════════════════════════════════════════════════════════════
    
    GESSO_DORATURA = {
        name = "Gesso per Doratura",
        name_en = "Gilding Gesso / Raised Ground",
        tier = 3,
        cost = 30,
        origin = "compound",  -- Plaster of Paris + adesivi
        function_desc = "Base in rilievo per foglia d'oro; aumenta riflessione.",
        preparation = "Plaster of Paris + glair/gum/colla + pigmento; riposo overnight.",
        uses = {"gold_leaf_raised"},
        components = {"plaster_of_paris", "glair", "gum_arabic", "fish_glue", 
                      "rabbit_glue", "sugar", "garlic_juice", "pigment"},
        risks = "reactivation",  -- Richiede umidificazione col respiro
        effects = {
            raised_gold = true,  -- Oro in rilievo
            reflection_boost = true,
        },
        description = "Cuscino rialzato per oro. Riattivare con il respiro ('heavy breathing').",
    },

    -- ══════════════════════════════════════════════════════════════
    -- ADDITIVI E AUSILIARI
    -- ══════════════════════════════════════════════════════════════
    
    ZUCCHERO = {
        name = "Zucchero",
        name_en = "Sugar",
        tier = 2,
        cost = 10,
        origin = "organic",
        function_desc = "Ingrediente adesivo nel gesso per doratura.",
        preparation = "Aggiunto al gesso.",
        uses = {"gesso"},
        risks = nil,
        effects = {
            adhesion_boost = true,
        },
        description = "Aumenta adesività del gesso per doratura.",
    },
    
    SUCCO_AGLIO = {
        name = "Succo d'Aglio",
        name_en = "Garlic Juice",
        tier = 2,
        cost = 5,
        origin = "organic",
        function_desc = "Ingrediente adesivo nel gesso per doratura.",
        preparation = "Spremitura dell'aglio.",
        uses = {"gesso"},
        risks = "odor",  -- Odore forte
        effects = {
            adhesion_boost = true,
        },
        description = "Aumenta adesività del gesso. Odore caratteristico.",
    },
    
    CERUME = {
        name = "Cerume",
        name_en = "Earwax",
        tier = 1,
        cost = 0,  -- Gratuito!
        origin = "organic",
        function_desc = "Antischiuma: rompe la schiuma nel glair/gesso.",
        preparation = "Usato direttamente.",
        uses = {"glair", "gesso"},
        risks = nil,
        effects = {
            antifoam = true,
        },
        description = "Segreto pratico per eliminare schiuma dal glair. Gratuito!",
    },
    
    OLIO_GAROFANO = {
        name = "Olio di Garofano",
        name_en = "Clove Oil",
        tier = 3,
        cost = 15,
        origin = "organic_plant",
        function_desc = "Antischiuma alternativo al cerume.",
        preparation = "Estrazione da chiodi di garofano.",
        uses = {"glair", "gesso"},
        risks = nil,
        effects = {
            antifoam = true,
            fragrant = true,
        },
        description = "Alternativa profumata al cerume per eliminare schiuma.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- AUSILIARI PER ESTRAZIONE (non leganti finali)
    -- ══════════════════════════════════════════════════════════════
    
    LISCIVIA = {
        name = "Liscivia",
        name_en = "Lye",
        tier = 3,
        cost = 12,
        origin = "chemical",  -- Cenere + acqua
        function_desc = "Usata per estrarre pigmenti (lapis, madder, ecc.).",
        preparation = "Cenere di legno in acqua.",
        uses = {"pigment_extraction", "lapis_preparation"},
        risks = "skin_irritation",  -- Può provocare screpolature
        effects = {
            reactive = true,
            risk = 1,
        },
        description = "Alcali per estrazione pigmenti. Può irritare la pelle.",
    },
    
    CERA = {
        name = "Cera",
        name_en = "Wax",
        tier = 2,
        cost = 10,
        origin = "organic",
        function_desc = "Medium ausiliario per estrazione ultramarino.",
        preparation = "Pastiglia con gomma per separare blu in liscivia.",
        uses = {"lapis_preparation"},
        risks = nil,
        effects = {},
        description = "Usata nella preparazione del lapislazzuli, non come legante finale.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- AUSILIARI PER SCRITTURA
    -- ══════════════════════════════════════════════════════════════
    
    SANDARACA = {
        name = "Gomma Sandaraca",
        name_en = "Gum Sandarac",
        tier = 2,
        cost = 8,
        origin = "vegetable_resin",
        function_desc = "Polvere assorbente per scrittura; tratti più netti.",
        preparation = "Spolverata sulla pergamena prima della scrittura.",
        uses = {"writing_preparation"},
        risks = nil,
        effects = {
            ink_absorption = true,
            clean_lines = true,
        },
        description = "Spolverata sulla pergamena per assorbire inchiostro e tratti netti.",
    },
    
    ACETO = {
        name = "Aceto",
        name_en = "Vinegar",
        tier = 2,
        cost = 8,
        origin = "organic",
        function_desc = "Conservante, attivatore per verderame, componente in produzioni.",
        preparation = "Fermentazione.",
        uses = {"verdigris_production", "lead_white_production", "preservation"},
        risks = nil,
        effects = {
            preservative = true,
            verdigris_boost = true,
        },
        description = "Conservante e attivatore. Fondamentale per verderame e bianco piombo.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- INCHIOSTRI (come formule complete)
    -- ══════════════════════════════════════════════════════════════
    
    VITRIOLO = {
        name = "Vitriolo",
        name_en = "Vitriol / Copperas",
        tier = 2,
        cost = 10,
        origin = "mineral",  -- Solfato ferroso
        function_desc = "Componente dell'inchiostro ferrogallico.",
        preparation = "Minerale cristallino.",
        uses = {"iron_gall_ink"},
        risks = "corrosion",  -- Alto ferro può corrodere pergamena
        effects = {
            permanence = true,
        },
        description = "Solfato ferroso per inchiostro nero permanente. Dosaggio critico.",
    },
    
    GALLA = {
        name = "Galla di Quercia",
        name_en = "Oak Gall / Gallnut",
        tier = 1,
        cost = 5,
        origin = "organic",  -- Escrescenze su quercia
        function_desc = "Componente dell'inchiostro ferrogallico.",
        preparation = "Raccolta, essiccazione, macinazione, macerazione.",
        uses = {"iron_gall_ink"},
        risks = nil,
        effects = {},
        description = "Tannini da galle per inchiostro nero. Base del ferro-gallico.",
    },
}

-- ══════════════════════════════════════════════════════════════════
-- FUNZIONI
-- ══════════════════════════════════════════════════════════════════

--- Ottiene legante per nome
function Binders.get(name)
    return Binders.data[name]
end

--- Ottiene leganti per tier
function Binders.getByTier(tier)
    local result = {}
    for name, data in pairs(Binders.data) do
        if data.tier == tier then
            result[name] = data
        end
    end
    return result
end

--- Ottiene leganti per uso specifico
function Binders.getByUse(use)
    local result = {}
    for name, data in pairs(Binders.data) do
        if data.uses then
            for _, u in ipairs(data.uses) do
                if u == use then
                    result[name] = data
                    break
                end
            end
        end
    end
    return result
end

--- Conta leganti totali
function Binders.count()
    local n = 0
    for _ in pairs(Binders.data) do
        n = n + 1
    end
    return n
end

--- Ottiene leganti per doratura
function Binders.getForGilding()
    local result = {}
    for name, data in pairs(Binders.data) do
        if data.uses then
            for _, u in ipairs(data.uses) do
                if u == "gold_leaf" or u == "gesso" or u == "shell_gold" or u == "gold_leaf_raised" then
                    result[name] = data
                    break
                end
            end
        end
    end
    return result
end

return Binders
