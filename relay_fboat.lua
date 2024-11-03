--Toggle relay on Pixhawk

--A function can be mapped to different channels. 
--There are methods available to getting which channel is mapped to a function.

local throttle_rc_input_function = 51 -- Manual mode via RC channel
local throttle_function = 70 -- Calculated by autopilot

local throttle_function =  throttle_rc_input_function -- Either use RC channel(manual) or throttle(calculated by autopilot)
local scripted_throttle_function = 94 -- Script output PWM, must use a range between 94-109

-- Relay pins to set the motor direction by switching 2 out of the 3 BLDC output phases
local relay_pin_1 = 4 -- Pin 54
local relay_pin_2 = 5 -- Pin 55

local throttle_trim = 1500 -- Center position of the throttle
local throttle_deadzone = 50 -- Motor should be idle within this range
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

    local throttle_pwm = SRV_Channels:get_output_pwm(throttle_rc_input_function)

    local scripted_throttle_channel = SRV_Channels:find_channel(scripted_throttle_function)

    local timeout = 20

    if throttle_pwm > 1500 then
        local throttle_new_pwm_high = uint32_t(map(throttle_pwm, 1500, 2000, 1000, 2000))
        SRV_Channels:set_output_pwm_chan_timeout(scripted_throttle_channel, throttle_new_pwm_high:toint(), timeout)
        relay:off(relay_pin_1)
        relay:off(relay_pin_2)
        gcs:send_text(0, "[LUA] Relay Off")
    else 
        local throttle_new_pwm_low = uint32_t(map(throttle_pwm, 1000, 1500, 2000, 1000))
        SRV_Channels:set_output_pwm_chan_timeout(scripted_throttle_channel, throttle_new_pwm_low:toint(), timeout)
        relay:on(relay_pin_1)
        relay:on(relay_pin_2)
        gcs:send_text(0, "[LUA] Relay On")
    end

    return update, call_interval_ms
end

gcs:send_text(0, "[LUA] Relay Test")
return update()