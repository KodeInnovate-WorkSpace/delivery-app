import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/add_to_cart_button.dart';

class Product {
  final String name;
  final String imageUrl;
  final double price;

  Product({required this.name, required this.imageUrl, required this.price});
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> _recentSearches = [];
  List<Product> _productSearches = [];
  final Map<String, int> _productCounts = {};

  @override
  void initState() {
    super.initState();
    _controller.addListener(filterProducts);
    fetchProductsFromFirestore();
    loadRecentSearches();
    loadProductSearches();
  }

  Future<void> fetchProductsFromFirestore() async {
    final productsCollection =
        FirebaseFirestore.instance.collection('products');
    final snapshot = await productsCollection.get();
    final products = snapshot.docs.map((doc) {
      return Product(
        name: doc['name'] as String,
        imageUrl: doc['image'] as String,
        price: doc['price'] is int
            ? (doc['price'] as int).toDouble()
            : doc['price'] as double,
      );
    }).toList();

    setState(() {
      _allProducts = products;
    });
  }

  Future<void> loadProductSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? productSearches =
        prefs.getStringList('productSearches');
    if (productSearches != null) {
      setState(() {
        _productSearches = productSearches.map((search) {
          final List<String> searchValues = search.split(',');
          return Product(
            name: searchValues[0],
            imageUrl: searchValues[1],
            price: double.parse(searchValues[2]),
          );
        }).toList();
      });
    }
  }

  Future<void> saveProductSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> productSearches = _productSearches.map((search) {
      return '${search.name},${search.imageUrl},${search.price}';
    }).toList();
    prefs.setStringList('productSearches', productSearches);
  }

  Future<void> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? recentSearches = prefs.getStringList('recentSearches');
    if (recentSearches != null) {
      setState(() {
        _recentSearches = recentSearches.map((search) {
          final List<String> searchValues = search.split(',');
          return Product(
            name: searchValues[0],
            imageUrl: searchValues[1],
            price: double.parse(searchValues[2]),
          );
        }).toList();
      });
    }
  }

  Future<void> saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> recentSearches = _recentSearches.map((search) {
      return '${search.name},${search.imageUrl},${search.price}';
    }).toList();
    prefs.setStringList('recentSearches', recentSearches);
  }

  void filterProducts() {
    final query = _controller.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts.clear();
      } else {
        _filteredProducts = _allProducts.where((product) {
          return product.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void saveSearch(Product product) {
    setState(() {
      _productSearches.clear();
      _productSearches.add(product);
      _recentSearches.removeWhere((p) => p.name == product.name);
      _recentSearches.insert(0, product);
      if (_recentSearches.length > 5) {
        _recentSearches = _recentSearches.sublist(0, 5);
      }
      _productCounts[product.name] = 0;
      saveRecentSearches();
      saveProductSearches(); // Save product searches
    });
  }

  void clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
      saveRecentSearches();
      _productSearches.clear();
      saveProductSearches(); // Clear product searches
    });
  }

  @override
  void dispose() {
    _controller.removeListener(filterProducts);
    _controller.dispose();
    super.dispose();
  }

  Widget searchBar() {
    return TextField(
      controller: _controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: 'Search for \'product\'',
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        prefixIcon: const Icon(Icons.search),
      ),
      style: const TextStyle(color: Colors.black),
      onTap: () {
        setState(() {});
      },
      onChanged: (value) {
        if (value.isEmpty) {
          clearSearch();
        }
      },
    );
  }

  void clearSearch() {
    setState(() {
      _productSearches.clear();
    });
  }

  Widget productCard(Product product) {
    return Card(
      color: const Color(0xffeaf1fc),
      child: ListTile(
        leading: Image.network(product.imageUrl, width: 50, height: 50),
        title: Text(product.name),
        onTap: () {
          saveSearch(product);
          // Navigate to product details page or any other action
        },
      ),
    );
  }

  Widget productSearchCard(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xffeaf1fc),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(product.imageUrl, width: 100, height: 100),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Price: ₹${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AddToCartButton(
                    productName: product.name,
                    productPrice: product.price.toInt(),
                    productImage: product.imageUrl,
                    productUnit:
                        "0", // Set product unit to 0 since it's not used
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget recentSearchCard(Product product) {
    return Card(
      color: const Color(0xffeaf1fc),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(product.imageUrl, width: 40, height: 40),
            const SizedBox(height: 5),
            Text(product.name),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Search')),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchBar(),
                    const SizedBox(height: 20),
                    if (_filteredProducts.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Search Results',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              return productCard(product);
                            },
                          ),
                        ],
                      ),
                    if (_recentSearches.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recently Searched',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          TextButton(
                            onPressed: clearRecentSearches,
                            child: const Text('Clear',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          itemCount: _recentSearches.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final recentSearch = _recentSearches[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: recentSearchCard(recentSearch),
                            );
                          },
                        ),
                      ),
                    ],
                    if (_productSearches.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Product Searches',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _productSearches.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final productSearch = _productSearches[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: productSearchCard(productSearch),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // checkout screen
            // Positioned(
            //   bottom: 25,
            //   right: 20,
            //   child: FloatingActionButton(
            //     hoverColor: Colors.transparent,
            //     elevation: 2,
            //     onPressed: () {
            //       HapticFeedback.heavyImpact();
            //
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const CheckoutScreen()));
            //       // Navigator.pushNamed(context, '/checkout');
            //     },
            //     backgroundColor: Colors.white,
            //     child: const Icon(
            //       Icons.shopping_cart_sharp,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
