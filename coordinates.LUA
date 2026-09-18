-- coord_display.lua
-- Simple on-screen coordinate display for SM64CoopDX

-- == CONFIG ==
local SHOW_DECIMALS = true     -- true = show decimals, false = round to whole numbers
local UPDATE_RATE = 5           -- update every 5 frames (smoother or less frequent)
local TEXT_X = 30               -- X position of text on screen
local TEXT_Y = 40               -- Y position of text on screen
local TEXT_SCALE = 1.2          -- text size multiplier

-- == SCRIPT ==
local frameCounter = 0
local coordText = ""

hook_event(HOOK_ON_HUD_RENDER, function()
    local m = gMarioStates[0]
    if m == nil then return end

    frameCounter = frameCounter + 1
    if frameCounter >= UPDATE_RATE then
        frameCounter = 0
        local posX, posY, posZ = m.pos.x, m.pos.y, m.pos.z
        if not SHOW_DECIMALS then
            posX = math.floor(posX)
            posY = math.floor(posY)
            posZ = math.floor(posZ)
        else
            posX = string.format("%.2f", posX)
            posY = string.format("%.2f", posY)
            posZ = string.format("%.2f", posZ)
        end
        coordText = "X: " .. posX .. "  Y: " .. posY .. "  Z: " .. posZ
    end

    djui_hud_set_color(255, 255, 255, 255)
    djui_hud_set_font(FONT_NORMAL)
    djui_hud_print_text(coordText, TEXT_X, TEXT_Y, TEXT_SCALE)
end)
