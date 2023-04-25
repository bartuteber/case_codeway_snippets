import 'package:codeway_snippets/enums/page_arrival_type.dart';
import 'package:codeway_snippets/models/story_model.dart';

class StoryGroup {
  final int id;
  final String name;
  final List<Story> stories;
  int lastShownStoryIndex;
  int lastSeenStoryIndex;
  bool newArrival;

  PageArrivalType arrivalType = PageArrivalType.directTap;

  StoryGroup({required this.id, required this.stories, required this.name})
      : lastShownStoryIndex = -1,
        newArrival = false,
        lastSeenStoryIndex = -1;

  Story getStoryByIndex(int index) {
    // for backup
    if (index >= stories.length) {
      index = stories.length - 1;
    } else if (index < 0) {
      index = 0;
    }
    return stories[index];
  }

  bool isCompletelySeen() {
    //lastShownCheck is included just for a safeguard
    if (lastSeenStoryIndex >= stories.length - 1 ||
        lastShownStoryIndex >= stories.length - 1) {
      return true;
    }
    return false;
  }

  void _syncLastShownLastSeen() {
    if (lastShownStoryIndex >= lastSeenStoryIndex) {
      lastSeenStoryIndex = lastShownStoryIndex;
    }
  }

  int getNextStory() {
    switch (arrivalType) {
      case PageArrivalType.directTap:
        {
          arrivalType = PageArrivalType.alreadyInside;
          if (isCompletelySeen()) {
            lastShownStoryIndex = 0;
            return 0;
          } else {
            lastSeenStoryIndex = lastShownStoryIndex = lastSeenStoryIndex + 1;
            return lastSeenStoryIndex;
          }
        }
      case PageArrivalType.swipe:
        {
          arrivalType = PageArrivalType.alreadyInside;
          if (isCompletelySeen()) {
            return -1;
          } else {
            lastSeenStoryIndex = lastShownStoryIndex = lastSeenStoryIndex + 1;
            return lastSeenStoryIndex;
          }
        }
      case PageArrivalType.alreadyInside:
        {
          if (lastShownStoryIndex >= stories.length - 1) {
            return -1;
          } else {
            lastShownStoryIndex++;
            _syncLastShownLastSeen();
            return lastShownStoryIndex;
          }
        }
      default:
        {
          return 0;
        }
    }
  }

  int getPreviousStory() {
    int toBeShown;
    if (lastShownStoryIndex <= 0) {
      return -1;
    } else {
      toBeShown = lastShownStoryIndex - 1;
      lastShownStoryIndex--;
    }
    return toBeShown;
  }
  //includes deprecated apis and video player is not supported;
  // Future<Uint8List?> getVideoThumbnail() async {
  //   Story firstStory = stories[0];
  //   if (firstStory.mediaType == MediaType.image) {
  //     return null;
  //   }
  //   try {
  //     Uint8List? thumbnailBytes = await VideoThumbnail.thumbnailData(
  //       video: firstStory.url,
  //       imageFormat: ImageFormat.JPEG,
  //       maxWidth: 128,
  //       quality: 25,
  //     );
  //     return thumbnailBytes;
  //   } catch (e) {
  //     print('Error generating video thumbnail: $e');
  //     return null;
  //   }
  // }
}
