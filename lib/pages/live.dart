import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'simple_bottom_nav.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final List<_CameraStream> _cameras = [
    _CameraStream(
        title: 'Front Door',
        url: 'rtmp://ubuntudoorbell.duckdns.org/live/test123'),
    _CameraStream(title: 'Backyard', url: ''),
    _CameraStream(
        title: 'Parking Lot',
        url: 'rtmp://ubuntudoorbell.duckdns.org/live/testgif'),
  ];

  @override
  void dispose() {
    for (final camera in _cameras) {
      camera.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    for (final camera in _cameras) {
      camera.initController(() {
        if (mounted) setState(() {});
      });
    }
  }

  Widget buildCameraCard(_CameraStream cam) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cam.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VlcPlayer(
                      controller: cam.controller!,
                      aspectRatio: 16 / 9,
                      placeholder:
                          const Center(child: CircularProgressIndicator()),
                    ),
                    if (!cam.isPlaying)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.videocam_off,
                                  size: 64, color: Colors.white),
                              SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Cameras'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF6F6F6),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: _cameras.map(buildCameraCard).toList(),
          ),
        ),
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 1),
    );
  }
}

class _CameraStream {
  final String title;
  final String url;
  late VlcPlayerController? controller;
  bool isPlaying = false;

  _CameraStream({required this.title, required this.url});

  void initController(VoidCallback updateUI) {
    controller = VlcPlayerController.network(
      url,
      hwAcc: HwAcc.disabled,
      autoPlay: true,
      options: VlcPlayerOptions(),
    )..addListener(() {
        final playing = controller!.value.isPlaying;
        if (isPlaying != playing) {
          isPlaying = playing;
          updateUI();
        }
      });
  }

  void dispose() {
    controller?.removeListener(() {});
    controller?.dispose();
  }
}
