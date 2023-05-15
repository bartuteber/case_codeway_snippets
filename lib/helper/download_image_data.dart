import 'dart:convert';
import 'dart:typed_data';
import 'package:codeway_snippets/helper/cache_image.dart';
import 'package:http/http.dart' as http;

Future<Uint8List> downloadImageData(
    String url, Function startAnimationCallback) async {
  try {
    ImageCache imageCache = ImageCache();

    if (imageCache.containsKey(url)) {
      startAnimationCallback();
      return imageCache.getImage(url)!;
    }
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Uint8List imageData = base64.decode(base64.encode(response.bodyBytes));
      imageCache.putImage(url, imageData);
      startAnimationCallback();
      return imageData;
    } else {
      throw Exception('Failed to download image data');
    }
  } catch (e) {
    throw Exception('Failed to download image data: $e');
  }
}
