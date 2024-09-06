--Toggle relay on Pixhawk
local throttle_left_function =  73
local throttle_right_function =  74
local throttle_left_script_function = 94
local throttle_right_script_function = 95

local relay_right_pin_1 = 2 -- Pin 52
local relay_right_pin_2 = 3 -- Pin 53
local relay_left_pin_1 = 4 -- Pin 54
local relay_left_pin_2 = 5 -- Pin 55

local throttle_trim = 1500
local throttle_deadzone = 50
local throttle_low_threshold = throttle_trim - throttle_deadzone
local throttle_high_threshold = throttle_trim + throttle_deadzone


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
local call_interval_ms = 100

--function to map values between two ranges
function map(x, in_min, in_max, out_min, out_max)
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

function update()

    if arming:is_armed() == false then
        return update, call_interval_ms
    end

    local throttle_left_pwm = SRV_Channels:get_output_pwm(throttle_left_function)
    local throttle_right_pwm = SRV_Channels:get_output_pwm(throttle_right_function)

    if throttle_right_pwm > 1500 then
        local throttle_right_new_pwm_high = uint32_t(map(throttle_right_pwm, 1500, 2000, 1800, 2000))
        SRV_Channels:set_output_pwm(throttle_right_function, throttle_right_new_pwm_high:toint())
        relay:on(relay_right_pin_1)
        relay:off(relay_right_pin_2)
    else 
        local throttle_right_new_pwm_low = uint32_t(map(throttle_right_pwm, 1000, 1500, 1800, 2000))
        SRV_Channels:set_output_pwm(throttle_right_function, throttle_right_new_pwm_low:toint())
        relay:off(relay_right_pin_1)
        relay:on(relay_right_pin_2)
    end

    if throttle_left_pwm > 1500 then
        local throttle_left_new_pwm_high = uint32_t(map(throttle_left_pwm, 1500, 2000, 1800, 2000))
        SRV_Channels:set_output_pwm(throttle_left_function, throttle_left_new_pwm_high:toint())
        relay:on(relay_left_pin_1)
        relay:off(relay_left_pin_2)
    else 
        local throttle_left_new_pwm_low = uint32_t(map(throttle_left_pwm, 1000, 1500, 1800, 2000))
        SRV_Channels:set_output_pwm(throttle_left_function, throttle_left_new_pwm_low:toint())
        relay:off(relay_left_pin_1)
        relay:on(relay_left_pin_2)
    end

    return update, call_interval_ms
end

gcs:send_text(0, "[LUA] Relay Test")
value = map(1000, 1000, 2000, 1800, 2000)
gcs:send_text(0, "[LUA] Value: " .. tostring(value))
return update()