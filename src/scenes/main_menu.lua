-- src/scenes/main_menu.lua
-- Scena menu principale stile "libri impilati" (UI ridisegnata: pulsanti orizzontali)

local MainMenu = {}
local music = nil
local menu_font = nil
local music_play_attempted = false
local menu_bg = nil

local menu_items = {
    {label = "Continue", enabled = false},
    {label = "Start Game", enabled = true},
    {label = "Settings", enabled = true},
    {label = "Wishlist Now!", enabled = true},
    {label = "Quit", enabled = true},
}

local selected = 2 -- Default: Start Game
local hovered = nil -- Indice del pulsante sotto il mouse

function MainMenu:enter()
    -- Reset selezione
    selected = 2
    log("[MainMenu] enter() called")
    -- Log audio subsystem state
    if love.audio and love.audio.getActiveSourceCount then
        local ok, cnt = pcall(function() return love.audio.getActiveSourceCount() end)
        log(string.format("[MainMenu] love.audio active source count: %s", tostring(cnt)))
    else
        log("[MainMenu] love.audio API not available or missing getActiveSourceCount")
    end

    -- Load menu font once (safe)
    if not menu_font then
        if love.filesystem and love.filesystem.getInfo and love.filesystem.getInfo("resources/font/EagleLake-Regular.ttf") then
            local ok, f = pcall(function()
                return love.graphics.newFont("resources/font/EagleLake-Regular.ttf", 32)
            end)
            if ok and f then
                menu_font = f
                log("[MainMenu] menu font loaded")
            else
                menu_font = nil
                log("[MainMenu] failed to load menu font, will fallback")
            end
        end
    end

    -- load menu background image (optional)
    if not menu_bg then
        if love.filesystem and love.filesystem.getInfo and love.filesystem.getInfo("resources/ui/menu.png") then
            pcall(function()
                menu_bg = love.graphics.newImage("resources/ui/menu.png")
            end)
        end
    end

    -- Simplified: force load the converted .ogg file
    if not music then
        local ogg = "resources/sounds/maintitle.ogg"
        if love.filesystem and love.filesystem.getInfo and love.filesystem.getInfo(ogg) then
            local ok, src = pcall(function()
                return love.audio.newSource(ogg, "stream")
            end)
            if ok and src then
                music = src
                music:setLooping(true)
                -- Lower default menu music volume to be less intrusive
                music:setVolume(0.2)
                if love.audio and love.audio.setVolume then pcall(function() love.audio.setVolume(1) end) end
                local played_ok = pcall(function() music:play() end)
                log(string.format("[MainMenu] play called .ogg success=%s isPlaying=%s", tostring(played_ok), tostring(music:isPlaying())))
            else
                -- silent failure loading menu music
            end
        else
            -- maintitle.ogg not found
        end
    elseif not music:isPlaying() then
        pcall(function() music:play() end)
    end

    -- Optional silent diagnostics and fallbacks (no console logs)
    if music then
        -- attempt to ensure it's playing; keep diagnostics silent
        pcall(function() music:getDuration() end)
        pcall(function() music:getVolume() end)
        pcall(function() music:isPlaying() end)
        pcall(function() love.audio.play(music) end)

        -- If still not playing, try static SoundData fallback (silent)
        local still_playing = false
        pcall(function() still_playing = music:isPlaying() end)
        if not still_playing and love.sound and love.sound.newSoundData then
            local ogg = "resources/sounds/maintitle.ogg"
            local oksd, sd = pcall(function() return love.sound.newSoundData(ogg) end)
            if oksd and sd then
                local oksrc, ssrc = pcall(function() return love.audio.newSource(sd) end)
                if oksrc and ssrc then
                    ssrc:setLooping(true)
                    ssrc:setVolume(0.2)
                    pcall(function() love.audio.play(ssrc) end)
                    music = ssrc
                end
            end
        end
    else
        -- music not available (silent)
    end
end

function MainMenu:exit()
    -- Stub
end

function MainMenu:update(dt)
    -- Stub (animazioni future)
    -- Reset hover (verrà aggiornato in love.mousemoved)
    hovered = nil
    -- If we have a loaded music Source but it's not playing, try once to play it
    if music and not music:isPlaying() and not music_play_attempted then
        music_play_attempted = true
        pcall(function() music:play() end)
    end
end

