import os
import django
import paho.mqtt.client as mqtt
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from backend.models import Task

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'AnvayakaBackend.settings')
django.setup()

channel_layer = get_channel_layer()

item_count = 0

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("emqx/esp32/temperature")
    client.subscribe("emqx/esp32/item")

def on_message(client, userdata, msg):
    global item_count
    print(f"Received {msg.payload.decode()} from {msg.topic}")
    
    try:
        if msg.topic == "emqx/esp32/temperature":
            data = {'type': 'temperature', 'value': float(msg.payload.decode())}
        elif msg.topic == "emqx/esp32/item":
            new_item_value = int(msg.payload.decode())
            if new_item_value:
                item_count += new_item_value 
            
            data = {'type': 'item', 'value': item_count}
            print(f"Total items counted: {item_count}") 
            
            task = Task.objects.get(id='e065415b-6f99-4463-a9dd-1b99d833c8d7')
            
            task.completed_quantity += new_item_value 
            task.save()
        else:
            return

        async_to_sync(channel_layer.group_send)(
            'sensor_data_group', 
            {
                'type': 'send_sensor_data',
                'data': data
            }
        )
    except (ValueError, TypeError) as e:
        print(f"Error processing message: {e}")

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.username_pw_set("emqx", "public") 

client.connect("broker.emqx.io", 1883, 60)

client.loop_forever()