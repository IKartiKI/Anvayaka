# core/urls.py
from django.urls import path, include
from rest_framework import routers
from .views import LabourViewSet, StockViewSet, UserProfileViewSet, TaskViewSet, ParchiViewSet

router = routers.DefaultRouter()
router.register('labour', LabourViewSet)
router.register('stock', StockViewSet)
router.register('user-profile', UserProfileViewSet)
router.register('task', TaskViewSet)
router.register('parchi', ParchiViewSet)

urlpatterns = [
    path('', include(router.urls)),
]