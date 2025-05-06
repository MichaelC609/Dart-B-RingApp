import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'gallery.dart';
import 'logs.dart';
import 'simple_bottom_nav.dart';
import 'globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VlcPlayerController _vlcViewController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _vlcViewController = VlcPlayerController.network(
      'rtmp://ubuntudoorbell.duckdns.org/live/test123',
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(),
    )..addListener(_updatePlayingStatus);
  }

  void _updatePlayingStatus() {
    final isNowPlaying = _vlcViewController.value.isPlaying;
    if (mounted && isNowPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isNowPlaying;
      });
    }
  }

  @override
  void dispose() {
    _vlcViewController.removeListener(_updatePlayingStatus);
    _vlcViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF6F6F6),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back, ${globals.userName}!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VlcPlayer(
                        controller: _vlcViewController,
                        aspectRatio: 16 / 9,
                        placeholder:
                            const Center(child: CircularProgressIndicator()),
                      ),
                      if (!_isPlaying)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.videocam_off,
                                    size: 64, color: Colors.white),
                                SizedBox(height: 12),
                                Text('Preview Unavailable',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.teal),
                  title: const Text('Gallery'),
                  subtitle: const Text('Browse saved videos'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GalleryPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.receipt_long, color: Colors.orange),
                  title: const Text('Logs'),
                  subtitle: const Text('Review activity records'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogsPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 0),
    );
  }
}
