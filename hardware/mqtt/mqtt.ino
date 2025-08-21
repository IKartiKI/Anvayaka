#include "WiFi.h"
#include <PubSubClient.h>
#include "max6675.h"

// WiFi
const char *ssid = "Qwertyuiop";
const char *password = "123456789";

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
const unsigned long sendInterval = 2000; // 2 seconds


void setup() {
    Serial.begin(115200);
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
    // Check if 2 seconds have passed
    if (millis() - lastSendTime >= sendInterval) {
      String item = String(random(1,10));
      String temp = String(random(50, 60));
        client.publish(item_topic, item.c_str());
        client.publish(temp_topic, temp.c_str());
        lastSendTime = millis();
        Serial.print("Item: ");
        Serial.print(item);
        Serial.print("\t");
        Serial.print("Temperature: ");
        Serial.println(temp);
    }
}
