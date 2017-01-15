#include <SPI.h>
#include <WiFi101.h>
#define PubNub_BASE_CLIENT WiFiClient
#include <PubNub.h>

#include <Adafruit_Sensor.h>
#include <Adafruit_9DOF.h>
#include <Adafruit_L3GD20.h>
#include <Adafruit_L3GD20_U.h>
#include <Adafruit_LSM303.h>
#include <Adafruit_LSM303_U.h>

static char ssid[] = "IDEA Hacks 2.4G";   // your network SSID (name)
static char pass[] = "sportstech";            // your network password
int status = WL_IDLE_STATUS;                // the Wifi radio's status

const static char pubkey[] = "pub-c-5762053e-42f6-49a2-99e5-7fdd462044e9";
const static char subkey[] = "sub-c-43fded74-bc27-11e5-a9aa-02ee2ddab7fe";
const static char channel[] = "Likai_Channel";


Adafruit_9DOF                dof   = Adafruit_9DOF();
Adafruit_LSM303_Accel_Unified accel = Adafruit_LSM303_Accel_Unified(30301);
Adafruit_LSM303_Mag_Unified   mag   = Adafruit_LSM303_Mag_Unified(30302);

// Initializing
const int array_size = 36;
double learning[array_size];
double temp[array_size];
double threshold = 0;
int counter = 0;
int experience = 0;
int led_red = 7;
int led_green = 6;

void initSensors()
{
  if(!accel.begin())
  {
    /* There was a problem detecting the LSM303 ... check your connections */
    Serial.println(F("Ooops, no LSM303 detected ... Check your wiring!"));
    while(1);
  }
  if(!mag.begin())
  {
    /* There was a problem detecting the LSM303 ... check your connections */
    Serial.println("Ooops, no LSM303 detected ... Check your wiring!");
    while(1);
  }
}



void setup() {
  // put your setup code here, to run once:
  pinMode(led_red, OUTPUT);
  pinMode(led_green, OUTPUT);
  Serial.begin(9600);
  Serial.println("Serial set up");

  // attempt to connect using WPA2 encryption:
  Serial.println("Attempting to connect to WPA network...");
  status = WiFi.begin(ssid, pass);
  
  // if you're not connected, stop here:
  if ( status != WL_CONNECTED) 
  {
    Serial.println("Couldn't get a wifi connection");
    while (true);
  } 
  else 
  {
    Serial.print("WiFi connecting to SSID: ");
    Serial.println(ssid);

    PubNub.begin(pubkey, subkey);
    Serial.println("PubNub set up");
    digitalWrite(led_green, HIGH);
  }
  
  initSensors();
  for (int i = 0; i < array_size; i++)
  {
    temp[i] = 0;
  }
}


void loop() {
  sensors_event_t accel_event;
  sensors_vec_t orientation;  
  accel.getEvent(&accel_event);
  WiFiClient *client;
  
  if(dof.accelGetOrientation(&accel_event, &orientation))
  {
    if(orientation.pitch < threshold)
      {
        temp[counter] = orientation.pitch;
        counter++;
      }
    else if (!counter)
      return;
    else
      counter = array_size;
  }

  if (counter >= array_size)
  {
    if(!experience)
    {
        for (int i = 0; i < counter; i++)
        {
          learning[i] = temp[i];
        }   
    }
    else
    {
      for(int i = 0; i < counter; i++)
      {
         learning[i] = (experience * learning[i] + temp[i])/(experience + 1);
      }
    }
;
    
    for(int i = 0; i < counter; i++)
    {
//    Serial.print(temp[i]);
//    Serial.print(" ");
//    Serial.print(learning[i]);
//    Serial.println();

//    Turn the reading from sensor into Json form
      char buf[100];
      String json1 = String("{\"eon\":{\"Learning\":");
      String json2 = String(-learning[i],2);
      String json3 = String(",\"Current\":");
      String json4 = String(-temp[i],2);
      String json5 = String("}}");
      String json_total = json1 + json2 + json3 + json4 + json5;
      Serial.println(json_total);
      
      json_total.toCharArray(buf,100);
       
      client = PubNub.publish(channel, buf);
      if (!client) 
      {
        Serial.println("publishing error");
        delay(1000);
        return;
      }
      
      client->stop();
    }

    int minPerTrial = temp[0];
    for(int i = 1; i < counter; i++)
    {
      if(temp[i] < minPerTrial)
        minPerTrial = temp[i];
    }
    
    int minLearning = learning[0];
    for(int i = 1; i < counter; i++)
    {
      if(learning[i] < minLearning)
      {
        minLearning = learning[i];
      }
    }
    
    if (minLearning < minPerTrial)
    {
      digitalWrite(led_red, HIGH);
      delay(500);
      digitalWrite(led_red, LOW);
    }
    
    Serial.println();
    experience++;
    counter = 0;
    delay(500);
  }
  delay(50);
}
