import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class DebugOverlay extends StatefulWidget {
  final Widget child;

  const DebugOverlay({super.key, required this.child});

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  bool _isVisible = false;
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();
  final StreamController<String> _logController = StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _setupLoggerListener();
    }
  }

  void _setupLoggerListener() {
    // This is a placeholder - in a real implementation, you'd hook into the logger
    // For now, we'll just add a startup message
    addLog('Debug overlay initialized');
  }

  void addLog(String message) {
    if (!mounted) return;
    final timestamp = DateTime.now().toString().substring(11, 19);
    setState(() {
      _logs.insert(0, '[$timestamp] $message');
      if (_logs.length > 100) _logs.removeLast();
    });
    _logController.add('[$timestamp] $message');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _logController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return widget.child;

    return Stack(
      children: [
        widget.child,
        if (_isVisible)
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              color: Colors.black87,
              child: Column(
                children: [
                  AppBar(
                    title: const Text('Debug Logs'),
                    backgroundColor: Colors.black,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _logs.clear();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _isVisible = false;
                          });
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(
                            _logs[index],
                            style: const TextStyle(
                              color: Colors.green,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            backgroundColor: Colors.black,
            child: Icon(
              _isVisible ? Icons.close : Icons.bug_report,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// Global access to add logs from anywhere
class DebugLogger {
  static void log(String message) {
    // In a real implementation, you'd use a stream or callback to communicate
    // with the overlay. For now, this is a placeholder.
    if (kDebugMode) {
      debugPrint('[DEBUG] $message');
    }
  }
}
