from django.db import models
from django.contrib.auth.models import AbstractUser
import uuid 


class CustomUser(AbstractUser):
    ROLE_CHOICES = (
        ('owner', 'Owner'),
        ('thekedar', 'Thekedar'),
    )
    groups = models.ManyToManyField(
        'auth.Group',
        related_name='custom_user_set',
        blank=True,
        help_text='The groups this user belongs to.',
        verbose_name='groups',
    )
    user_permissions = models.ManyToManyField(
        'auth.Permission',
        related_name='custom_user_set_permissions', 
        blank=True,
        help_text='Specific permissions for this user.',
        verbose_name='user permissions',
    )
    role = models.CharField(max_length=10, choices=ROLE_CHOICES)

class Labour(models.Model):
    id = models.UUIDField(primary_key = True,default = uuid.uuid4,editable = False)
    name = models.CharField(max_length=100)
    skill = models.CharField(max_length=100)
    thekedar = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='labours')
    
    def __str__(self):
        return self.name

class Stock(models.Model):
    item_name = models.CharField(max_length=100)
    quantity = models.PositiveIntegerField(default=0)
    is_counterfeit = models.BooleanField(default=False)
    owner = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='stock')
    
    def __str__(self):
        return self.item_name

class Task(models.Model):
    id = models.UUIDField(primary_key = True,default = uuid.uuid4,editable = False)
    status_choices=(
        ("complete","Complete"),
        ("pending","Pending"),
        ("overdue","Overdue")
    )
    task_name = models.CharField(max_length=200)
    description = models.TextField()
    status = models.CharField(max_length=20, choices=status_choices, default='pending')
    owner = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='assigned_tasks')
    thekedar = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='received_tasks')
    
    def __str__(self):
        return self.task_name


class Parchi(models.Model):
    id = models.UUIDField(primary_key = True,default = uuid.uuid4,editable = False)
    task = models.ForeignKey(Task, on_delete=models.CASCADE)
    labour = models.ForeignKey(Labour, on_delete=models.CASCADE)
    parchi_details = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Parchi for {self.labour.name} on task {self.task.task_name}"
    

# class Machine(models.Model):
#     name = models.CharField(max_length=100)
#     health_status = models.CharField(max_length=50, default='good')
#     thekedar = models.ForeignKey(User, on_delete=models.CASCADE, related_name='machines')
    
#     def __str__(self):
#         return self.name