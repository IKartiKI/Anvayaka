# core/admin.py
from django.contrib import admin
from .models import Labour, Stock, UserProfile, Task, Parchi

class LabourAdmin(admin.ModelAdmin):
    list_display = ('id','name', 'age', 'expertise')
    search_fields = ('name', 'expertise')

class StockAdmin(admin.ModelAdmin):
    list_display = ('id','name', 'type', 'quantity')
    search_fields = ('name', 'type')

class UserProfileAdmin(admin.ModelAdmin):
    list_display = ['username','role']
    search_fields = ['role']

class TaskAdmin(admin.ModelAdmin):
    list_display = ('id','name', 'description')
    search_fields = ('name', 'description')

# core/admin.py
from django.contrib import admin
from .models import Labour, Stock, UserProfile, Task, Parchi

class ParchiAdmin(admin.ModelAdmin):
    list_display = ('id','details','task','labour','deliverable','deadline')
    search_fields = ('labour__name', 'stock__name')

admin.site.register(Parchi, ParchiAdmin)
admin.site.register(Labour, LabourAdmin)
admin.site.register(Stock, StockAdmin)
admin.site.register(UserProfile, UserProfileAdmin)
admin.site.register(Task, TaskAdmin)