#include <Wire.h>
#include "Adafruit_LSM303_U.h"
#include "pitches.h"

/* Assign a unique ID to this sensor at the same time */
Adafruit_LSM303_Accel_Unified accel = Adafruit_LSM303_Accel_Unified(54321);

char val;
int note = NOTE_A4;
float temp = 0.0;

void displaySensorDetails(void)
{
  sensor_t sensor;
  accel.getSensor(&sensor);
  Serial.println("------------------------------------");
  Serial.print  ("Sensor:       "); Serial.println(sensor.name);
  Serial.print  ("Driver Ver:   "); Serial.println(sensor.version);
  Serial.print  ("Unique ID:    "); Serial.println(sensor.sensor_id);
  Serial.print  ("Max Value:    "); Serial.print(sensor.max_value); Serial.println(" m/s^2");
  Serial.print  ("Min Value:    "); Serial.print(sensor.min_value); Serial.println(" m/s^2");
  Serial.print  ("Resolution:   "); Serial.print(sensor.resolution); Serial.println(" m/s^2");  
  Serial.println("------------------------------------");
  Serial.println("");
  delay(500);
}

void setup() {
  
#ifndef ESP8266
  while (!Serial);     // will pause Zero, Leonardo, etc until serial console opens
#endif
  Serial.begin(9600);
  Serial.println("Accelerometer Test"); Serial.println("");
  
  /* Initialise the sensor */
  if(!accel.begin())
  {
    /* There was a problem detecting the ADXL345 ... check your connections */
    Serial.println("Ooops, no LSM303 detected ... Check your wiring!");
    while(1);
  }
  
  /* Display some basic information on this sensor */
  displaySensorDetails();
  establishContact();
}

void loop() {
  // put your main code here, to run repeatedly:
  
  /* Get a new sensor event */ 
  sensors_event_t event; 
  accel.getEvent(&event);
  
  float diff = temp - event.acceleration.z;
  
  if(Serial.available() > 0)
  {
    val = Serial.read();

      if(val == '1')
      {
        tone(8, note, 20);
      }
  }
  else
  {
    // based on accelerometer
    if(event.acceleration.x > 0)
      Serial.println("up");
    if(event.acceleration.x < 0)
      Serial.println("down");
  }
  
  temp = event.acceleration.z;
}

void establishContact()
{
  while(Serial.available() <= 0)
  {
    Serial.println("A");
    delay(300);
  }
}


