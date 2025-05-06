import 'package:flutter/material.dart';
import 'simple_bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _cameraOn = true;

  @override
  Widget build(BuildContext context) {
    const String userName = "User"; // Replace with user name

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
              // Profile Picture
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/default_pfp.png'), // Use pfp
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 12),

              // Greeting
              Text(
                'Hello, $userName',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),

              // Settings button
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blueAccent),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to settings page (optional)
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Toggle Power
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: SwitchListTile(
                  title: Text(
                    _cameraOn ? 'Power Off Camera' : 'Power On Camera',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  secondary: Icon(
                    _cameraOn ? Icons.power_settings_new : Icons.power_off,
                    color: _cameraOn ? Colors.green : Colors.redAccent,
                  ),
                  value: _cameraOn,
                  onChanged: (value) {
                    setState(() {
                      _cameraOn = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 4),
    );
  }
}
