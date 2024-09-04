local throttle_left_main_pin = 1
local relay_left_pin_1 = 5
local relay_left_pin_2 = 6


local throttle_right_main_pin = 2
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
local call_interval_ms = 50

function update()
    if arming:is_armed() == false then
        return update, call_interval_ms
    end

    local throttle_right_pwm = rc:get_pwm(throttleRightMainPin)

    -- Deadzone
    if throttle_right_pwm >= throttle_low_threshold and throttle_right_pwm <= throttle_high_threshold then
  
        relay:off(relayRightPin1)
        relay:off(relayRightPin2)
        relayRightPin1State = false
        relayRightPin2State = false
        gcs:send_text(log_severity_level, "Throttle Right Idle : " .. throttle_right_pwm .. ", State[1]: " .. relayRightPin1State .. ", State[2]: " .. relayRightPin2State)

            
    --Low throttle
    elseif throttle_right_pwm < throttle_low_threshold then

        relay:on(relayRightPin2)
        relay:off(relayRightPin1)
        relayRightPin2State = true
        relayRightPin1State = false
        gcs:send_text(log_severity_level, "Throttle Right Low: " .. throttle_right_pwm .. ", State[1]: " .. relayRightPin1State .. ", State[2]: " .. relayRightPin2State)


    --High throttle
    else
        relay:on(relayRightPin1)
        relay:off(relayRightPin2)
        relayRightPin1State = true
        relayRightPin2State = false
        gcs:send_text(log_severity_level, "Throttle Right High: " .. throttle_right_pwm .. ", State[1]: " .. relayRightPin1State .. ", State[2]: " .. relayRightPin2State)

    end


    return update, call_interval_ms

  end

return update()
