#include <Arduino.h>

/*
Program to capture PWM signals from the RC receiver and map them to 0-100% duty cycle PWM signals for the motor controller using interrupts
*/

constexpr int pixhawk_pwm_pins[] = {2, 3};
constexpr int motor_pwm_pins[] = {5, 6};
constexpr int number_channels = 2;
unsigned long pixhawk_pwm_values[] = {0, 0};
int motor_output_values[] = {0, 0};


void CapturePWMSignal() {
	for (int i = 0; i < number_channels; i++) {
		unsigned long pwm_value = pulseIn(pixhawk_pwm_pins[i], HIGH);
		if (pwm_value > 0) {
			pixhawk_pwm_values[i] = pwm_value;
		}
	}
}

void MapPWMToMotor() {
	constexpr int min_pwm = 1000;
	constexpr int max_pwm = 2000;
	constexpr int min_duty_cycle = 0;
	constexpr int max_duty_cycle = 100;
	for (int i = 0; i < number_channels; i++) {
		int duty_cycle = map(pixhawk_pwm_values[i], min_pwm, max_pwm, min_duty_cycle, max_duty_cycle);
		duty_cycle = constrain(duty_cycle, min_duty_cycle, max_duty_cycle);
		int analog_write_value = map(duty_cycle, min_duty_cycle, max_duty_cycle, 0, 255);
		motor_output_values[i] = analog_write_value;
	}
}

void UpdateMotorPWM() {
	for (int i = 0; i < number_channels; i++) {
		analogWrite(motor_pwm_pins[i], motor_output_values[i]);
	}
}

void PrintValues() {
	Serial.print("Pixhawk PWM values: ");
	for (int i = 0; i < number_channels; i++) {
		Serial.print(pixhawk_pwm_values[i]);
		Serial.print(" ");
	}
	Serial.println();
	Serial.print("Motor output values: ");
	for (int i = 0; i < number_channels; i++) {
		Serial.print(motor_output_values[i]);
		Serial.print(" ");
	}
	Serial.println();
	Serial.println();
}

void PrintValuesTimer() {
	static unsigned long last_time = 0;
	unsigned long current_time = millis();
	if (current_time - last_time > 750) {
		PrintValues();
		last_time = current_time;
	}
}

void setup() {
	Serial.begin(9600);
	delay(1000);
	Serial.println("Starting PWM adapter");
	pinMode(pixhawk_pwm_pins[0], INPUT);
	pinMode(pixhawk_pwm_pins[1], INPUT);

	pinMode(motor_pwm_pins[0], OUTPUT);
	pinMode(motor_pwm_pins[1], OUTPUT);

}

void loop() {
	CapturePWMSignal();
	MapPWMToMotor();
	UpdateMotorPWM();
	PrintValuesTimer();
}