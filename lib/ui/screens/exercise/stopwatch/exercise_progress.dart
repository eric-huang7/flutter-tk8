import 'package:flutter/material.dart';
import 'package:tk8/config/styles.config.dart';

class ExerciseProgress extends StatelessWidget {
  final double progress;

  const ExerciseProgress({Key key, this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            valueColor: const AlwaysStoppedAnimation(TK8Colors.ocean),
            backgroundColor: TK8Colors.grey.withOpacity(0.5),
          ),
        ),
        if (progress >= 1.0)
          const Icon(Icons.check_outlined, size: 24, color: TK8Colors.ocean)
        else
          const Icon(Icons.lock, size: 24, color: TK8Colors.grey)
      ],
    );
  }
}
