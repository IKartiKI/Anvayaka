from rest_framework.permissions import IsAuthenticated

class IsOwnerOrThekedar(IsAuthenticated):
    def has_permission(self, request, view):
        return super().has_permission(request, view) and (request.user.role in ['owner', 'thekedar'])

# A custom permission to check if the user is an owner
class IsOwner(IsAuthenticated):
    def has_permission(self, request, view):
        return super().has_permission(request, view) and request.user.role == 'owner'

# A custom permission to check if the user is a thekedar
class IsThekedar(IsAuthenticated):
    def has_permission(self, request, view):
        return super().has_permission(request, view) and request.user.role == 'thekedar'


