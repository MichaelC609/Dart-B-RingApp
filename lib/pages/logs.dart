import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'simple_bottom_nav.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  late Future<List<dynamic>> _logsFuture;
  final Set<int> _selectedIds = {};
  bool _selectMode = false;

  @override
  void initState() {
    super.initState();
    _logsFuture = fetchLogs();
  }

  Future<List<dynamic>> fetchLogs() async {
    final response = await http
        .get(Uri.parse('http://ubuntudoorbell.duckdns.org:5000/get_logs'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load logs');
    }
  }

  Future<void> clearAllLogs() async {
    final response = await http.post(
      Uri.parse('http://ubuntudoorbell.duckdns.org:5000/clear_logs'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _logsFuture = fetchLogs();
        _selectedIds.clear();
        _selectMode = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to clear logs')),
      );
    }
  }

  Future<void> deleteSelectedLogs() async {
    final response = await http.post(
      Uri.parse('http://ubuntudoorbell.duckdns.org:5000/delete_logs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ids': _selectedIds.toList()}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _logsFuture = fetchLogs();
        _selectedIds.clear();
        _selectMode = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete logs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        actions: [
          if (_selectMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _selectedIds.isNotEmpty ? deleteSelectedLogs : null,
              tooltip: 'Delete selected',
            ),
          IconButton(
            icon: Icon(_selectMode ? Icons.cancel : Icons.select_all),
            tooltip: _selectMode ? 'Cancel selection' : 'Select logs',
            onPressed: () {
              setState(() {
                if (_selectMode) {
                  _selectMode = false;
                  _selectedIds.clear();
                } else {
                  _selectMode = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear all logs',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Clear all logs?"),
                  content: const Text("This action cannot be undone."),
                  actions: [
                    TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context, false)),
                    TextButton(
                        child: const Text("Clear All"),
                        onPressed: () => Navigator.pop(context, true)),
                  ],
                ),
              );
              if (confirmed == true) {
                clearAllLogs();
              }
            },
          )
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _logsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No logs available.'));
          } else {
            final logs = snapshot.data!;
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                final id = log['id'] as int;
                final photoUrl = log['photo_path'] != null
                    ? 'http://ubuntudoorbell.duckdns.org:5000/${log['photo_path']}'
                    : null;
                final selected = _selectedIds.contains(id);

                return ListTile(
                  onLongPress: () {
                    setState(() {
                      _selectMode = true;
                      _selectedIds.add(id);
                    });
                  },
                  onTap: () {
                    if (_selectMode) {
                      setState(() {
                        if (selected) {
                          _selectedIds.remove(id);
                        } else {
                          _selectedIds.add(id);
                        }
                      });
                    }
                  },
                  leading: photoUrl != null
                      ? Image.network(photoUrl,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text(log['description']),
                  subtitle: Text(log['timestamp']),
                  trailing: _selectMode
                      ? Icon(
                          selected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selected
                              ? const Color.fromARGB(255, 38, 16, 206)
                              : null,
                        )
                      : null,
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 2),
    );
  }
}
