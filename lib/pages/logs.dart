import 'package:flutter/material.dart';
import 'simple_bottom_nav.dart';
class LogsPage extends StatelessWidget {
  const LogsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: const Text('Logs Page'),
      ),
      body: const Center(
        child: Text(
          'This is the Logs Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 3), 
    );
  }
}
