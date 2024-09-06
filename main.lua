local throttle_left_function =  73
local relay_left_pin_1 = 4 -- Pin 54
local relay_left_pin_2 = 5 -- Pin 55


local throttle_right_function =  74
local relay_right_pin_1 = 2 -- Pin 52
local relay_right_pin_2 = 3 -- Pin 53


local relay_left_pin_1_state = true
local relay_left_pin_2_state = true
local relay_right_pin_1_state = true
local relay_right_pin_2_state = true


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
local call_interval_ms = 400

gcs:send_text(log_severity_level, "[LUA] Main script started")

function update()
    if arming:is_armed() == false then
        return update, call_interval_ms
    end

    --local throttle_left_pwm = SRV_Channels:get_output_pwm(throttle_left_function)
    local throttle_right_pwm = SRV_Channels:get_output_pwm(throttle_right_function)

    -- Deadzone
    if throttle_right_pwm >= throttle_low_threshold and throttle_right_pwm <= throttle_high_threshold then
  
        relay:on(relay_right_pin_1)
        relay:on(relay_right_pin_2)
        relay_right_pin_1_state = true
        relay_right_pin_2_state = true
        gcs:send_text(log_severity_level, "Throttle[R] Dead: " .. throttle_right_pwm .. ", [1]: " .. tostring(relay_right_pin_1_state) .. ", [2]: " .. tostring(relay_right_pin_2_state))
            
    --Low throttle / Back
    elseif throttle_right_pwm < throttle_low_threshold then
        relay:off(relay_right_pin_1)
        relay:on(relay_right_pin_2)
        relay_right_pin_1_state = false
        relay_right_pin_2_state = true
        gcs:send_text(log_severity_level, "Throttle[R]Low: " .. throttle_right_pwm .. ", [1]: " .. tostring(relay_right_pin_1_state) .. ", [2]: " .. tostring(relay_right_pin_2_state))

    --High throttle / Forward
    else
        relay:on(relay_right_pin_1)
        relay:off(relay_right_pin_2)
        relay_right_pin_1_state = true
        relay_right_pin_2_state = false
        gcs:send_text(log_severity_level, "Throttle[R] High: " .. throttle_right_pwm .. ", [1]: " .. tostring(relay_right_pin_1_state) .. ", [2]: " .. tostring(relay_right_pin_2_state))
    end

    return update, call_interval_ms

end

return update()
