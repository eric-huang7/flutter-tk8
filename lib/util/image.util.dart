import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

Future<String> base64FromImageFile(File file) async {
  final uri = Uri.parse(file.path);
  final filename = uri.pathSegments.last;
  final ext = filename.split('.').last ?? 'jpg';

  final imageBytes = await file.readAsBytes();
  return base64FromBytes(imageBytes, ext);
}

String base64FromBytes(Uint8List bytes, String type) {
  final base64Image = base64Encode(bytes);
  return 'data:image/$type;base64,$base64Image';
}
