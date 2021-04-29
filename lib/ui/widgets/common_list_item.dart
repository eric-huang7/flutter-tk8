import 'package:flutter/material.dart';
import 'package:tk8/ui/widgets/thumbnail.dart';

class CommonListItem extends StatelessWidget {
  final String previewImageUrl;
  final String title;
  final IconData overlayIcon;
  final double height;

  const CommonListItem({
    Key key,
    @required this.title,
    @required this.previewImageUrl,
    this.overlayIcon,
    // TODO: Find a better way to handle different aspect ratios
    this.height = 199,
  })  : assert(title != null),
        assert(previewImageUrl != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        width: 223,
        height: height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1a0c2246),
              blurRadius: 15,
            )
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Thumbnail(
                height: height - 80,
                imageUrl: previewImageUrl,
                overlayIcon: overlayIcon),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _buildVideoTitleText(),
            ),
          ],
        ),
      ),
    );
  }

  Text _buildVideoTitleText() {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "Gotham",
          fontStyle: FontStyle.normal,
          fontSize: 15.0),
    );
  }
}
