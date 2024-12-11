import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['title'])),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display product image
              Center(
                child: Image.network(
                  product['image'],
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16),

              // Display product title
              Text(
                product['title'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Display product price
              Text(
                '₹${product['price']}',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              SizedBox(height: 8),

              // Display product rating
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  Text('${product['rating']['rate']}'),
                ],
              ),
              SizedBox(height: 16),

              // Display product description
              Text(
                product['description'],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Add to Cart button
              ElevatedButton(
                onPressed: () {
                  // Add product to the cart using context.read
                  context.read<CartProvider>().addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${product['title']} added to cart')),
                  );
                },
                child: Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full-width button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
