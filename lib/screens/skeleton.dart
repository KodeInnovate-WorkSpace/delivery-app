import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            //top
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // delivery within
                _buildShimmerContainer(width: 100, height: 10),

                // delivery time
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerContainer(width: 160, height: 25),
                    _buildShimmerContainer(width: 50, height: 50, borderRadius: 50),
                  ],
                ),

                // location
                const SizedBox(height: 10),
                _buildShimmerContainer(width: 260, height: 20),

                // search
                const SizedBox(height: 20),
                _buildShimmerContainer(width: double.infinity, height: 50),

                // ad card
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildShimmerContainer(width: 272, height: 172, borderRadius: 12),
                    const SizedBox(width: 15),
                    _buildShimmerContainer(width: 20, height: 172, borderRadius: 6),
                  ],
                ),

                // category name
                const SizedBox(height: 20),
                _buildShimmerContainer(width: 160, height: 25),

                // sub-category row
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShimmerContainer(width: 72, height: 72, borderRadius: 14),
                    const SizedBox(width: 10),
                    _buildShimmerContainer(width: 72, height: 72, borderRadius: 14),
                    const SizedBox(width: 10),
                    _buildShimmerContainer(width: 72, height: 72, borderRadius: 14),
                    const SizedBox(width: 10),
                    _buildShimmerContainer(width: 72, height: 72, borderRadius: 14),
                  ],
                ),

                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShimmerContainer(width: 72, height: 72, borderRadius: 14),
                    const SizedBox(width: 10),
                    _buildShimmerContainer(width: 72, height: 72, borderRadius: 14),
                    const SizedBox(width: 10),
                    _buildShimmerContainer(width: 72, height: 72, borderRadius: 14),
                    const SizedBox(width: 10),
                    _buildShimmerContainer(width: 72, height: 72, borderRadius: 14),
                  ],
                ),

                // category-2 name
                const SizedBox(height: 20),
                _buildShimmerContainer(width: 160, height: 25),

                // sub-category row
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShimmerContainer(width: 72, height: 65, borderRadius: 14),
                    const SizedBox(width: 10),
                    _buildShimmerContainer(width: 72, height: 65, borderRadius: 14),
                    const SizedBox(width: 10),
                    _buildShimmerContainer(width: 72, height: 65, borderRadius: 14),
                    const SizedBox(width: 10),
                    _buildShimmerContainer(width: 72, height: 65, borderRadius: 14),
                  ],
                ),
              ],
            ),
          ],
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
