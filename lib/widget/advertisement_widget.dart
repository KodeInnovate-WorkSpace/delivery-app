import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvertisementWidget extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;

  const AdvertisementWidget(
      {super.key, required this.cardWidth, required this.cardHeight});

  @override
  _AdvertisementWidgetState createState() => _AdvertisementWidgetState();
}

class _AdvertisementWidgetState extends State<AdvertisementWidget> {
  late PageController _pageController;
  // late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Start auto-scrolling every 2 seconds
    // _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
    //   if (_pageController.hasClients) {
    //     double maxPage = _pageController.page!.toInt().toDouble();
    //     double nextPage = _currentIndex + 1.0;
    //
    //     if (nextPage > maxPage) {
    //       nextPage = 0;
    //       _currentIndex = 0;
    //     } else {
    //       _currentIndex++;
    //     }
    //
    //     _pageController.animateToPage(
    //       _currentIndex,
    //       duration: Duration(seconds: 1),
    //       curve: Curves.easeOut,
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    // _timer.cancel();
    _pageController.dispose();
    super.dispose();
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
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          // Sort documents based on 'priority' field
          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
          docs.sort(
              (a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

          return SizedBox(
            height: widget.cardHeight +
                16, // Adjust height as needed to include padding
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var imageUrl = docs[index]['image'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: widget.cardWidth, // Set the card width
                    decoration: BoxDecoration(
                      color: const Color(0xffeaf1fc), // Specify the color here
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.zero, // Remove default margin
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          // "assets/images/banner.png",
                          width: widget.cardWidth, // Set the card width
                          height: widget.cardHeight, // Set the card height
                          fit: BoxFit
                              .fill, // Stretch the image to fill the container
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No active advertisements'));
        }
      },
    );
  }
}
