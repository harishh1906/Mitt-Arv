import 'cart_page.dart';
import 'package:flutter/material.dart';
import 'cart_provider.dart';
import 'product.dart';
import 'product_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  String _selectedSortOption = 'Price';

  bool _isLoading = false;
  int _page = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://fakestoreapi.com/products?limit=$_limit&page=$_page'));

    if (response.statusCode == 200) {
      final List<dynamic> productData = json.decode(response.body);
      List<Map<String, dynamic>> newProducts = productData.map((product) {
        return {
          'id': product['id'],
          'title': product['title'],
          'price': product['price'],
          'rating': product['rating'],
          'image': product['image'],
          'description': product['description'],
        };
      }).toList();

      setState(() {
        _products.addAll(newProducts);
        _filteredProducts = List.from(_products);
        _isLoading = false;
        _page++;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _filterProducts(String query) {
    final filtered = _products.where((product) {
      final productName = product['title'].toLowerCase();
      final input = query.toLowerCase();
      return productName.contains(input);
    }).toList();

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _sortProducts() {
    switch (_selectedSortOption) {
      case 'Price':
        _filteredProducts.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Rating':
        _filteredProducts
            .sort((a, b) => a['rating']['rate'].compareTo(b['rating']['rate']));
        break;
      case 'Popularity':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mitt Arv'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _filterProducts(query);
              },
              decoration: InputDecoration(
                labelText: 'Search for products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedSortOption,
              items: <String>['Price', 'Rating', 'Popularity']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSortOption = newValue!;
                });
                _sortProducts();
              },
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !_isLoading) {
                  _fetchProducts();
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                itemCount: _filteredProducts.length + 1,
                itemBuilder: (context, index) {
                  if (index == _filteredProducts.length) {
                    return _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Container();
                  }

                  final product = _filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: Image.network(product['image']),
                        title: Text(product['title']),
                        subtitle: Text(
                            '₹${product['price']} - ${product['rating']['rate']} Stars'),
                        trailing: IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            // Add product to cart
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage()),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
