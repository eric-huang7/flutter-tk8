import 'package:flutter/material.dart';
import 'package:tk8/ui/widgets/adaptive_progress_indicator.dart';

class SignUpBusyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: AdaptiveProgressIndicator(),
      ),
    );
  }
}
