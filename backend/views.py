# core/views.py
from rest_framework import viewsets
from .models import Labour, Stock, UserProfile, Task, Parchi
from .serializers import LabourSerializer, StockSerializer, UserProfileSerializer, TaskSerializer, ParchiSerializer

class LabourViewSet(viewsets.ModelViewSet):
    queryset = Labour.objects.all()
    serializer_class = LabourSerializer

class StockViewSet(viewsets.ModelViewSet):
    queryset = Stock.objects.all()
    serializer_class = StockSerializer

class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer

class TaskViewSet(viewsets.ModelViewSet):
    queryset = Task.objects.all()
    serializer_class = TaskSerializer

class ParchiViewSet(viewsets.ModelViewSet):
    queryset = Parchi.objects.all()
    serializer_class = ParchiSerializer