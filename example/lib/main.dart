import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:power_setting_windows/model/console_display_state.dart';
import 'package:power_setting_windows/model/session_display_state.dart';
import 'package:power_setting_windows/model/session_user_state.dart';
import 'package:power_setting_windows/power_setting_observer.dart';
import 'package:power_setting_windows/power_setting_windows.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with PowerSettingObserver {
  final TextEditingController _textEditingController = TextEditingController();

  void logToScreen(String message) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String dateTime = dateFormat.format(DateTime.now());
    if (kDebugMode) {
      print('$dateTime $message');
    }
    setState(() {
      _textEditingController.text += '$dateTime $message\n';
    });
  }

  @override
  void initState() {
    super.initState();
    PowerSettingWindows.addObserver(this);
  }

  @override
  void dispose() {
    PowerSettingWindows.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeConsoleDisplayState(ConsoleDisplayState state) {
    logToScreen('[didChangeConsoleDisplayState] state: $state');
  }

  @override
  void didChangeSessionDisplayState(SessionDisplayState state) {
    logToScreen('[didChangeSessionDisplayState] state: $state');
  }

  @override
  void didChangeSessionUserState(SessionUserState state) {
    logToScreen('[didChangeSessionUserState] state: $state');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Windows Power Setting Notification'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Log', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 5),
              TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                controller: _textEditingController,
                maxLines: 20,
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
