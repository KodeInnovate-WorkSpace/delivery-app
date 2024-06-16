import 'package:flutter/material.dart';

class HomeSkeleton extends StatefulWidget {
  const HomeSkeleton({super.key});

  @override
  HomeSkeletonState createState() => HomeSkeletonState();
}

class HomeSkeletonState extends State<HomeSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align everything to the left
          children: [
            const SizedBox(height: 15),
            Stack(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20), // Add SizedBox for spacing
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            skeletonBox(60, 15),
                            const SizedBox(height: 12),
                            skeletonBox(130, 24),
                            const SizedBox(height: 10),
                            skeletonBox(230, 20),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 90),
                  ],
                ),
                Positioned(
                  top: 27,
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ],
            ),

            // Search bar
            skeletonBox(340, 45),

            // Categories
            const SizedBox(height: 20),

            // Category Name
            skeletonBox(150, 20),
            const SizedBox(height: 20),
            // sub-categories
            Row(
              children: [
                skeletonBox(70, 70),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 70),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 70),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 70),
              ],
            ),

            // Category Name
            const SizedBox(height: 50),
            skeletonBox(150, 20),
            const SizedBox(height: 20),
            // sub-categories
            Row(
              children: [
                skeletonBox(70, 70),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 70),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 70),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 70),
              ],
            ),

            // Category Name
            const SizedBox(height: 50),
            skeletonBox(150, 20),
            const SizedBox(height: 20),
            // sub-categories
            Row(
              children: [
                skeletonBox(70, 70),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 70),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 70),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 70),
              ],
            ),

            // Category Name
            const SizedBox(height: 50),
            skeletonBox(150, 20),
            const SizedBox(height: 20),

            // sub-categories
            Row(
              children: [
                skeletonBox(70, 50),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 50),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 50),
                const SizedBox(
                  width: 16.5,
                ),
                skeletonBox(70, 50),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget skeletonBox(double wid, double hig) {
    return Container(
      width: wid,
      height: hig,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
