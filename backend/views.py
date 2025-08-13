from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import CustomUser, Labour, Stock, Task, Parchi
from .serializers import  LabourSerializer, StockSerializer, TaskSerializer, ParchiSerializer
from .permissions import IsOwner, IsThekedar
from rest_framework.response import Response
from django.contrib.auth import get_user_model




class OwnerLabourView(APIView):
    permission_classes=[IsOwner]

    def get(self,request):
        labours=Labour.objects.all()
        serializer=LabourSerializer(labours,many=True)
        return Response(serializer.data)

class OwnerStockView(APIView):
    permission_classes=[IsOwner]

    def get(self,request):
        total_stock_count=Stock.objects.aggregate(total_quantity=models.Sum('quantity'))['total_quantity'] or 0
        counterfeit_stock=Stock.objects.filter(is_counterfeit=True)
        counterfeit_serializer=StockSerializer(counterfeit_stock,many=True)

        return Response(
            {
                'total_stock':total_stock_count,
                "counterfeit_stock":counterfeit_serializer.data
            }
        )

class OwnerTaskViewSet(viewsets.ModelViewSet):
    permission_classes=[IsOwner]
    queryset=Task.objects.all()
    serializer=TaskSerializer

    def get_queryset(self):
        return self.queryset.filter(owner=self.request.user)
    
    def perform_create(self,serializer):
        serializer.save(owner=self.request.user)
    

class ThekedarLabourView(APIView):
    permission_classes = [IsThekedar]
    
    def get(self, request):
        # Thekedar can only see their own labourers
        labours = Labour.objects.filter(thekedar=request.user)
        serializer = LabourSerializer(labours, many=True)
        return Response(serializer.data)

class ThekedarParchiView(APIView):
    permission_classes = [IsThekedar]
    
    def post(self, request):
        serializer = ParchiSerializer(data=request.data)
        if serializer.is_valid():
            # Check if the labourer belongs to the thekedar
            labour_id = serializer.validated_data['labour'].id
            if not Labour.objects.filter(id=labour_id, thekedar=request.user).exists():
                return Response(
                    {'error': 'This labourer does not belong to you.'},
                    status=status.HTTP_403_FORBIDDEN
                )
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ThekedarStockView(APIView):
    permission_classes = [IsThekedar]
    
    def get(self, request):
        total_stock_count = Stock.objects.aggregate(total_quantity=models.Sum('quantity'))['total_quantity'] or 0
        counterfeit_stock = Stock.objects.filter(is_counterfeit=True)
        counterfeit_serializer = StockSerializer(counterfeit_stock, many=True)
        
        return Response({
            'total_stock': total_stock_count,
            'counterfeit_stock': counterfeit_serializer.data
        })