function MainMenu:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    -- Ensure full-screen scissor reset
    if love.graphics.setScissor then love.graphics.setScissor() end
    -- draw menu background if available, otherwise fallback to solid black
    if menu_bg then
        local bw, bh = menu_bg:getWidth(), menu_bg:getHeight()
        -- Non ritagliare e non ingrandire: adattiamo l'immagine senza upscaling
        local scale = math.min(1, math.min(w / bw, h / bh))
        local dw, dh = bw * scale, bh * scale
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(menu_bg, w/2 - dw/2, h/2 - dh/2, 0, scale, scale)
    else
        if love.graphics.clear then
            love.graphics.clear(0, 0, 0, 1)
        else
            love.graphics.setColor(0.0, 0.0, 0.0, 1)
            love.graphics.rectangle("fill", 0, 0, w, h)
        end
    end

    -- Tavolo (base) removed for full-black background in menu
    -- (was: love.graphics.setColor(0.25,0.18,0.10) + rectangle at bottom)

    -- Pulsanti semplici (sinistra) — UI ridisegnata
    local btn_w, btn_h = 340, 60
    local left_x, stack_y = math.max(24, w * 0.04), h * 0.15
    local spacing = 12
    for i, item in ipairs(menu_items) do
        local y = stack_y + (i-1) * (btn_h + spacing)
        -- Ombra
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", left_x + 6, y + 6, btn_w, btn_h, 12, 12)

        -- Colore di sfondo del pulsante (stato normale/hover/selected)
        if i == selected then
            love.graphics.setColor(0.93, 0.8, 0.28, 1)
        elseif i == hovered then
            love.graphics.setColor(0.95, 0.85, 0.45, 1)
        else
            love.graphics.setColor(0.33, 0.24, 0.12, 1)
        end
        love.graphics.rectangle("fill", left_x, y, btn_w, btn_h, 12, 12)

        -- Bordo: dorato per Settings, sottile altrimenti
        if item.label == "Settings" then
            love.graphics.setColor(0.9, 0.75, 0.3, 1)
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", left_x + 3, y + 3, btn_w - 6, btn_h - 6, 10, 10)
        else
            love.graphics.setColor(0.6, 0.5, 0.35, 1)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("line", left_x + 3, y + 3, btn_w - 6, btn_h - 6, 10, 10)
        end
        love.graphics.setLineWidth(1)

        -- Testo orizzontale, allineato a sinistra con padding
        love.graphics.setColor((i == selected or i == hovered) and {0.1, 0.06, 0.03, 1} or {0.95, 0.90, 0.80, 1})
        local font = menu_font or love.graphics.getFont()
        love.graphics.setFont(font)
        local text = item.label or ""
        local padding = 18
        love.graphics.printf(text, left_x + padding, y + (btn_h - font:getHeight()) / 2, btn_w - padding * 2, "left")

        -- Overlay disabilitato
        if not item.enabled then
            love.graphics.setColor(0, 0, 0, 0.45)
            love.graphics.rectangle("fill", left_x, y, btn_w, btn_h, 12, 12)
        end
    end

    -- Decorative overlay removed (cards/coins/dice) per UI cleanup
end

function MainMenu:keypressed(key)
    if key == "up" then
        repeat
            selected = selected - 1
            if selected < 1 then selected = #menu_items end
        until menu_items[selected].enabled
    elseif key == "down" then
        repeat
            selected = selected + 1
            if selected > #menu_items then selected = 1 end
        until menu_items[selected].enabled
    elseif key == "return" or key == "space" then
        local item = menu_items[selected]
        if item.label == "Start Game" then
            require("src.core.scene_manager").switch("Scriptorium")
        elseif item.label == "Quit" then
            love.event.quit()
        else
            log("[MainMenu] Selected: " .. item.label)
        end
    end
end

function MainMenu:mousepressed(x, y, button)
    if button ~= 1 then return end
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local btn_w, btn_h = 340, 60
    local left_x, stack_y = math.max(24, w * 0.04), h * 0.15
    local spacing = 12
    for i, item in ipairs(menu_items) do
        local yb = stack_y + (i-1) * (btn_h + spacing)
        if x >= left_x and x <= left_x + btn_w and y >= yb and y <= yb + btn_h then
            if item.enabled then
                selected = i
                hovered = i
                MainMenu:activate(i)
            end
            return
        end
    end
end

function MainMenu:mousemoved(x, y, dx, dy)
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local btn_w, btn_h = 340, 60
    local left_x, stack_y = math.max(24, w * 0.04), h * 0.15
    local spacing = 12
    hovered = nil
    for i, item in ipairs(menu_items) do
        local yb = stack_y + (i-1) * (btn_h + spacing)
        if x >= left_x and x <= left_x + btn_w and y >= yb and y <= yb + btn_h then
            if item.enabled then hovered = i end
            break
        end
    end
end

function MainMenu:activate(idx)
    local item = menu_items[idx]
    if item.label == "Start Game" then
        require("src.core.scene_manager").switch("scriptorium")
    elseif item.label == "Quit" then
        love.event.quit()
    else
        log("[MainMenu] Selected: " .. item.label)
    end
end

return MainMenu
