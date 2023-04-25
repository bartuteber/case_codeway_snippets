import 'dart:convert';
import 'dart:typed_data';
import 'package:codeway_snippets/helper/cache_image.dart';
import 'package:http/http.dart' as http;

Future<Uint8List> downloadImageData(String fileId) async {
  try {
    ImageCache imageCache = ImageCache();

    if (imageCache.containsKey(fileId)) {
      return imageCache.getImage(fileId)!;
    }
    String apiKey = 'AIzaSyAqxtvV1HS1jmOgIEi_YAv2cW7necYvIGw';
    final String apiUrl =
        'https://www.googleapis.com/drive/v3/files/$fileId?alt=media&key=$apiKey';
    final http.Response response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Uint8List imageData = base64.decode(base64.encode(response.bodyBytes));
      imageCache.putImage(fileId, imageData);
      return imageData;
    } else {
      throw Exception('Failed to download image data');
    }
  } catch (e) {
    throw Exception('Failed to download image data: $e');
  }
}
