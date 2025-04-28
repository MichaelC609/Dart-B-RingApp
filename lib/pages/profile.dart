import 'package:flutter/material.dart';
import 'simple_bottom_nav.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: const Center(
        child: Text(
          'This is the Profile Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 4), 
    );
  }
}
