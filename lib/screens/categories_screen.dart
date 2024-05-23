import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_delivery/providers/category_provider.dart';
import 'package:speedy_delivery/screens/demo_screen.dart';

import '../widget/side_navbar.dart';

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
  bool _isClicked = false;
  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryTitle,
        ),
      ),
      body: Row(
        children: [
          // side navbar
          sideNavbar(context),

          // products list
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: GridView.builder(
                itemCount: categoryProvider.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  mainAxisSpacing: 5.0, // Spacing between rows
                  crossAxisSpacing: 5.0, // Spacing between columns
                  childAspectRatio: 0.58,
                ),
                itemBuilder: (context, index) {
                  // final item = categoryProvider.selectedSubCategory?.name[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DemoPage()), // Update with your actual page
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            6.0), // Set the border radius here
                      ),
                      color: Colors.white,
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Adjust padding
                            Center(
                                child: Image.network(
                              width: 90,
                              "https://firebasestorage.googleapis.com/v0/b/speedy-app-e17a5.appspot.com/o/images%2Fblack_pepper_masala.png?alt=media&token=38266974-fadb-4613-b724-83ef4b66e1b0",
                            )), // Replace with your actual content
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "MDH Black Pepper Powder",
                              style: TextStyle(fontFamily: 'Gilroy-SemiBold'),
                            ), // Replace with your actual data field
                            const Text(
                              "100g",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "\u20B9 78",
                                  style: TextStyle(
                                    fontFamily: "Gilroy-medium",
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isClicked = !_isClicked;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: _isClicked
                                        ? WidgetStateProperty.all<Color>(
                                            Colors.green)
                                        : WidgetStateProperty.all<Color>(
                                            Colors.transparent),
                                    overlayColor:
                                        WidgetStateProperty.resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.hovered)) {
                                        return Colors.green.withOpacity(0.1);
                                      }
                                      if (states
                                          .contains(WidgetState.pressed)) {
                                        return Colors.green.withOpacity(0.3);
                                      }
                                      return Colors.green.withOpacity(0.6);
                                    }),
                                    side: WidgetStateProperty.all<BorderSide>(
                                        const BorderSide(
                                            color:
                                                Colors.green)), // Outline color
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                4)), // No border radius
                                      ),
                                    ),
                                    minimumSize: WidgetStateProperty.all<Size>(
                                        const Size(25, 30)),
                                  ),
                                  child: Text(
                                    _isClicked ? "- 1 +" : "Add",
                                    style: TextStyle(
                                      color: _isClicked
                                          ? Colors.white
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
