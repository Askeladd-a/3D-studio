-- src/content.lua
-- Entry point unificato per tutti i database di gioco
-- Require diretto ai moduli esistenti

return {
    Pigments = require("src.content.pigments"),
    Binders = require("src.content.binders"),
    Patterns = require("src.content.patterns"),
    DiceFaces = require("src.core.dice_faces"),
}
