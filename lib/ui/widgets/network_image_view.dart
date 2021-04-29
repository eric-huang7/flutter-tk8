import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageView extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const NetworkImageView({
    Key key,
    @required this.imageUrl,
    this.fit = BoxFit.cover,
  })  : assert(imageUrl != null && imageUrl != ''),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: double.infinity,
      imageUrl: imageUrl,
      fit: fit,
      progressIndicatorBuilder: (context, url, progress) {
        return const AspectRatio(
          aspectRatio: 1,
          child: Center(
            child: Text('Loading....'),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return AspectRatio(
          aspectRatio: 1,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.error_outline,
                  size: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
