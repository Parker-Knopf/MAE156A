/*  
 *  MAE 156A - Motor PWM Example
 *  
 */

// Variables for motor driver and PWM value for motor
int direction_pin = 7;
int pwm_pin = 6;
float motor_value = 10; // 0 - 255
int motor_direction = 0; //0 or 1

void setup() {
  Serial.begin(115200);     //serial output 

  pinMode(direction_pin, OUTPUT);       // Set the direction pin output
  pinMode(pwm_pin, OUTPUT);       // Set the pwm pin output
  

  digitalWrite(direction_pin, motor_direction);      // Set the motor in motion
  analogWrite(pwm_pin, motor_value);      // Set the motor in motion
  
}
 
void loop() {

  //Have Serial Monitor Display PWM Input Value   
  Serial.print("Motor Running at ");
  Serial.print(motor_value);
  Serial.println("PWM Value");
  
}
