from django.urls import path
from .views import ProductListCreateView, ProductRetrieveUpdateDestroyView, OrderListCreateView, OrderRetrieveUpdateDestroyView, CategoryListCreateView, CategoryRetrieveUpdateDestroyView, LoginView, get_current_customer_id
from django.contrib.auth import views as auth_views


app_name = 'orders'

urlpatterns = [
    path('products/', ProductListCreateView.as_view(), name='product-list'),
    path('products/<int:pk>/', ProductRetrieveUpdateDestroyView.as_view(), name='product-detail'),
    path('orders/', OrderListCreateView.as_view(), name='order-list'),
    path('orders/<int:pk>/', OrderRetrieveUpdateDestroyView.as_view(), name='order-detail'),
    path('categories/', CategoryListCreateView.as_view(), name='category-list'),
    path('categories/<int:pk>/', CategoryRetrieveUpdateDestroyView.as_view(), name='category-detail'),
    path('login/', LoginView.as_view(), name='login'),
    path('current_customer_id/', get_current_customer_id, name='get_current_customer_id'),
]
