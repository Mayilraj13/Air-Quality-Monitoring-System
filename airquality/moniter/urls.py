from django.urls import path # type: ignore
from . import views

urlpatterns = [
    path('', views.dashboard, name='dashboard'),
    path('get-air-data/', views.get_air_data, name='get_air_data'),
]
