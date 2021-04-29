import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/config/styles.config.dart';

class ExerciseCountdownScreen extends StatefulWidget {
  final Function onCountdownFinished;

  const ExerciseCountdownScreen({Key key, @required this.onCountdownFinished})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExerciseCountdownState();
}

class _ExerciseCountdownState extends State<ExerciseCountdownScreen> {
  Timer _countdownTimer;
  Duration _duration = const Duration(seconds: 5);

  @override
  void initState() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), timerCallback);
    super.initState();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void timerCallback(Timer timer) {
    setState(() {
      if (_duration.inSeconds == 0) {
        timer.cancel();
        widget.onCountdownFinished();
      } else {
        _duration = Duration(seconds: _duration.inSeconds - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Baseline(
            baseline: 400,
            baselineType: TextBaseline.alphabetic,
            child: Text(_duration.inSeconds.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: "RevxNeue",
                  fontStyle: FontStyle.normal,
                  fontSize: 400,
                  foreground: Paint()
                    ..strokeWidth = 1.5
                    ..color = TK8Colors.ocean
                    ..style = PaintingStyle.stroke,
                ))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(translate('screens.exercise.countdownText'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: TK8Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: "RevxNeue",
                  fontStyle: FontStyle.normal,
                  fontSize: 32.0,
                )))
      ],
    ));
  }
}
