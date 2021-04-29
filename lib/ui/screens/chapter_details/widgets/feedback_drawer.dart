import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:tk8/data/models/user_video.model.dart';
import 'package:tk8/ui/widgets/space.dart';

class AcademyFeedbackDrawer extends StatefulWidget {
  final UserVideo userVideo;

  const AcademyFeedbackDrawer({Key key, @required this.userVideo})
      : assert(userVideo != null),
        super(key: key);

  @override
  _AcademyFeedbackDrawerState createState() => _AcademyFeedbackDrawerState();
}

class _AcademyFeedbackDrawerState extends State<AcademyFeedbackDrawer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: Container(
            decoration: const BoxDecoration(color: Colors.black),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildDrawer(context),
        )
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        boxShadow: [BoxShadow(color: Color(0x260c2246), blurRadius: 15)],
        color: Colors.white,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 12, bottom: 16),
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Text(
              translate(
                  'screens.chapterDetails.community.feedbackDrawer.title'),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: "RevxNeue",
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0),
            ),
            const Space.vertical(45),
            Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 74,
                bottom: 76,
              ),
              child: Text(
                widget.userVideo.feedback.text,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Gotham",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
