-- src/content/pigments.lua
-- Database pigmenti storici basato su "The Medieval Manuscript" (Charles)
-- Include tossicità, origine e uso attestato nel folio

local Pigments = {}

-- Livelli di tossicità
Pigments.TOXICITY = {
    SAFE = 0,        -- Sicuro
    MILD = 1,        -- Lievemente tossico
    MODERATE = 2,    -- Moderatamente tossico  
    HIGH = 3,        -- Altamente tossico (arsenico, mercurio, piombo)
}

-- Tier di unlock (progressione nel gioco)
Pigments.TIERS = {
    [1] = {"OCRA_ROSSA", "OCRA_GIALLA", "OCRA_BRUNA", "NERO_CARBONIOSO", 
           "NERO_FERROGALLICO", "CRETA", "GESSO", "GUSCIO_UOVO"},
    [2] = {"GUADO", "VERDERAME", "RESEDA", "CURCUMA", "CAMOMILLA", "ZAFFERANO"},
    [3] = {"ROBBIA", "BRAZILWOOD", "FOLIUM", "VERGAUT", "AZZURRITE"},
    [4] = {"MINIO", "GIALLORINO", "VERMIGLIONE", "ORCHIL"},
    [5] = {"LAPISLAZZULI", "ORO_FOGLIA", "ORO_POLVERE", "KERMES", "MALACHITE"},
    [6] = {"ORPIMENTO", "ORO_MUSIVO", "BLU_EGIZIO", "REALGAR"},
    [7] = {"PORPORA_TIRO", "BIANCO_PIOMBO"},
}

