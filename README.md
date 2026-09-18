# sm64-coopdx-position-tracker
A low-overhead spatial coordinate tool for SM64 Co-op DX designed to extract precise X/Y/Z vectors for scripting Lua object spawns, warps, and coin placements.

# SM64 Co-op DX - Spatial Coordinate Tool for Lua Development

## Overview
A performance-optimized spatial coordinate utility for SM64 Co-op DX designed to assist mod developers and QA testers with precise object placement, coin pathing, dynamic spawns, and custom warp trigger scripting.

---

## Technical Features & Optimization

* **Precision Asset & Object Placement:** Displays real-time $X, Y, Z$ spatial vectors, allowing Lua developers to sample exact map positions for instantiating custom entities, secret warp triggers, and coin layouts.
* **Execution Throttling (`UPDATE_RATE`):** Implements a frame-modulo counter within `HOOK_ON_HUD_RENDER`[span_0](start_span)[span_0](end_span) to limit string formatting operations to every $N$ frames[span_1](start_span)[span_1](end_span), significantly reducing CPU render thread overhead[span_2](start_span)[span_2](end_span).
* **Dynamic Precision Formatting:** Features a configurable boolean (`SHOW_DECIMALS`)[span_3](start_span)[span_3](end_span) to switch between raw float precision (`string.format("%.2f")`)[span_4](start_span)[span_4](end_span) and floored integer calculations (`math.floor`)[span_5](start_span)[span_5](end_span) to minimize string concatenation costs during active movement.
* **Null-Pointer Guard Clause:** Uses defensive pointer checks (`if m == nil then return end`)[span_6](start_span)[span_6](end_span) on local player state (`gMarioStates[0]`)[span_7](start_span)[span_7](end_span) to prevent engine crashes during map transitions or level loading.

---

## Code Logic Breakdown

```lua
-- Throttled render loop executing string format operations every N frames
hook_event(HOOK_ON_HUD_RENDER, function()
    local m = gMarioStates[0]
    if m == nil then return end -- Guard clause: prevents null pointer exceptions

    frameCounter = frameCounter + 1
    if frameCounter >= UPDATE_RATE then
        frameCounter = 0
        local posX, posY, posZ = m.pos.x, m.pos.y, m.pos.z
        
        -- Formats vector strings only when frame throttle boundary is reached
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
```

Developer Workflow & Usage
​
Load target level in SM64 Co-op DX.
​Navigate player character to target location (e.g., hidden ledge or secret warp zone).
​Read real-time X/Y/Z coordinates directly from the HUD.  
​Inject extracted vector values into custom Lua scripts:

```
-- Example: Using sampled coordinates to spawn a secret warp trigger
spawn_non_sync_object(id_bhvSecretWarp, E_MODEL_NONE, posX, posY, posZ, nil)
```
QA & Testing Applications

​Bounds & Collision Testing: Enables quick logging of out-of-bounds vectors and geometry hitboxes.
​Level Design Acceleration: Eliminates trial-and-error coordinate guessing when scripting custom interactive objects.
