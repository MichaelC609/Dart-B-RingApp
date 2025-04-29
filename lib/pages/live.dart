import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'simple_bottom_nav.dart';

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  late VlcPlayerController _vlcViewController;
  bool _isPlaying = false;
  final TextEditingController _clipDurationController = TextEditingController();

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
    _clipDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Video stream area with fallback
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: VlcPlayer(
                  aspectRatio: 16/9,
                  controller: _vlcViewController,
                  placeholder: const Center(child: CircularProgressIndicator()),
                ),
              ),
              if (!_isPlaying)
                Container(
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.width) *
                      9 /
                      16, // same height as video
                  color: Colors.black54,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.videocam_off, size: 80, color: Colors.white),
                        SizedBox(height: 12),
                        Text(
                          'Stream not found',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Show clip tools only when playing
          if (_isPlaying)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _clipDurationController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: const InputDecoration(
                      counterText: "",
                      hintText: "Enter duration (max 900s)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      final input = int.tryParse(_clipDurationController.text);
                      if (input != null && input <= 900 && input > 0) {
                        print("Clipping $input seconds...");
                      } else {
                        print("Invalid duration.");
                      }
                    },
                    child: const Text("Clip"),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 1),
    );
  }
}
