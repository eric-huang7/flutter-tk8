import 'package:flutter/material.dart';

class AuthInputContainer extends StatelessWidget {
  final Widget child;

  const AuthInputContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        boxShadow: [
          BoxShadow(
            color: Color(0x260c2246),
            blurRadius: 15,
          )
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
