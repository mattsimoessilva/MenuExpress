from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth import authenticate, login, logout
from .serializers import ProductSerializer, OrderSerializer, CategorySerializer, UserSerializer, OrderItemSerializer
from .models import Product, Order, Category, OrderItem
from django.contrib.auth.models import User
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.contrib.auth.decorators import login_required


class ProductListCreateView(generics.ListCreateAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer


class ProductRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer


class OrderListCreateView(generics.ListCreateAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer


class OrderRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer


class OrderItemListCreateView(generics.ListCreateAPIView):
    queryset = OrderItem.objects.all()
    serializer_class = OrderItemSerializer


class OrderItemRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = OrderItem.objects.all()
    serializer_class = OrderItemSerializer


class CustomerRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer


class CategoryListCreateView(generics.ListCreateAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer


class CategoryRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer


class LoginView(APIView):
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        # Autenticar o usuário
        user = authenticate(request, username=username, password=password)

        if user is not None:
            # Efetuar o login do usuário
            login(request, user)

            response = Response()
            response.set_cookie(key='token', value=request.session.session_key, httponly=True)  # Defina o token no cookie

            print(request.session.session_key)

            return response
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)


@api_view(['GET'])
def get_current_customer_id(request):
    print(request.user.id)
    customer_id = request.user.id  # Obtém o ID do cliente atual a partir do usuário autenticado
    return Response({'customer_id': customer_id})

@api_view(['GET'])
def get_user_orders(request, user_id):
    orders = Order.objects.filter(customer=user_id)
    order_items = OrderItem.objects.filter(order__customer=user_id)

    orders_data = []

    for order in orders:
        order_data = {
            'order': OrderSerializer(order).data,
            'status': order.status,
            'items': []
        }

        items = order_items.filter(order=order)

        for item in items:
            item_data = {
                'item': OrderItemSerializer(item).data,
                'quantity': item.quantity
            }
            order_data['items'].append(item_data)

        orders_data.append(order_data)

    return Response({'orders': orders_data})

