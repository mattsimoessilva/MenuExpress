from django.urls import path
from .views import (
    ProductListCreateView,
    ProductRetrieveUpdateDestroyView,
    OrderListCreateView,
    OrderRetrieveUpdateDestroyView,
    CategoryListCreateView,
    CategoryRetrieveUpdateDestroyView,
    OrderItemListCreateView,
    OrderItemRetrieveUpdateDestroyView,
    LoginView,
    get_current_customer_id,
    get_user_orders,  # Importe a nova view
)
from django.contrib.auth import views as auth_views


app_name = 'orders'

urlpatterns = [
    path('products/', ProductListCreateView.as_view(), name='product-list'),
    path('products/<int:pk>/', ProductRetrieveUpdateDestroyView.as_view(), name='product-detail'),
    path('orders/', OrderListCreateView.as_view(), name='order-list'),
    path('orders/<int:pk>/', OrderRetrieveUpdateDestroyView.as_view(), name='order-detail'),
    path('orderitems/', OrderItemListCreateView.as_view(), name='order-item-list'),
    path('orderitems/<int:pk>/', OrderItemRetrieveUpdateDestroyView.as_view(), name='order-item-detail'),
    path('categories/', CategoryListCreateView.as_view(), name='category-list'),
    path('categories/<int:pk>/', CategoryRetrieveUpdateDestroyView.as_view(), name='category-detail'),
    path('login/', LoginView.as_view(), name='login'),
    path('current_customer_id/', get_current_customer_id, name='get_current_customer_id'),
    path('user_orders/<int:user_id>/', get_user_orders, name='user-orders'),  # Adicione a nova URL
]
