import 'package:flutter/material.dart';

class SimpleBottomNavigation extends StatefulWidget {
  const SimpleBottomNavigation({Key? key}) : super(key: key);

  @override
  State<SimpleBottomNavigation> createState() => _SimpleBottomNavigationState();
}

class _SimpleBottomNavigationState extends State<SimpleBottomNavigation> {
  int _selectedIndex = 0;
  BottomNavigationBarType _bottomNavType = BottomNavigationBarType.shifting;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DartBell')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Selected Page: ${_navBarItems[_selectedIndex].label}"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("BottomNavBar Type :"),
                const SizedBox(width: 16),
                DropdownButton<BottomNavigationBarType>(
                    hint: Text(_bottomNavType.name),
                    items: BottomNavigationBarType.values
                        .map((item) => DropdownMenuItem(
                            value: item, child: Text(item.name)))
                        .toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() {
                        _bottomNavType = val;
                      });
                    }),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          type: _bottomNavType,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: _navBarItems),
    );
  }
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.video_camera_back_outlined),
    activeIcon: Icon(Icons.video_camera_back_outlined),
    label: 'Live',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.photo_library_sharp),
    activeIcon: Icon(Icons.settings),
    label: 'Clips',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.receipt_long_outlined),
    activeIcon: Icon(Icons.receipt_long_outlined),
    label: 'Logs',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Profile',
  ),
  
];
