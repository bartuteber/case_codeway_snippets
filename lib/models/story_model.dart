import 'package:codeway_snippets/enums/media_type.dart';
import 'package:flutter/material.dart';

class Story {
  final int id;
  final String url;
  final MediaType mediaType;
  Duration duration;
  Image? coverImage;

  Story({required this.id, required this.url, required this.mediaType})
      : duration = mediaType == MediaType.image
            ? const Duration(seconds: 5)
            : const Duration();
}
