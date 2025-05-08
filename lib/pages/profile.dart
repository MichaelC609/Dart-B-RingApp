import 'package:flutter/material.dart';
import 'simple_bottom_nav.dart';
import 'globals.dart' as globals;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF6F6F6),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile_pic.png'),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 12),
              Text(
                'Hello, ${globals.userName}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blueAccent),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Created by:\nJoshua Estrada, Sean Sang,\nJason Mar, Michael Castillo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 4),
    );
  }
}
