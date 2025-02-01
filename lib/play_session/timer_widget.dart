import 'dart:async';

import 'package:flutter/material.dart';

class TimerCountUpWidget extends StatefulWidget {
  const TimerCountUpWidget({super.key});

  @override
  TimerCountUpWidgetState createState() => TimerCountUpWidgetState();
}

class TimerCountUpWidgetState extends State<TimerCountUpWidget> {
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    startCounting();
  }

  void startCounting() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Drag the cards FAST!!! $_elapsedSeconds",
      style: TextStyle(
        fontSize: 24,
        fontFamily: 'Permanent Marker',
      ),
    );
  }
}
