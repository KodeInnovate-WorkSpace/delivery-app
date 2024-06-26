import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvertisementWidget extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;

  const AdvertisementWidget({super.key, required this.cardWidth, required this.cardHeight});

  @override
  _AdvertisementWidgetState createState() => _AdvertisementWidgetState();
}

class _AdvertisementWidgetState extends State<AdvertisementWidget> {
  late ScrollController _scrollController;
  // late Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // // Start auto-scrolling every 2 seconds
    // _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
    //   if (_scrollController.hasClients) {
    //     double maxScrollExtent = _scrollController.position.maxScrollExtent;
    //     double viewportWidth = _scrollController.position.viewportDimension;
    //     double targetScroll = (_currentIndex + 1) * viewportWidth;

    //     if (targetScroll > maxScrollExtent) {
    //       targetScroll = 0;
    //       _currentIndex = 0;
    //     } else {
    //       _currentIndex++;
    //     }

    //     _scrollController.animateTo(
    //       targetScroll,
    //       duration: Duration(seconds: 1),
    //       curve: Curves.easeOut,
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    // _timer.cancel();
    _scrollController.dispose();
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
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          // Sort documents based on 'priority' field
          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
          docs.sort((a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

          return SizedBox(
            height: widget.cardHeight + 16, // Adjust height as needed to include padding
            width: double.infinity,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
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
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black26,
                      //     offset: Offset(0, 2),
                      //     blurRadius: 4.0,
                      //   ),
                      // ],
                    ),
                    child: Card(
                      margin: EdgeInsets.zero, // Remove default margin
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          width: widget.cardWidth, // Set the card width
                          height: widget.cardHeight, // Set the card height
                          fit: BoxFit.fill, // Stretch the image to fill the container
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: Text('No active advertisements'));
        }
      },
    );
  }
}
