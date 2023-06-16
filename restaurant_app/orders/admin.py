from django.contrib import admin
from .models import User, Product, Category, Order, OrderItem

admin.site.register(Product)
admin.site.register(Category)
admin.site.register(Order)
admin.site.register(OrderItem)
