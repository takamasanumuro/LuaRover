local throttle_left_main_pin = 1
local relay_left_pin_1 = 5
local relay_left_pin_2 = 6


local throttle_right_main_pin = 74
local relay_right_pin_1 = 3
local relay_right_pin_2 = 4


local relay_left_pin_1_state = false
local relay_left_pin_2_state = false
local relay_right_pin_1_state = false
local relay_right_pin_2_state = false


local throttle_low_threshold = 1400
local throttle_high_threshold = 1600


--[[
Severity Level  | Type
------------------------
0               | Emergency
1               | Alert
2               | Critical
3               | Error
4               | Warning
5               | Notice
6               | Info
7               | Debug
]]

local log_severity_level = 0
local call_interval_ms = 200
local throttle_left_function =  73
local throttle_right_function =  74

function update()
    if arming:is_armed() == false then
        return update, call_interval_ms
    end

    local throttle_left_pwm = SRV_Channels:get_output_pwm(throttle_left_function)
    local throttle_right_pwm = SRV_Channels:get_output_pwm(throttle_right_function)
    gcs:send_text(log_severity_level, "Throttle Left : " .. throttle_left_pwm .. ", Throttle Right : " .. throttle_right_pwm)

    return update, call_interval_ms

end

return update()
