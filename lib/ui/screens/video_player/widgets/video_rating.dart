import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:tk8/ui/widgets/widgets.dart';

import '../video_player.viewmodel.dart';

class VideoRating extends StatefulWidget {
  @override
  _VideoRatingState createState() => _VideoRatingState();
}

class _VideoRatingState extends State<VideoRating> {
  double _currentRating = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerScreenViewModel>(
      builder: (context, model, child) {
        return Material(
          color: const Color(0xEE000000),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Space.vertical(10),
                RatingBar(
                  unratedColor: const Color(0x33FFFFFF),
                  initialRating: _currentRating,
                  // ignore: avoid_redundant_argument_values
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                    ),
                    empty: const Icon(
                      Icons.star,
                      color: Color(0x33FFFFFF),
                    ),
                    half: null,
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (rating) {
                    setState(() => _currentRating = rating);
                  },
                ),
                if (!model.busyVideoRating)
                  TextButton(
                    onPressed: () => model.rateVideo(_currentRating.toInt()),
                    child: Text(
                      translate('alerts.actions.ok.title'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                else
                  const AdaptiveProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
