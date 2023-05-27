from django.urls import path
from .views import ProductListCreateView, ProductRetrieveUpdateDestroyView, OrderListCreateView, OrderRetrieveUpdateDestroyView, CustomerListCreateView, CustomerRetrieveUpdateDestroyView, CategoryListCreateView, CategoryRetrieveUpdateDestroyView, LoginView

app_name = 'orders'

urlpatterns = [
    path('products/', ProductListCreateView.as_view(), name='product-list'),
    path('products/<int:pk>/', ProductRetrieveUpdateDestroyView.as_view(), name='product-detail'),
    path('orders/', OrderListCreateView.as_view(), name='order-list'),
    path('orders/<int:pk>/', OrderRetrieveUpdateDestroyView.as_view(), name='order-detail'),
    path('customers/', CustomerListCreateView.as_view(), name='customer-list'),
    path('customers/<int:pk>/', CustomerRetrieveUpdateDestroyView.as_view(), name='customer-detail'),
    path('categories/', CategoryListCreateView.as_view(), name='category-list'),
    path('categories/<int:pk>/', CategoryRetrieveUpdateDestroyView.as_view(), name='category-detail'),
    path('login/', LoginView.as_view(), name='login'),  # Adicione essa linha para a rota de login
]
