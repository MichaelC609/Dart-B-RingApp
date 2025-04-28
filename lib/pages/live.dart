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

  @override
  void initState() {
    super.initState();
    _vlcViewController = VlcPlayerController.network(
      'rtmp://ubuntudoorbell.duckdns.org/live/test123',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() {
    _vlcViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Page'),
      ),
      body: Center(
        child: VlcPlayer(
          controller: _vlcViewController,
          aspectRatio: 16 / 9,
          placeholder: const Center(child: CircularProgressIndicator()),
        ),
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 1),
    );
  }
}
