import 'package:flutter/material.dart';
import 'package:tk8/config/styles.config.dart';
import 'package:tk8/ui/widgets/adaptive_progress_indicator.dart';

class AuthNextButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthNextButton(
      {Key key,
      @required this.title,
      @required this.onPressed,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          color: onPressed != null ? TK8Colors.ocean : Colors.grey,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(
                    color: isLoading ? Colors.transparent : Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Gotham",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0),
              ),
            ),
            if (isLoading)
              const Positioned.fill(
                child: Center(
                  child: AdaptiveProgressIndicator(size: 16),
                ),
              )
          ],
        ),
      ),
    );
  }
}
