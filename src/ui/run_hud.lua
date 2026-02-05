-- src/ui/run_hud.lua
-- HUD per informazioni della run (reputazione, coins, folio corrente)

local RunHUD = {}

local COLORS = {
    panel = {0.08, 0.06, 0.04, 0.85},
    text = {0.95, 0.90, 0.80},
    gold = {0.9, 0.75, 0.3},
    reputation = {0.8, 0.3, 0.3},
    highlight = {1, 1, 1},
}

--- Disegna HUD run
---@param run table Istanza Run
---@param x number Posizione X
---@param y number Posizione Y  
function RunHUD.draw(run, x, y)
    if not run then return end
    
    local status = run:getStatus()
    local padding = 10
    local line_height = 22
    local w = 180
    local h = padding * 2 + line_height * 4
    
    -- Background
    love.graphics.setColor(COLORS.panel)
    love.graphics.rectangle("fill", x, y, w, h, 6, 6)
    
    local text_x = x + padding
    local text_y = y + padding
    
    -- Fascicolo
    love.graphics.setColor(COLORS.text)
    love.graphics.print(status.fascicolo, text_x, text_y)
    text_y = text_y + line_height
    
    -- Folio progress
    love.graphics.setColor(COLORS.highlight)
    love.graphics.print("Folio: " .. status.folio, text_x, text_y)
    text_y = text_y + line_height
    
    -- Reputazione
    love.graphics.setColor(COLORS.reputation)
    love.graphics.print("♥ " .. status.reputation, text_x, text_y)
    
    -- Coins
    love.graphics.setColor(COLORS.gold)
    love.graphics.print("⚜ " .. status.coins, text_x + 70, text_y)
end

--- Disegna messaggio centrale (es. "BUST!", "COMPLETATO!")
function RunHUD.drawCenterMessage(message, subtext)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    
    -- Overlay scuro
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, w, h)
    
    -- Messaggio principale
    love.graphics.setColor(COLORS.gold)
    love.graphics.printf(message, 0, h/2 - 40, w, "center")
    
    -- Sottotesto
    if subtext then
        love.graphics.setColor(COLORS.text)
        love.graphics.printf(subtext, 0, h/2 + 10, w, "center")
    end
end

return RunHUD
