import 'package:flutter/material.dart';
import 'package:speedy_delivery/screens/demo_screen.dart';

class CategoryScreen extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final String categoryTitle;

  const CategoryScreen(
      {super.key,
      required this.categoryTitle,
      this.imageWidth = 90.0,
      this.imageHeight = 90.0});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  // Sample data
  List<String> mainCategoriesImages = [
    'assets/categories/electronics.png',
    'assets/categories/cleaners.png',
    'assets/categories/lays.png',
    'assets/categories/electronics.png',
    'assets/categories/cleaners.png',
    'assets/categories/lays.png',
    'assets/categories/electronics.png',
    'assets/categories/cleaners.png',
    'assets/categories/lays.png', // Added
    'assets/categories/electronics.png',
    'assets/categories/cleaners.png', // Added
  ];
  List<String> mainCategoriesNames = [
    'Electronics',
    'Cleaners & Repellents',
    'Chips & Namkeen',
    'Vegetables',
    'Fruits',
    'Drinks',
    'Books', // Added
    'Clothes', // Added
    'Shoes', // Added
    'Furniture', // Added
    'Toys', // Added
  ];
  Map<String, List<Map<String, String>>> subCategories = {
    'Electronics': [
      {
        'name': 'Smart Watch',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Earpods',
        'image': 'assets/subcategories/Electronics/earpods.png'
      },
      {
        'name': 'Speaker',
        'image': 'assets/subcategories/Electronics/speakers.png'
      },
      {
        'name': 'Mobiles',
        'image': 'assets/subcategories/Electronics/mobiles.png'
      },
      {
        'name': 'Home Appliances',
        'image': 'assets/subcategories/Electronics/iron.png'
      },
      {
        'name': 'Trimmer',
        'image': 'assets/subcategories/Electronics/trimmer.png'
      },
    ],
    'Cleaners & Repellents': [
      {
        'name': 'Detergent',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Toilet Cleaner',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Floor Cleaner',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Garbage Bags',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Shoe Cleaner',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Cleaning Tools',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      }
    ],
    'Chips & Namkeen': [
      {
        'name': 'Chips',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Bhujia',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Nachos',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Popcorn',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Papad',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Healthy Snacks',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
    ],
    'Vegetables': [
      {
        'name': 'Tomato',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Carrot',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Onion',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Cucumber',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Capsicum',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Potato',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
    ],
    'Fruits': [
      {
        'name': 'Apple',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Banana',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Orange',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Grapes',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Mango',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Pineapple',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
    ],
    'Drinks': [
      {
        'name': 'Water',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Juice',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Soda',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Tea',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Coffee',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Energy Drinks',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
    ],
    'Books': [
      // Added
      {
        'name': 'Fiction',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Non-fiction',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Biographies',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Self-help',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Educational',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Children',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
    ],
    'Clothes': [
      // Added
      {
        'name': 'T-shirts',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Jeans',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Dresses',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Shirts',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Sweaters',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Jackets',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
    ],
    'Shoes': [
      // Added
      {
        'name': 'Sneakers',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Boots',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Sandals',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Flats',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Heels',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Athletic Shoes',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
    ],
    'Furniture': [
      // Added
      {
        'name': 'Sofas',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Beds',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Chairs',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Tables',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Cabinets',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Desks',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
    ],
    'Toys': [
      // Added
      {
        'name': 'Action Figures',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Dolls',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Board Games',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Puzzles',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Remote Control Toys',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Building Sets',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Building Sets',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Building Sets',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Building Sets',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Building Sets',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Building Sets',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
      {
        'name': 'Building Sets',
        'image': 'assets/subcategories/Electronics/smartwatch.png'
      },
    ],
  };
  String selectedCategory = 'Electronics';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryTitle,
        ),
      ),
      body: Row(
        children: [
          Container(
            width: 80,
            color: Colors.amberAccent, // Set background color of navbar
            child: ListView.builder(
              itemCount: mainCategoriesNames.length +
                  1, // Add 1 for the "Categories" text
              itemBuilder: (context, index) {
                // Check if it's the first item to display "Categories" text
                if (index == 0) {
                  return const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
                // Otherwise, display the categories
                index -=
                    1; // Subtract 1 to account for the added "Categories" text

                // side navbar

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = mainCategoriesNames[index];
                    });
                  },
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(15), // Circular border radius
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      color: selectedCategory == mainCategoriesNames[index]
                          ? Colors
                              .white // Set background color for selected category
                          : Colors
                              .amberAccent, // Set background color for unselected categories
                      child: Column(
                        children: [
                          Image.asset(
                            mainCategoriesImages[index],
                            width: widget
                                .imageWidth, // Adjust width using widget parameter
                            height: widget
                                .imageHeight, // Adjust height using widget parameter
                          ),
                          Text(
                            mainCategoriesNames[index],
                            style: TextStyle(
                              color: selectedCategory ==
                                      mainCategoriesNames[index]
                                  ? Colors
                                      .black // Set text color for selected category
                                  : Colors
                                      .black, // Set text color for unselected categories
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // products list

          Expanded(
            child: Container(
              color: Colors.white, // Set background color of content area
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      selectedCategory,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey[
                          200], // Set background color of subcategories section
                      child: ListView.builder(
                        itemCount: subCategories[selectedCategory]!.length,
                        itemBuilder: (context, index) {
                          // Wrap each subcategory in a different section
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DemoPage()),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 22.0), // Add margin
                              elevation:
                                  2.0, // Add elevation for a shadow effect
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 9.0), // Adjust padding
                                leading: Image.asset(
                                  subCategories[selectedCategory]![index]
                                      ['image']!,
                                  width: widget
                                      .imageWidth, // Adjust width using widget parameter
                                  height: widget
                                      .imageHeight, // Adjust height using widget parameter
                                ),
                                // title: Text(
                                //   subCategories[selectedCategory]![index]
                                //       ['name']!,
                                //   style: const TextStyle(
                                //       fontSize: 14.0), // Adjust font size
                                // ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
