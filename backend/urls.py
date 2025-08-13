from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    OwnerLabourView, OwnerStockView, OwnerTaskViewSet,
    ThekedarLabourView, ThekedarParchiView, ThekedarStockView
)

# Use a router for the ViewSet to automatically create URL patterns for CRUD operations
router = DefaultRouter()
router.register('owner/tasks', OwnerTaskViewSet, basename='owner-tasks')

urlpatterns = [
    path('owner/labours/', OwnerLabourView.as_view(), name='owner-labours'),
    path('owner/stock/', OwnerStockView.as_view(), name='owner-stock'),
    path('owner/task/', include(router.urls)),  # This includes the ViewSet URLs for owner tasks

    # Thekedar-specific URLs
    path('thekedar/labours/', ThekedarLabourView.as_view(), name='thekedar-labours'),
    path('thekedar/parchi/', ThekedarParchiView.as_view(), name='thekedar-parchi'),
    path('thekedar/stock/', ThekedarStockView.as_view(), name='thekedar-stock'),
]