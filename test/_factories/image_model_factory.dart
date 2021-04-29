import 'package:mock_data/mock_data.dart';
import 'package:tk8/data/models/image.model.dart';

Image mockImageModel({
  String previewUrl,
  String fullUrl,
}) {
  return Image(
    previewUrl: previewUrl ?? mockUrl(),
    fullUrl: fullUrl ?? mockUrl(),
  );
}
