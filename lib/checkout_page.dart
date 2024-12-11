import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  CheckoutPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    cartItems.forEach((item) {
      totalPrice += item['price'];
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final product = cartItems[index];
                        return Card(
                          child: ListTile(
                            leading: Image.network(product['image']),
                            title: Text(product['title']),
                            subtitle: Text('₹${product['price']}'),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ₹$totalPrice',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Order Placed Successfully!')));
                        },
                        child: Text('Place Order'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
