import 'package:flutter/material.dart';
import 'simple_bottom_nav.dart';
class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery Page'),
      ),
      body: const Center(
        child: Text(
          'This is the Gallery Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar:
          const SimpleBottomNavigation(currentIndex: 2), 
    );
  }
}
