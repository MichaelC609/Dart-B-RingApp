import 'package:flutter/material.dart';
import 'home_page.dart';
import 'live.dart';
import 'gallery.dart';
import 'logs.dart';
import 'profile.dart';

class SimpleBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const SimpleBottomNavigation({Key? key, required this.currentIndex}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // Already on this page, do nothing

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomePage();
        break;
      case 1:
        destination = const LivePage();
        break;
      case 2:
        destination = const GalleryPage();
        break;
      case 3:
        destination = const LogsPage();
        break;
      case 4:
        destination = const ProfilePage();
        break;
      default:
        destination = const HomePage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xff6200ee),
      unselectedItemColor: const Color(0xff757575),
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_camera_back_outlined),
          label: 'Live',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_library_sharp),
          label: 'Gallery',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Logs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
