import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_delivery/widget/cart_button.dart';
import '../models/product_model.dart';
import '../providers/auth_provider.dart';
import '../widget/add_to_cart_button.dart'; // Import your cart screen

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

  @override
  void initState() {
    super.initState();
    _controller.addListener(filterProducts);
    fetchProductsFromFirestore();
    loadRecentSearches();
    loadProductSearches();
  }

  Future<void> fetchProductsFromFirestore() async {
    try {
      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('category')
          .where('status', isEqualTo: 1)
          .get();

      final List<int> activeCategoryIds = categoriesSnapshot.docs
          .map((doc) => doc['category_id'] as int)
          .toList();

      final subCategoriesSnapshot = await FirebaseFirestore.instance
          .collection('sub_category')
          .where('category_id', whereIn: activeCategoryIds)
          .where('status', isEqualTo: 1)
          .get();

      final List<int> activeSubCategoryIds = subCategoriesSnapshot.docs
          .map((doc) => doc['sub_category_id'] as int)
          .toList();

      List<Product> products = [];
      const int batchSize = 30;

      for (int i = 0; i < activeSubCategoryIds.length; i += batchSize) {
        final batch = activeSubCategoryIds.sublist(
            i,
            i + batchSize > activeSubCategoryIds.length
                ? activeSubCategoryIds.length
                : i + batchSize);

        final productsSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('status', isEqualTo: 1)
            .where('sub_category_id', whereIn: batch.isNotEmpty ? batch : [0]) // Avoid empty query
            .get();

        products.addAll(productsSnapshot.docs.map((doc) {
          return Product(
            name: doc['name'] as String,
            price: doc['price'],
            mrp: doc['mrp'],
            id: doc['id'],
            image: doc['image'],
            stock: doc['stock'],
            unit: doc['unit'],
            subCatId: doc['sub_category_id'],
            status: doc['status'],
            isVeg: doc.data().containsKey('isVeg') ? doc['isVeg'] as bool : false, // Check for field presence
          );
        }));
      }

      setState(() {
        _allProducts = products;
      });
    } catch (e) {
      debugPrint("$e");
    }
  }




  Future<void> loadProductSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? productSearches = prefs.getStringList('productSearches');
      if (productSearches != null) {
        setState(() {
          _productSearches = productSearches.map((search) {
            final List<String> searchValues = search.split(',');
            return Product(
              name: searchValues[0],
              image: searchValues[1],
              price: int.parse(searchValues[2]),
              mrp: int.parse(searchValues[2]),
              id: int.parse(searchValues[3]),
              stock: int.parse(searchValues[4]),
              unit: searchValues[5],
              subCatId: int.parse(searchValues[6]),
              status: int.parse(searchValues[7]),
            );
          }).toList();
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> saveProductSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> productSearches = _productSearches.map((search) {
        return '${search.name},${search.image},${search.price}';
      }).toList();
      prefs.setStringList('productSearches', productSearches);
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? recentSearches = prefs.getStringList('recentSearches');
      if (recentSearches != null) {
        setState(() {
          _recentSearches = recentSearches.map((search) {
            final List<String> searchValues = search.split(',');
            return Product(
              name: searchValues[0],
              image: searchValues[1],
              price: int.parse(searchValues[2]),
              mrp: int.parse(searchValues[2]),
              id: int.parse(searchValues[3]),
              stock: int.parse(searchValues[4]),
              unit: searchValues[5],
              subCatId: int.parse(searchValues[6]),
              status: int.parse(searchValues[7]),
            );
          }).toList();
        });
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> recentSearches = _recentSearches.map((search) {
      return '${search.name},${search.image},${search.price}';
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
      saveRecentSearches();
      saveProductSearches();
    });
  }

  void clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
      saveRecentSearches();
      _productSearches.clear();
      saveProductSearches();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(filterProducts);
    _controller.dispose();
    super.dispose();
  }

  void showExpandedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(imageUrl),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: clearSearch,
        )
            : null,
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
      _controller.clear();
      _filteredProducts.clear();
    });
  }
  Widget productCard(Product product) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Stack(
        children: [
          ListTile(
            // leading: GestureDetector(
            //   onTap: () {
            //     showExpandedImage(context, product.image);
            //   },
            //   child: Image.network(product.image, width: 50, height: 50),
            // ),
            title: Text(product.name),
            onTap: () {
              saveSearch(product);
            },
          ),
        ],
      ),
    );
  }
  Widget productSearchCard(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (product.image.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        showExpandedImage(context, product.image);
                      },
                      child: Image.network(product.image, width: 100, height: 100),
                    ),
                  if (product.image.isNotEmpty) const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rs.${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(color: Color(0xff1c1c1c)),
                            ),
                            Text(
                              "Rs.${product.mrp.toString()}",
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AddToCartButton(
                          productName: product.name,
                          productPrice: product.price.toInt(),
                          productImage: product.image,
                          productUnit: product.unit,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (product.isVeg)
              Positioned(
                top: 4,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            if (product.isVeg)
              Positioned(
                top: 8,
                right: 12,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.circle, color: Colors.green, size: 12),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }



  Widget recentSearchCard(Product product) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // GestureDetector(
                //   onTap: () {
                //     showExpandedImage(context, product.image);
                //   },
                //   child: Image.network(product.image, width: 40, height: 40),
                // ),
                const SizedBox(height: 5),
                Text(product.name),
              ],
            ),
          ),
          // if (product.isVeg)
          //   Positioned(
          //     top: 0,
          //     left: 0,
          //     child: Container(
          //       width: 20,
          //       height: 20,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: Colors.green,
          //         border: Border.all(color: Colors.white, width: 2),
          //       ),
          //       child: const Icon(Icons.circle, color: Colors.green, size: 14),
          //     ),
          //   ),
        ],
      ),
    );
  }



  Widget _searchListView() {
    if (_productSearches.isEmpty) {
      return _recentSearchListView();
    } else {
      return ListView.builder(
        itemCount: _productSearches.length,
        itemBuilder: (context, index) {
          final product = _productSearches[index];
          return productSearchCard(product);
        },
      );
    }
  }

  Widget _recentSearchListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Recent Searches',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: _recentSearches.length,
            itemBuilder: (context, index) {
              final product = _recentSearches[index];
              return recentSearchCard(product);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search'),
        backgroundColor: const Color(0xfff7f7f7),
        elevation: 0,
      ),
      backgroundColor: const Color(0xfff7f7f7),
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
                    if (_productSearches.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Product Searches',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 140,
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
                    const SizedBox(height: 10),
                    if (_filteredProducts.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Search Results',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    if (_filteredProducts.isEmpty && _controller.text.isNotEmpty)
                      Text(
                        'Product not found',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[600]),
                      ),
                    if (_recentSearches.isNotEmpty) ...[
                      const SizedBox(height: 20),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
