-- src/scenes/scriptorium.lua
-- Scena principale: lo scriptorium con leggio, pergamena e dadi

local Run = require("src.game.run")
local FolioDisplay = require("src.ui.folio_display")
local RunHUD = require("src.ui.run_hud")
local DiceResults = require("src.ui.dice_results")

local Scriptorium = {
    run = nil,
    dice_results = {},
    state = "waiting",  -- waiting, rolling, interpreting, resolved
    message = nil,
    message_timer = 0,
}

--- Entra nella scena
function Scriptorium:enter(fascicolo_type, seed)
    self.run = Run.new(fascicolo_type or "BIFOLIO", seed)
    self.dice_results = {}
    self.state = "waiting"
    self.message = nil
    self.message_timer = 0
    
    print("[Scriptorium] Nuova run iniziata: " .. self.run.fascicolo)
end

--- Esce dalla scena
function Scriptorium:exit()
    self.run = nil
end

--- Update
function Scriptorium:update(dt)
    -- Timer messaggi
    if self.message_timer > 0 then
        self.message_timer = self.message_timer - dt
        if self.message_timer <= 0 then
            self.message = nil
            -- Procedi dopo messaggio
            if self.run.current_folio.busted or self.run.current_folio.completed then
                local success, result = self.run:nextFolio()
                if result == "victory" then
                    self:showMessage("VITTORIA!", 5)
                elseif result == "game_over" then
                    self:showMessage("GAME OVER", 5)
                end
            end
        end
    end
end

--- Draw
function Scriptorium:draw()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    
    -- Background scriptorium (placeholder)
    love.graphics.setColor(0.15, 0.12, 0.10)
    love.graphics.rectangle("fill", 0, 0, w, h)
    
    -- Disegna leggio/pergamena (placeholder centrale)
    self:drawLectern(w/2 - 150, h/2 - 200, 300, 350)
    
    if self.run then
        -- HUD run (top-left)
        RunHUD.draw(self.run, 10, 10)
        
        -- Folio display (right side)
        FolioDisplay.draw(self.run.current_folio, w - 220, 10, 210, 320)
        
        -- Risultati dadi (bottom center)
        if #self.dice_results > 0 then
            local results_w = #self.dice_results * 60 + 20
            DiceResults.draw(self.dice_results, w/2 - results_w/2, h - 120)
        end
        
        -- Istruzioni
        love.graphics.setColor(0.7, 0.65, 0.55)
        love.graphics.printf(
            self:getInstructions(),
            0, h - 30, w, "center"
        )
    end
    
    -- Messaggio centrale
    if self.message then
        RunHUD.drawCenterMessage(self.message.text, self.message.subtext)
    end
end

--- Disegna il leggio con pergamena (placeholder)
function Scriptorium:drawLectern(x, y, w, h)
    -- Leggio (legno)
    love.graphics.setColor(0.35, 0.22, 0.12)
    love.graphics.rectangle("fill", x - 20, y + h - 40, w + 40, 60, 4, 4)
    
    -- Supporto
    love.graphics.setColor(0.30, 0.18, 0.10)
    love.graphics.polygon("fill", 
        x + w/2 - 30, y + h + 20,
        x + w/2 + 30, y + h + 20,
        x + w/2 + 50, y + h + 120,
        x + w/2 - 50, y + h + 120
    )
    
    -- Pergamena
    love.graphics.setColor(0.95, 0.90, 0.78)
    love.graphics.rectangle("fill", x, y, w, h, 2, 2)
    
    -- Bordo pergamena
    love.graphics.setColor(0.7, 0.60, 0.45)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, y, w, h, 2, 2)
    love.graphics.setLineWidth(1)
    
    -- Ombra inchiostro (decorativa)
    love.graphics.setColor(0.1, 0.08, 0.05, 0.1)
    for i = 1, 8 do
        love.graphics.rectangle("fill", x + 20, y + 30 + i * 35, w - 40, 8)
    end
    
    -- Titolo placeholder sulla pergamena
    if self.run then
        love.graphics.setColor(0.2, 0.15, 0.1)
        love.graphics.printf("Folio " .. self.run.current_folio_index, x, y + 15, w, "center")
    end
end

--- Gestisce click
function Scriptorium:mousepressed(x, y, button)
    if button ~= 1 then return end
    if self.message then return end  -- Ignora input durante messaggi
    
    -- Il click viene gestito dal main.lua per i dadi
    -- Qui gestiamo solo UI specifiche della scena
end

--- Gestisce tasti
function Scriptorium:keypressed(key)
    if self.message then
        -- Qualsiasi tasto chiude il messaggio
        self.message = nil
        self.message_timer = 0
        return
    end
    
    if key == "space" and self.state == "waiting" then
        -- Lancia dadi (delegato al main.lua tramite callback)
        if self.onRollRequest then
            self.onRollRequest()
        end
    elseif key == "escape" then
        -- Torna al menu (futuro)
        print("[Scriptorium] ESC pressed - menu not implemented yet")
    elseif key == "r" then
        -- Restart run (debug)
        self:enter(self.run and self.run.fascicolo or "BIFOLIO")
    end
end

--- Callback quando i dadi si fermano
---@param values table Array di valori dadi {1-6, 1-6, ...}
function Scriptorium:onDiceSettled(values)
    if not self.run or not values or #values == 0 then return end
    
    self.dice_results = {}
    local folio = self.run.current_folio
    
    -- I dadi ora mostrano valore + colore
    -- Il piazzamento sarà interattivo (seleziona dado → clicca cella)
    -- Per ora: mostra solo i risultati
    for i, value in ipairs(values) do
        table.insert(self.dice_results, {
            value = value,
            used = false,
        })
    end
    
    -- Check stato folio
    if folio.busted then
        self:showMessage("BUST!", "La pergamena è rovinata! -3 Reputazione")
    elseif folio.completed then
        self:showMessage("COMPLETATO!", "Folio terminato con successo!")
    end
    
    self.state = "placing"  -- Nuovo stato: in attesa di piazzamento
end

--- Mostra messaggio centrale
function Scriptorium:showMessage(text, subtext, duration)
    self.message = {text = text, subtext = subtext}
    self.message_timer = duration or 2
end

--- Testo istruzioni
function Scriptorium:getInstructions()
    if self.state == "waiting" then
        return "[SPACE] Lancia dadi  |  [R] Restart  |  [ESC] Menu"
    elseif self.state == "rolling" then
        return "Dadi in volo..."
    elseif self.state == "placing" then
        return "Seleziona dado e piazza sul folio  |  [SPACE] Passa turno"
    else
        return "[SPACE] Continua"
    end
end

--- Wheel per zoom (delegato al 3D)
function Scriptorium:wheelmoved(x, y)
    -- Gestito dal sistema 3D nel main.lua
end

return Scriptorium
