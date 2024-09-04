--Toggle relay on Pixhawk


local relay_right_pin_1 = 2
local relay_right_pin_2 = 3
local relay_left_pin_1 = 4
local relay_left_pin_2 = 5

local should_go_forward = true

function update()

    gcs:send_text(0, "[LUA]")

    if should_go_forward then
        --Forward
        relay:off(0)
        relay:on(1)
        relay:off(2)
        relay:on(3)
        gcs:send_text(0, "FORWARD")
    else
        --Backward
        relay:on(0)
        relay:off(1)
        relay:on(2)
        relay:off(3)
        gcs:send_text(0, "BACK")

    end

    should_go_forward = not should_go_forward
    return update, 8000
end

gcs:send_text(0, "[LUA] Relay Test")
return update()