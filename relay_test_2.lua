--Toggle relay on Pixhawk

local relay_right_pin_1 = 2 -- Pin 52
local relay_right_pin_2 = 3 -- Pin 53
local relay_left_pin_1 = 4 -- Pin 54
local relay_left_pin_2 = 5 -- Pin 55

local should_go_forward = true

function update()

    gcs:send_text(0, "[LUA]")

    if should_go_forward then
        --Forward
        relay:on(relay_right_pin_1)
        relay:off(relay_right_pin_2)
        relay:on(relay_left_pin_1)
        relay:off(relay_left_pin_2)

        gcs:send_text(0, "FORWARD")
    else
        --Backward
        relay:off(relay_left_pin_1)
        relay:on(relay_left_pin_2)
        relay:off(relay_right_pin_1)
        relay:on(relay_right_pin_2)
        gcs:send_text(0, "BACK")

    end

    should_go_forward = not should_go_forward
    return update, 8000
end

gcs:send_text(0, "[LUA] Relay Test")
return update()