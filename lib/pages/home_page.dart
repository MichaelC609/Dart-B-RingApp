import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Future<bool> requestStoragePermission() async {
    // For Android 10 and below
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    // For Android 11+
    if (await Permission.manageExternalStorage.isDenied ||
        await Permission.manageExternalStorage.isRestricted) {
      final result = await openAppSettings(); // 🚨 MUST open settings manually
      return false;
    }

    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }

    return false;
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
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 12),

              // 🎬 Clip input + button appears only when stream is playing
              if (_isPlaying)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _clipDurationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Clip Duration (600 sec MAX)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final input = _clipDurationController.text.trim();
                        final duration = int.tryParse(input);

                        if (duration == null ||
                            duration <= 0 ||
                            duration > 600) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please enter a number between 1 and 600'),
                            ),
                          );
                          return;
                        }

                        try {
                          // ✅ Generate filename based on timestamp
                          final now = DateTime.now();
                          final fileName =
                              'clip_${now.toIso8601String().replaceAll(':', '-')}.mp4';

                          // ✅ Get temporary directory
                          final dir = await getTemporaryDirectory();
                          final filePath = '${dir.path}/$fileName';

                          // ✅ Request storage permission if needed
                          // Request storage permission
                          final granted = await requestStoragePermission();
                          if (!granted) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Storage permission is required')),
                            );
                            return;
                          }

                          // ✅ Download the file using http
                          final url = Uri.parse(
                              "http://ubuntudoorbell.duckdns.org:5000/clip?seconds=$duration");
                          final request = http.Request('GET', url);
                          final streamedResponse =
                              await http.Client().send(request);

                          if (streamedResponse.statusCode == 200) {
                            final file = File(filePath);
                            final sink = file.openWrite();
                            await streamedResponse.stream.pipe(sink);
                            await sink.close();

                            final saved =
                                await GallerySaver.saveVideo(file.path);
                            if (!mounted) return;
                            if (saved ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Clip saved to gallery')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to save clip')),
                              );
                            }
                          } else {
                            throw Exception(
                                "Download failed with status ${streamedResponse.statusCode}");
                          }
                        } catch (e) {
                          print(e.toString());
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                      icon: const Icon(Icons.cut),
                      label: const Text('Clip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
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
