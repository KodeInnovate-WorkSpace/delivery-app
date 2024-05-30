import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String imageUrl;

  Product({required this.name, required this.imageUrl});
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(filterProducts);
    fetchProductsFromFirestore();
  }

  Future<void> fetchProductsFromFirestore() async {
    final productsCollection = FirebaseFirestore.instance.collection('products');
    final snapshot = await productsCollection.get();
    final products = snapshot.docs.map((doc) {
      return Product(
        name: doc['name'] as String,
        imageUrl: doc['image'] as String,
      );
    }).toList();

    setState(() {
      _allProducts = products;
    });
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
      _recentSearches.removeWhere((p) => p.name == product.name); // Remove if already exists to avoid duplicates
      _recentSearches.insert(0, product); // Insert at the beginning
      if (_recentSearches.length > 5) {
        _recentSearches = _recentSearches.sublist(0, 5); // Keep only the last 5 searches
      }
    });
  }

  void clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
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
        prefixIcon: const Icon(
          Icons.search,
        ),
      ),
      style: const TextStyle(color: Colors.black),
      onTap: () {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchBar(),
            const SizedBox(height: 10),
            if (_filteredProducts.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ListTile(
                        leading: Image.network(product.imageUrl, width: 50, height: 50),
                        title: Text(product.name),
                        onTap: () {
                          saveSearch(product);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => DemoPage(),
                          //   ),
                          // );
                        },
                      );
                    },
                  ),
                ],
              ),
            if (_recentSearches.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recently Searched',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: clearRecentSearches,
                    child: const Text('Clear', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              SizedBox(
                height: 150, // Adjust the height as needed
                child: ListView.builder(
                  itemCount: _recentSearches.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final recentSearch = _recentSearches[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          Image.network(recentSearch.imageUrl, width: 50, height: 50),
                          const SizedBox(height: 5),
                          Text(recentSearch.name),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}