-- ══════════════════════════════════════════════════════════════════
-- DATABASE PIGMENTI
-- ══════════════════════════════════════════════════════════════════
Pigments.data = {

    -- ══════════════════════════════════════════════════════════════
    -- ROSSI E ARANCIONI
    -- ══════════════════════════════════════════════════════════════
    
    OCRA_ROSSA = {
        name = "Ocra Rossa",
        name_en = "Red Ochre",
        color = {180, 60, 40},
        tier = 1,
        toxicity = 0,
        cost = 0,
        origin = "mineral",  -- Pigmento minerale naturale (ematite/ossido di ferro)
        preparation = "Lavaggio e macinazione della terra/roccia colorata.",
        folio_use = {
            text = nil,        -- Non specificato
            dropcaps = true,   -- Sì (capital letters)
            borders = false,
            corners = false,
            miniature = nil,   -- Non specificato
        },
        effects = {},
        description = "Pigmento minerale naturale, sicuro e affidabile per lettere capitali.",
    },
    
    ROBBIA = {
        name = "Robbia",
        name_en = "Madder Lake",
        color = {160, 50, 60},
        tier = 3,
        toxicity = 0,  -- "Perfettamente sicura"
        cost = 20,
        origin = "organic_plant",  -- Rubia tinctorum
        preparation = "Radici mature (3-4 anni), essiccazione, estrazione con allume e liscivia.",
        folio_use = {
            text = nil,
            dropcaps = nil,
            borders = false,
            corners = false,
            miniature = nil,
        },
        effects = {
            safe_red = true,  -- Alternativa sicura ai rossi tossici
        },
        description = "Lacca da radici di robbia. Sicura (le radici si usano anche per il tè).",
    },
    
    MINIO = {
        name = "Minio",
        name_en = "Red Lead / Minium",
        color = {230, 90, 50},
        tier = 4,
        toxicity = 3,  -- "Highly toxic" (piombo)
        cost = 25,
        origin = "artificial",  -- Ossidi di piombo
        preparation = "Piombo esposto a vapori di aceto, poi riscaldamento.",
        folio_use = {
            text = true,       -- Possibile per rubriche
            dropcaps = true,   -- Sì
            borders = false,
            corners = false,
            miniature = true,  -- Identificato in ritratti
        },
        effects = {
            bonus_dropcaps = 1,  -- +1 slot su DROPCAPS
            origin_miniature = true,  -- Da "minium" deriva "miniatura"
        },
        description = "Rosso-arancio intenso. Da cui deriva 'miniatura'. ALTAMENTE TOSSICO.",
    },
    
    VERMIGLIONE = {
        name = "Vermiglione",
        name_en = "Vermilion / Cinnabar",
        color = {200, 40, 40},
        tier = 4,
        toxicity = 3,  -- Tossico (mercurio)
        cost = 45,
        origin = "mineral_artificial",  -- Solfuro di mercurio
        preparation = "Macinazione e miscelazione con acqua e legante.",
        folio_use = {
            text = true,       -- Red text attestato
            dropcaps = nil,
            borders = false,
            corners = false,
            miniature = true,  -- Angel's robes
        },
        effects = {
            vibrant = true,  -- Rosso molto intenso
            degradation_risk = true,  -- Può scolorire
        },
        description = "Rosso brillante da cinabro. Può degradare. TOSSICO (mercurio).",
    },
    
    REALGAR = {
        name = "Realgar",
        name_en = "Realgar",
        color = {220, 100, 40},
        tier = 6,
        toxicity = 3,  -- "Altamente pericoloso" (arsenico)
        cost = 60,
        origin = "mineral",  -- Solfuro di arsenico
        preparation = "Minerale da frantumare.",
        folio_use = {
            text = false,
            dropcaps = nil,
            borders = false,
            corners = false,
            miniature = nil,
        },
        effects = {
            risk_reward = true,  -- 1-2 = doppia macchia, 5-6 = doppio slot
            rare = true,  -- "Not widely used"
        },
        description = "Arancio arsenicale. Cennini sconsiglia il contatto. ALTAMENTE TOSSICO.",
    },
    
    KERMES = {
        name = "Kermes",
        name_en = "Kermes / Carmine",
        color = {180, 30, 50},
        tier = 5,
        toxicity = 0,  -- Lac e cochineal "perfectly safe"
        cost = 70,
        origin = "organic_insect",  -- Kermes vermilio
        preparation = "Insetti raccolti, essiccati e pestati; precipitazione per lacca.",
        folio_use = {
            text = nil,
            dropcaps = nil,
            borders = false,
            corners = false,
            miniature = nil,
        },
        effects = {
            precious_red = true,
        },
        description = "Rosso pregiato da insetti. Include lac e cocciniglia come varianti.",
    },
    
    BRAZILWOOD = {
        name = "Legno del Brasile",
        name_en = "Brazilwood / Sappanwood",
        color = {150, 40, 50},
        tier = 3,
        toxicity = 0,
        cost = 18,
        origin = "organic_plant",  -- Caesalpinia sappan
        preparation = "Ricetta con liscivia, allume e filtraggi.",
        folio_use = {
            text = nil,
            dropcaps = nil,
            borders = false,
            corners = false,
            miniature = nil,
        },
        effects = {},
        description = "Pigmento rosso da legno importato dall'Oriente.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- GIALLI
    -- ══════════════════════════════════════════════════════════════
    
    OCRA_GIALLA = {
        name = "Ocra Gialla",
        name_en = "Yellow Ochre",
        color = {200, 160, 60},
        tier = 1,
        toxicity = 0,
        cost = 0,
        origin = "mineral",  -- Terra naturale
        preparation = "Lavaggio e macinazione della terra/roccia colorata.",
        folio_use = {
            text = nil,
            dropcaps = true,  -- (capitali)
            borders = false,
            corners = false,
            miniature = nil,
        },
        effects = {},
        description = "Terra naturale, colore caldo e stabile per lettere capitali.",
    },
    
    ORPIMENTO = {
        name = "Orpimento",
        name_en = "Orpiment / Auripigmentum",
        color = {240, 200, 50},
        tier = 6,
        toxicity = 3,  -- Esplicitamente tossico (arsenico)
        cost = 55,
        origin = "mineral",  -- Solfuro di arsenico As2S3
        preparation = "Minerale da frantumare/macinare.",
        folio_use = {
            text = nil,
            dropcaps = true,  -- Monogrammi
            borders = false,
            corners = false,
            miniature = true,  -- Identificato in immagini
        },
        effects = {
            gold_substitute = true,  -- Chiamato "auripigmentum" (simile all'oro)
            risk_reward = true,
        },
        description = "Giallo dorato brillante. Pericoloso anche nel medioevo. ARSENICO.",
    },
    
    GIALLORINO = {
        name = "Giallorino",
        name_en = "Lead-Tin Yellow",
        color = {240, 210, 80},
        tier = 4,
        toxicity = 3,  -- Tossico (piombo)
        cost = 35,
        origin = "artificial",  -- Piombo + stagno
        preparation = "Riscaldando piombo e stagno.",
        folio_use = {
            text = false,
            dropcaps = nil,
            borders = true,   -- Fogliame
            corners = true,   -- Top-left decorations
            miniature = nil,
        },
        effects = {
            border_bonus = 1,  -- +1 slot su BORDERS
        },
        description = "Giallo artificiale per fogliame e decorazioni. TOSSICO (piombo).",
    },
    
    ORO_MUSIVO = {
        name = "Oro Musivo",
        name_en = "Mosaic Gold / Purpurino",
        color = {255, 190, 60},
        tier = 6,
        toxicity = 3,  -- Tossico (mercurio)
        cost = 65,
        origin = "artificial",  -- Sal ammoniac, mercurio, stagno, zolfo
        preparation = "Processo sintetico a base di calore.",
        folio_use = {
            text = false,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = true,  -- Capelli biondi su sfondo oro
        },
        effects = {
            gold_compatible = true,  -- Si abbina alla foglia d'oro
            hair_highlight = true,
        },
        description = "Giallo brillante per dettagli su sfondo oro. TOSSICO (mercurio).",
    },
    
    -- Gialli vegetali
    RESEDA = {
        name = "Reseda",
        name_en = "Weld",
        color = {200, 190, 80},
        tier = 2,
        toxicity = 0,
        cost = 5,
        origin = "organic_plant",
        preparation = "Estrazione da pianta.",
        folio_use = {
            text = nil,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {
            fugitive = true,  -- Poco lightfast
        },
        description = "Giallo vegetale brillante. Tende a sbiadire nel tempo.",
    },
    
    CURCUMA = {
        name = "Curcuma",
        name_en = "Turmeric",
        color = {220, 180, 50},
        tier = 2,
        toxicity = 0,
        cost = 8,
        origin = "organic_plant",
        preparation = "Radice essiccata e macinata.",
        folio_use = {
            text = nil,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {
            fugitive = true,
        },
        description = "Giallo speziato. Come altri gialli vegetali, poco stabile alla luce.",
    },
    
    ZAFFERANO = {
        name = "Zafferano",
        name_en = "Saffron",
        color = {255, 180, 40},
        tier = 2,
        toxicity = 0,
        cost = 40,  -- Molto costoso
        origin = "organic_plant",
        preparation = "Stigmi essiccati.",
        folio_use = {
            text = nil,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {
            precious = true,
            fugitive = true,
        },
        description = "Giallo prezioso da fiori. Costoso e fugace.",
    },
    
    CAMOMILLA = {
        name = "Camomilla",
        name_en = "Chamomile",
        color = {210, 190, 90},
        tier = 2,
        toxicity = 0,
        cost = 3,
        origin = "organic_plant",
        preparation = "Fiori essiccati.",
        folio_use = {
            text = nil,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {
            fugitive = true,
        },
        description = "Giallo tenue da fiori. Economico ma fugace.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- VERDI
    -- ══════════════════════════════════════════════════════════════
    
    VERDERAME = {
        name = "Verderame",
        name_en = "Verdigris",
        color = {80, 160, 120},
        tier = 2,
        toxicity = 1,  -- Rischi pratici, non particolarmente pericoloso
        cost = 10,
        origin = "artificial",  -- Rame(II) acetato
        preparation = "Patina verde del rame, o rame + aceto.",
        folio_use = {
            text = nil,
            dropcaps = true,  -- Iniziali A e T nel Lindisfarne
            borders = nil,
            corners = nil,
            miniature = true,  -- Il mare nell'Abingdon Apocalypse
        },
        effects = {
            corrosive = true,  -- Può danneggiare la pergamena
            on_1 = "extra_stain",
        },
        description = "Verde rame brillante. L'acido acetico può irritare. Corrosivo.",
    },
    
    VERGAUT = {
        name = "Vergaut",
        name_en = "Vergaut",
        color = {120, 150, 80},
        tier = 3,
        toxicity = 3,  -- Contiene orpimento (arsenico)
        cost = 30,
        origin = "mixture",  -- Orpimento + guado
        preparation = "Miscela di orpimento e guado.",
        folio_use = {
            text = false,
            dropcaps = true,  -- Colored initials
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {
            mixed = true,
        },
        description = "Verde da miscela. Contiene orpimento: TOSSICO (arsenico).",
    },
    
    MALACHITE = {
        name = "Malachite",
        name_en = "Malachite",
        color = {60, 140, 90},
        tier = 5,
        toxicity = 1,  -- "Mildly toxic" (rame)
        cost = 50,
        origin = "mineral",  -- Carbonato di rame
        preparation = "Macinazione, purificazione con liscivia e decantazioni.",
        folio_use = {
            text = false,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = true,  -- Hours of Isabella Stuart
        },
        effects = {
            stable_green = true,
        },
        description = "Verde minerale naturale. Lievemente tossico per il rame.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- BLU
    -- ══════════════════════════════════════════════════════════════
    
    GUADO = {
        name = "Guado",
        name_en = "Woad / Indigo",
        color = {60, 80, 140},
        tier = 2,
        toxicity = 0,
        cost = 8,
        origin = "organic_plant",  -- Isatis tinctoria
        preparation = "Foglie in acqua calda, aerazione, allume per depositare.",
        folio_use = {
            text = nil,
            dropcaps = true,  -- Monogramma INI
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {},
        description = "Blu vegetale europeo. Alternativa economica all'indaco.",
    },
    
    LAPISLAZZULI = {
        name = "Lapislazzuli",
        name_en = "Ultramarine / Lapis Lazuli",
        color = {40, 60, 170},
        tier = 5,
        toxicity = 0,  -- Pigmento non tossico
        cost = 100,
        origin = "mineral",  -- Roccia metamorfica da Badakhshan
        preparation = "Macinazione, pastiglia con gomma e cera, estrazioni in liscivia.",
        folio_use = {
            text = false,
            dropcaps = true,  -- Decorated initial Z
            borders = nil,
            corners = nil,
            miniature = true,  -- Manto della Vergine Maria
        },
        effects = {
            golden_bonus = true,  -- 6 riempie 3 slot invece di 2
            virgin_mary = true,  -- Uso iconografico
        },
        description = "Il blu più prezioso, dall'Afghanistan. Per la Vergine Maria.",
    },
    
    AZZURRITE = {
        name = "Azzurrite",
        name_en = "Azurite",
        color = {50, 100, 180},
        tier = 3,
        toxicity = 2,  -- "Moderately toxic"
        cost = 35,
        origin = "mineral",  -- Minerale a base di rame
        preparation = "Macinazione, lavaggi/decantazioni con liscivia.",
        folio_use = {
            text = false,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {
            lapis_alternative = true,
        },
        description = "Blu minerale, più economico del lapislazzuli. Moderatamente tossico.",
    },
    
    BLU_EGIZIO = {
        name = "Blu Egizio",
        name_en = "Egyptian Blue",
        color = {30, 90, 160},
        tier = 6,
        toxicity = 0,
        cost = 80,
        origin = "artificial_ancient",  -- Pigmento artificiale antico
        preparation = "Non prodotto nel medioevo, riutilizzato in casi isolati.",
        folio_use = {
            text = false,
            dropcaps = false,
            borders = false,
            corners = false,
            miniature = true,  -- Veste di Hrabanus Maurus
        },
        effects = {
            ancient = true,
            rare = true,
        },
        description = "Pigmento antico, raramente trovato in manoscritti medievali.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- PORPORA E VIOLA
    -- ══════════════════════════════════════════════════════════════
    
    PORPORA_TIRO = {
        name = "Porpora di Tiro",
        name_en = "Tyrian Purple",
        color = {130, 40, 100},
        tier = 7,
        toxicity = 0,  -- "Not toxic" (lumache commestibili)
        cost = 200,
        origin = "organic_animal",  -- Molluschi murex
        preparation = "Ghiandola ipobranchiale, bollitura prolungata.",
        folio_use = {
            text = nil,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {
            imperial = true,
            legendary = true,  -- Raramente identificata
        },
        description = "Il colore degli imperatori. Mai identificato con certezza in MSS occidentali.",
    },
    
    ORCHIL = {
        name = "Orchil",
        name_en = "Orchil / Orcein",
        color = {140, 60, 110},
        tier = 4,
        toxicity = 0,  -- "Not toxic"
        cost = 30,
        origin = "organic_lichen",  -- Lichene (orcinol)
        preparation = "Essiccazione, macinazione, fermentazione in ammoniaca/urina.",
        folio_use = {
            text = false,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = true,  -- Eagle's head in CCCC MS 197B
        },
        effects = {
            parchment_dye = true,  -- Usato per tingere pagine
        },
        description = "Viola da lichene. Usato per tingere pergamene intere.",
    },
    
    FOLIUM = {
        name = "Folium",
        name_en = "Turnsole / Folium",
        color = {150, 70, 130},
        tier = 3,
        toxicity = 0,
        cost = 25,
        origin = "organic_plant",  -- Chrozophora tinctoria
        preparation = "Schiacciatura frutti, dye assorbito in clothlets.",
        folio_use = {
            text = false,
            dropcaps = true,  -- Penflourishing around initials
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {
            penflourish = true,  -- Usato per svolazzi decorativi
        },
        description = "Viola per penflourishing attorno alle iniziali. Clothlets trasportabili.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- MARRONI
    -- ══════════════════════════════════════════════════════════════
    
    OCRA_BRUNA = {
        name = "Ocra Bruna",
        name_en = "Brown Ochre",
        color = {140, 90, 50},
        tier = 1,
        toxicity = 0,
        cost = 0,
        origin = "mineral",  -- Terra
        preparation = "Macinazione.",
        folio_use = {
            text = false,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = true,  -- Wildlife e hunting scenes
        },
        effects = {
            late_medieval = true,  -- Più usato nel tardo medioevo
        },
        description = "Marrone terrestre. Comune in scene di caccia nei Books of Hours.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- NERI
    -- ══════════════════════════════════════════════════════════════
    
    NERO_CARBONIOSO = {
        name = "Nero Carbonioso",
        name_en = "Carbon Ink / Soot Ink",
        color = {30, 30, 35},
        tier = 1,
        toxicity = 0,
        cost = 0,
        origin = "organic",  -- Fuliggine
        preparation = "Raccolta fuliggine, macinazione con acqua e gomma arabica.",
        folio_use = {
            text = true,  -- Usato per appunti
            dropcaps = nil,
            borders = false,
            corners = false,
            miniature = true,  -- Black paints
        },
        effects = {
            erasable = true,  -- Più facile da sbavare/raschiare
        },
        description = "Nero da fuliggine. Facile da produrre, meno permanente.",
    },
    
    NERO_FERROGALLICO = {
        name = "Nero Ferrogallico",
        name_en = "Iron Gall Ink",
        color = {25, 20, 30},
        tier = 1,
        toxicity = 1,  -- Può corrodere il supporto
        cost = 5,
        origin = "chemical",  -- Galle + vitriolo + gomma
        preparation = "Galle da quercia + copperas (solfato ferroso) + gomma.",
        folio_use = {
            text = true,  -- Per testi 'proper'
            dropcaps = nil,
            borders = false,
            corners = false,
            miniature = true,  -- Black paints
        },
        effects = {
            permanent = true,  -- Molto permanente
            corrosive = true,  -- Può danneggiare la pergamena
        },
        description = "Inchiostro permanente per testi ufficiali. Può corrodere se troppo ferrico.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- BIANCHI
    -- ══════════════════════════════════════════════════════════════
    
    CRETA = {
        name = "Creta",
        name_en = "Chalk",
        color = {240, 235, 220},
        tier = 1,
        toxicity = 0,
        cost = 0,
        origin = "mineral",  -- Calcio
        preparation = "Macinazione.",
        folio_use = {
            text = false,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {},
        description = "Bianco naturale da gesso/creta.",
    },
    
    GESSO = {
        name = "Gesso",
        name_en = "Gypsum",
        color = {245, 240, 230},
        tier = 1,
        toxicity = 0,
        cost = 0,
        origin = "mineral",  -- Solfato di calcio
        preparation = "Macinazione.",
        folio_use = {
            text = false,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {
            ground = true,  -- Usato come fondo per doratura
        },
        description = "Bianco per fondi e lumeggiature, base per doratura.",
    },
    
    GUSCIO_UOVO = {
        name = "Guscio d'Uovo",
        name_en = "Eggshell White",
        color = {250, 245, 235},
        tier = 1,
        toxicity = 0,
        cost = 0,
        origin = "organic",  -- Gusci d'uovo macinati
        preparation = "Macinazione fine dei gusci.",
        folio_use = {
            text = false,
            dropcaps = nil,
            borders = nil,
            corners = nil,
            miniature = nil,
        },
        effects = {},
        description = "Bianco delicato da gusci d'uovo macinati.",
    },
    
    BIANCO_PIOMBO = {
        name = "Bianco di Piombo",
        name_en = "Lead White / Cerussa",
        color = {250, 248, 245},
        tier = 7,
        toxicity = 3,  -- "Deadly poison" (Plinio, Vitruvio)
        cost = 40,
        origin = "artificial",  -- Piombo
        preparation = "Piombo esposto all'aceto, raschiatura della crosta, riscaldamento.",
        folio_use = {
            text = false,
            dropcaps = false,
            borders = false,
            corners = false,
            miniature = true,  -- Incarnati, highlighter
        },
        effects = {
            highlight = true,  -- Linee bianche per aumentare gamma tonale
            flesh_base = true, -- Base per incarnati
        },
        description = "Bianco coprente per incarnati e lumeggiature. VELENO MORTALE.",
    },

    -- ══════════════════════════════════════════════════════════════
    -- METALLI
    -- ══════════════════════════════════════════════════════════════
    
    ORO_FOGLIA = {
        name = "Foglia d'Oro",
        name_en = "Gold Leaf",
        color = {255, 200, 50},
        tier = 5,
        toxicity = 0,
        cost = 80,
        origin = "metal",  -- Oro battuto
        preparation = "Martellatura fino a 0.001 mm; applicazione su gum/glair tacky.",
        folio_use = {
            text = false,
            dropcaps = true,  -- Iniziali dorate
            borders = true,   -- Bordi dorati
            corners = true,   -- Angoli
            miniature = true, -- Sfondi divini
        },
        effects = {
            burnishable = true,
            on_6 = "remove_2_stain",
        },
        description = "Lamina sottilissima per lumeggiature divine. Richiede brunitura.",
    },
    
    ORO_POLVERE = {
        name = "Oro in Polvere",
        name_en = "Shell Gold",
        color = {255, 190, 40},
        tier = 5,
        toxicity = 0,
        cost = 90,
        origin = "metal",  -- Oro macinato
        preparation = "Oro in polvere conservato in conchiglie, miscelato con miele o gomma.",
        folio_use = {
            text = false,
            dropcaps = true,
            borders = true,
            corners = true,
            miniature = true,
        },
        effects = {
            paint_like = true,  -- Si applica come pittura
        },
        description = "Oro in polvere in conchiglie. Più facile da applicare della foglia.",
    },
    
    ARGENTO_FOGLIA = {
        name = "Foglia d'Argento",
        name_en = "Silver Leaf",
        color = {200, 200, 210},
        tier = 5,
        toxicity = 0,
        cost = 50,
        origin = "metal",
        preparation = "Come foglia d'oro.",
        folio_use = {
            text = false,
            dropcaps = true,
            borders = true,
            corners = true,
            miniature = true,  -- Elmi, spade
        },
        effects = {
            tarnish_risk = true,  -- Tende a ossidarsi e scurire
        },
        description = "Per armature e dettagli metallici. Tende a scurire nel tempo.",
    },
}

-- ══════════════════════════════════════════════════════════════════
-- FUNZIONI
-- ══════════════════════════════════════════════════════════════════

--- Ottiene pigmenti per tier
function Pigments.getByTier(tier)
    local result = {}
    local tier_names = Pigments.TIERS[tier] or {}
    for _, name in ipairs(tier_names) do
        if Pigments.data[name] then
            result[name] = Pigments.data[name]
        end
    end
    return result
end

--- Ottiene pigmenti sbloccati fino a un certo tier
function Pigments.getUnlockedUpTo(max_tier)
    local result = {}
    for tier = 1, max_tier do
        for name, data in pairs(Pigments.getByTier(tier)) do
            result[name] = data
        end
    end
    return result
end

--- Ottiene un pigmento per nome
function Pigments.get(name)
    return Pigments.data[name]
end

--- Ottiene pigmenti per livello di tossicità
function Pigments.getByToxicity(level)
    local result = {}
    for name, data in pairs(Pigments.data) do
        if data.toxicity == level then
            result[name] = data
        end
    end
    return result
end

--- Ottiene pigmenti sicuri (toxicity = 0)
function Pigments.getSafe()
    return Pigments.getByToxicity(0)
end

--- Ottiene pigmenti che possono essere usati per una parte del folio
function Pigments.getForFolioElement(element)
    -- element: "text", "dropcaps", "borders", "corners", "miniature"
    local result = {}
    for name, data in pairs(Pigments.data) do
        if data.folio_use and data.folio_use[element] then
            result[name] = data
        end
    end
    return result
end

--- Conta pigmenti totali
function Pigments.count()
    local n = 0
    for _ in pairs(Pigments.data) do
        n = n + 1
    end
    return n
end

return Pigments
