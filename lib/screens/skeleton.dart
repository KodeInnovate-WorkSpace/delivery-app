import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // Top section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerContainer(width: 100, height: 10),
                  const SizedBox(height: 10),

                  // Delivery time and location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildShimmerContainer(width: 160, height: 25),
                      _buildShimmerContainer(width: 50, height: 50, borderRadius: 25),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Search bar
                  _buildShimmerContainer(width: double.infinity, height: 50),
                  const SizedBox(height: 20),

                  // Ad card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildShimmerContainer(width: 272, height: 172, borderRadius: 12),
                      const SizedBox(width: 15),
                      _buildShimmerContainer(width: 20, height: 172, borderRadius: 6),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Category name
                  _buildShimmerContainer(width: 160, height: 25),
                  const SizedBox(height: 20),

                  // Sub-category rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _buildShimmerContainer(width: 72, height: 72, borderRadius: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _buildShimmerContainer(width: 72, height: 72, borderRadius: 14),
                      ),
                    ),
                  ),

                  // Second category name
                  const SizedBox(height: 20),
                  _buildShimmerContainer(width: 160, height: 25),

                  // Second sub-category rows
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _buildShimmerContainer(width: 72, height: 65, borderRadius: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerContainer({required double width, required double height, double borderRadius = 5}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    );
  }
}
