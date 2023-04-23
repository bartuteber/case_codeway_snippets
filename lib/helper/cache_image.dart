import 'dart:typed_data';

class ImageCache {
  static final ImageCache _instance = ImageCache._internal();
  factory ImageCache() => _instance;
  ImageCache._internal();

  final Map<String, Uint8List> _cache = {};

  bool containsKey(String key) => _cache.containsKey(key);

  Uint8List? getImage(String key) => _cache[key];

  void putImage(String key, Uint8List imageData) => _cache[key] = imageData;
}
