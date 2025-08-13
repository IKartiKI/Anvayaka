from rest_framework import serializers
from .models import CustomUser, Labour, Stock, Task,  Parchi

class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'email', 'role']

class LabourSerializer(serializers.ModelSerializer):
    class Meta:
        model = Labour
        fields = ['id', 'name', 'skill']

class StockSerializer(serializers.ModelSerializer):
    class Meta:
        model = Stock
        fields = ['id', 'item_name', 'quantity', 'is_counterfeit']

class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = ['id', 'task_name', 'description', 'status', 'owner', 'thekedar']
        read_only_fields = ['owner'] # Owner is set by the request user


class ParchiSerializer(serializers.ModelSerializer):
    class Meta:
        model = Parchi
        fields = ['id', 'task', 'labour', 'parchi_details', 'created_at']