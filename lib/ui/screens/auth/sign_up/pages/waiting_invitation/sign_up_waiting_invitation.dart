import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SignUpWaitingInvitationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      translate(
                          'screens.signUp.pages.waitingForInvitation.message'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          height: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Gotham",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
