import 'package:flutter/material.dart';

import 'widgets.dart';

class Thumbnail extends StatelessWidget {
  final String imageUrl;
  final IconData overlayIcon;
  final double height;

  const Thumbnail({
    Key key,
    @required this.imageUrl,
    this.overlayIcon ,
    this.height = 120,
  }
      ) : assert(imageUrl != null),super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildVideoThumbnail();
  }

  Stack _buildVideoThumbnail() {
    return Stack(
      children: [
        SizedBox(
          height: height,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(2),
            ),
            child: NetworkImageView(imageUrl: imageUrl),
          ),
        ),
        if (overlayIcon != null)
          Positioned.fill(
            child: Center(
              child: Icon(
                overlayIcon,
                size: 50,
                color: Colors.black38,
              ),
            ),
          ),
      ],
    );
  }
}
