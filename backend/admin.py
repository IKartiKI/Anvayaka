from django.contrib import admin
from .models import CustomUser,Labour,Stock,Task,Parchi
from django.contrib.auth.admin import UserAdmin


@admin.register(CustomUser)
class CustomUserAdmin(UserAdmin):
    # This displays the 'role' field in the user list view
    list_display = ('username', 'email', 'role', 'is_staff')
    
    # This adds the 'role' field to the user editing form
    fieldsets = UserAdmin.fieldsets + (
        (None, {'fields': ('role',)}),
    )


@admin.register(Labour)
class LabourAdmin(admin.ModelAdmin):
    list_display=['id', 'name', 'skill','thekedar']


@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    list_display=['id', 'task_name', 'description', 'status', 'owner', 'thekedar']


@admin.register(Stock)
class StockAdmin(admin.ModelAdmin):
    list_display= ['id', 'item_name', 'quantity', 'is_counterfeit']

@admin.register(Parchi)
class ParchiAdmin(admin.ModelAdmin):
    list_display= ['id', 'task', 'labour', 'parchi_details', 'created_at']

