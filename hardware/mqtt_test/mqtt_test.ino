#include "WiFi.h"
#include <PubSubClient.h>
#include "max6675.h"

// WiFi
const char *ssid = "Qwertyuiop";
const char *password = "123456789";

const int ir = 4;

int thermoDO = 19;
int thermoCS = 23;
int thermoCLK = 5;

MAX6675 thermocouple(thermoCLK, thermoCS, thermoDO);

// MQTT Broker
const char *mqtt_broker = "broker.emqx.io";
const char *temp_topic = "emqx/esp32/temperature";
const char *item_topic = "emqx/esp32/item";
const char *mqtt_username = "emqx";
const char *mqtt_password = "public";
const int mqtt_port = 1883;
WiFiClient espClient;
PubSubClient client(espClient);

// Variables for timing
unsigned long lastSendTime = 0;
const unsigned long sendInterval = 5000; // 2 seconds

// Count variable
int itemCount = 0;

void setup() {
    Serial.begin(115200);
    pinMode(ir, INPUT);

    // Connecting to WiFi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.println("Connecting to WiFi..");
    }
    Serial.println("Connected to the Wi-Fi network");

    // Connecting to MQTT broker
    client.setServer(mqtt_broker, mqtt_port);
    while (!client.connected()) {
        String client_id = "esp32-client-";
        client_id += String(WiFi.macAddress());
        Serial.printf("The client %s connects to the public MQTT broker\n", client_id.c_str());
        if (client.connect(client_id.c_str(), mqtt_username, mqtt_password)) {
            Serial.println("Public EMQX MQTT broker connected");
        } else {
            Serial.print("failed with state ");
            Serial.print(client.state());
            delay(2000);
        }
    }
}

void loop() {
    client.loop();

    // Check IR sensor
    // if (digitalRead(ir) == 1) {
    //     itemCount++;
    //     delay(100); // small debounce delay to avoid multiple counts from one object
    // }

    // Check if 2 seconds have passed
    if (millis() - lastSendTime >= sendInterval) {
        // Read temperature
        float temperature = thermocouple.readCelsius();
        // Serial.print("Temperature: ");
        // Serial.println(temperature);

        // Publish item count
        String countStr = String(itemCount);
        client.publish(item_topic, countStr.c_str());
        // Serial.print("Sent item count: ");
        // Serial.println(itemCount);

        // Publish temperature
        String tempStr = String(temperature);
        client.publish(temp_topic, tempStr.c_str());
        // Serial.println("Sent temperature");

        // Reset for next interval
        itemCount = 0;
        lastSendTime = millis();
    }
}
