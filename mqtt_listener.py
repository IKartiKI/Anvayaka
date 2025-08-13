# mqtt_listener.py

import os
import django
import paho.mqtt.client as mqtt
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync

# Set up the Django environment
# Replace 'your_project' with the actual name of your Django project
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'AnvayakaBackend.settings')
django.setup()

# Get the channel layer instance
channel_layer = get_channel_layer()

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("emqx/esp32/temperature")
    client.subscribe("emqx/esp32/item")

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    print(f"Received {msg.payload.decode()} from {msg.topic}")
    
    # Process and format the data
    try:
        if msg.topic == "emqx/esp32/temperature":
            data = {'type': 'temperature', 'value': float(msg.payload.decode())}
        elif msg.topic == "emqx/esp32/item":
            data = {'type': 'item', 'value': int(msg.payload.decode())}
        else:
            return

        # Send the data to the channel layer group
        async_to_sync(channel_layer.group_send)(
            'sensor_data_group', # The group name from your consumer
            {
                'type': 'send_sensor_data', # The name of the method in your consumer
                'data': data
            }
        )
    except (ValueError, TypeError) as e:
        print(f"Error processing message: {e}")
        # Add your Django logic here to save the data to a model if you need to
        # from sensor_data.models import TemperatureData, ItemDetection
        # if data['type'] == 'temperature':
        #    TemperatureData.objects.create(value=data['value'])
        # elif data['type'] == 'item':
        #    ItemDetection.objects.create(value=data['value'])


# Create a new MQTT client instance
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# Set the same credentials as your ESP32
client.username_pw_set("emqx", "public") 

# Connect to the public MQTT broker
client.connect("broker.emqx.io", 1883, 60)

# Start the blocking loop that listens for messages
client.loop_forever()