import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvertisementWidget extends StatefulWidget {
  const AdvertisementWidget({super.key});

  @override
  State<AdvertisementWidget> createState() => _AdvertisementWidgetState();
}

class _AdvertisementWidgetState extends State<AdvertisementWidget> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      final maxIndex = (_pageController.positions.first.maxScrollExtent / _pageController.position.viewportDimension).round();

      _currentIndex = (_currentIndex + 1) % (maxIndex + 1); // Ensure looping

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Advertisement')
          .where('status', isEqualTo: 1)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
          docs.sort((a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

          return SizedBox(
            height: 600,
            child: PageView.builder(
              controller: _pageController,
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var imageUrl = docs[index]['image'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffeaf1fc),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      margin: EdgeInsets.zero,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                );
              },
              onPageChanged: (int index) {
                _currentIndex = index;
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
