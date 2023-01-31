/*  
 *  MAE 156A - Interrupt Function for Measuring No-Load Speed
 *  Motor: Pololu Motor 3260
 *  Spec No-Load Speed: 5600 RPM
 *  For No-Load Speed
 *  
 *  Janaury 12th, 2019
 *  
 */
 
// Variables for motor and encoder operation
int encoder_input_A_pin = 3;       // Digital input pin
int encoder_input_B_pin = 2;       // Digital input pin


// Variables for motor driver and PWM value for motor
int direction_pin = 7;
int pwm_pin = 6;
float motor_value = floor(.75*255); // 0 - 255
int motor_direction = 0;

// Variables for detecting encoder pulse and counting
long int count = 0;
int input_encoder_A_prev = 0;  
int input_encoder_A_now = 0;

// Variables for timing
unsigned long int prev_time = 0;
unsigned long int time_diff = 0;
unsigned long int curr_time = 0;
float encoder_pulse_frequency = 0;
int time_duration=10; // (milisecond) time for sampling delay


void setup() {
  Serial.begin(115200);              //serial output 

  pinMode(encoder_input_A_pin, INPUT);      // sets the digital pin as input
  pinMode(encoder_input_B_pin, INPUT);      // sets the digital pin as input

  pinMode(direction_pin, OUTPUT);       // Set the direction pin output
  pinMode(pwm_pin, OUTPUT);       // Set the pwm pin output
  
  attachInterrupt(digitalPinToInterrupt(encoder_input_A_pin),encoderA,CHANGE);
  attachInterrupt(digitalPinToInterrupt(encoder_input_B_pin),encoderB,CHANGE);
  
  input_encoder_A_prev = digitalRead(encoder_input_A_pin);

  digitalWrite(direction_pin, motor_direction);      // Set the motor in motion
  analogWrite(pwm_pin, motor_value);      // Set the motor in motion

  prev_time = micros();  
}
 
void loop() {
   
   if (millis()<10000){
    Serial.print(micros());           //time base for speed data
    Serial.print(",");                //data separator character
    Serial.println(count);            //counts for position and velocity calculation
    delay(time_duration);
    
   }
   else
   {
    analogWrite(pwm_pin, 0*motor_value);
    
   }
  
}

void encoderA() {
  // look for a low-to-high on channel A
  if (digitalRead(encoder_input_A_pin) == HIGH) {
    
    // check channel B to see which way encoder is turning
    if (digitalRead(encoder_input_B_pin) == LOW) {
      count = count + 1;         // CW
    }
    else {
      count = count - 1;         // CCW
    }
  }

  else   // must be a high-to-low on channel A
  {
    // check channel B to see which way encoder is turning
    if (digitalRead(encoder_input_B_pin) == HIGH) {
      count = count + 1;          // CW
    }
    else {
      count = count - 1;          // CCW
    } 
  }
}

void encoderB() {
  // look for a low-to-high on channel B
  if (digitalRead(encoder_input_B_pin) == HIGH) {
    
    // check channel A to see which way encoder is turning
    if (digitalRead(encoder_input_A_pin) == HIGH) {
      count = count + 1;         // CW
    }
    else {
      count = count - 1;         // CCW
    }
  }

  // Look for a high-to-low on channel B
  else {
    
    // check channel B to see which way encoder is turning
    if (digitalRead(encoder_input_A_pin) == LOW) {
      count = count + 1;          // CW
    }
    else {
      count = count - 1;          // CCW
    }
  }
}
