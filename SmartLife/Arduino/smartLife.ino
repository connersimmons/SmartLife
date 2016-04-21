/*
  Web Server

 A simple web server that shows the value of the analog input pins.
 using an Arduino Wiznet Ethernet shield.

 Circuit:
 * Ethernet shield attached to pins 10, 11, 12, 13
 * Analog inputs attached to pins A0 through A5 (optional)

 created 18 Dec 2009
 by David A. Mellis
 modified 9 Apr 2012
 by Tom Igoe
 modified 02 Sept 2015
 by Arturo Guadalupi

 */

#include <SPI.h>
#include <Ethernet.h>
#include "DHT.h"
#include <Servo.h>

#define DHT11PIN A0
#define DHTTYPE DHT11

DHT dht(DHT11PIN, DHTTYPE);
Servo garageDoor;

boolean led1 = 0;
boolean led2 = 0;

int garageDoorPos = 20;

float temperatureF = 0;
float temperatureC = 0;
float humidity = 0;

String garageStatus = "Closed";

String jsonResult = "";

String httpReq = "";

boolean reading = false;

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED
};
IPAddress ip(192, 168, 1, 101);

// Initialize the Ethernet server library
// with the IP address and port you want to use
// (port 80 is default for HTTP):
EthernetServer server(80);

void setup() {
  // set LED pins
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);

  // set Servo pins
  garageDoor.attach(9);
  
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  // start temp sensor
  dht.begin();
  
  // start the Ethernet connection and the server:
  Ethernet.begin(mac, ip);
  server.begin();
  Serial.print("server is at ");
  Serial.println(Ethernet.localIP());
}


void loop() {
  // listen for incoming clients
  EthernetClient client = server.available();
  
  temperatureF = (float)dht.readTemperature(true);
  temperatureC = (float)dht.readTemperature();
  humidity = (float)dht.readHumidity();
  
  if (client) {
    Serial.println("new client");
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        if(reading && c == ' '){
          reading = false;
        }

        if(c == '$'){
          reading = true;
        }

        if(reading && c != '$'){
          httpReq += c;
        }

        if(c == '\n' && currentLineIsBlank){
          break;
        }

        if(c == '\n'){
          currentLineIsBlank = true;
        }else if(c != '\r'){
          currentLineIsBlank = false;
        }
                
      }
    }

    if (httpReq == "0") {
      
      Serial.println("GET ALL");
      jsonResult = getAllJSON("kitchenLED", "bathroomLED", "temperatureF", "temperatureC", "humidity", "garage", led1, led2, temperatureF, temperatureC, humidity, garageStatus);
      
    }
    if (httpReq == "1") {
      Serial.println("LED1 ON");
      led1 = 1;
      digitalWrite(2, HIGH);
      jsonResult = ledJSON("kitchenLED", led1);
    }
    if (httpReq == "2") {
      Serial.println("LED1 OFF");
      led1 = 0;
      digitalWrite(2, LOW);
      jsonResult = ledJSON("kitchenLED", led1);
    }
    // LED2
    if (httpReq == "3") {
      Serial.println("LED2 ON");
      led2 = 1;
      digitalWrite(3, HIGH);
      jsonResult = ledJSON("bathroomLED", led2);
    }
    if (httpReq == "4") {
      Serial.println("LED2 OFF");
      led2 = 0;
      digitalWrite(3, LOW);
      jsonResult = ledJSON("bathroomLED", led2);
    }
    if (httpReq == "5") {
      Serial.println("Opening Garage");
      openGarageDoor();
      jsonResult = garageJSON("garage", garageStatus);
    } 
    if (httpReq == "6") {
      Serial.println("Closing Garage");
      closeGarageDoor();
      jsonResult = garageJSON("garage", garageStatus);
    }
    if (httpReq == "9") {
      Serial.println("Getting Temperature & Humidity");
      jsonResult = tempHumJSON("temperatureF", "temperatureC", "humidity", temperatureF, temperatureC, humidity);
    }
    Serial.println(jsonResult);
    client.println(jsonResult);
    // give the web browser time to receive the data
    delay(1);
    // close the connection:
    client.stop();
    Serial.println("client disconnected");
    httpReq = "";
    jsonResult = "";
  }
}

void openGarageDoor() {
  for (garageDoorPos = 20; garageDoorPos < 180; garageDoorPos += 1) {
    garageDoor.write(garageDoorPos);
    delay(30);
  }
  garageStatus = "Open";
}

void closeGarageDoor() {
  for (garageDoorPos = 180; garageDoorPos >= 20; garageDoorPos -= 1) {
    garageDoor.write(garageDoorPos);
    delay(30);
  }
  garageStatus = "Closed";
}

String ledJSON(String keyString, boolean ledStatus) {
  return "{\"arduino\":[{\"key\":\"" + keyString +"\",\"value\":\"" + ledStatus + "\"}]}\n";
}

String tempHumJSON(String tempFKey, String tempCKey, String humKey, float tempFVal, float tempCVal, float humVal) {
  return "{\"arduino\":[{\"key\":\"" + tempFKey + "\",\"value\":\"" + tempFVal + "\"},{\"key\":\"" + tempCKey + "\",\"value\":\"" + tempCVal + "\"},{\"key\":\"" + humKey + "\",\"value\":\"" + humVal + "\"}]}\n";
}

String garageJSON(String garageString, String garageStatus) {
  return "{\"arduino\":[{\"key\":\"" + garageString +"\",\"value\":\"" + garageStatus + "\"}]}\n";
}

String getAllJSON(String led1Key, String led2Key, String tempFKey, String tempCKey, String humKey, String garageKey, boolean led1, boolean led2, float temperatureF, float temperatureC, float humidity, String garageStatus) {
  return "{\"arduino\":[{\"key\":\"" + led1Key +"\",\"value\":\"" + led1 + "\"},{\"key\":\"" + led2Key +"\",\"value\":\"" + led2 + "\"},{\"key\":\"" + tempFKey +"\",\"value\":\"" + temperatureF + "\"},{\"key\":\"" + tempCKey +"\",\"value\":\"" + temperatureC + "\"},{\"key\":\"" + humKey +"\",\"value\":\"" + humidity +"\"},{\"key\":\"" + garageKey +"\",\"value\":\"" + garageStatus + "\"}]}\n";
}

