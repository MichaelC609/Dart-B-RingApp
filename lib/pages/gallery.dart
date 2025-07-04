import 'package:flutter/material.dart';
import 'simple_bottom_nav.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF6F6F6),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Icon(Icons.photo_library, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('This is the Gallery Page',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 2),
    );
  }
}
