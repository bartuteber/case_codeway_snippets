import 'package:codeway_snippets/models/story_model.dart';

class StoryGroup {
  final int id;
  final String name;
  final List<Story> stories;
  int lastShownStoryIndex;
  int lastSeenStoryIndex;
  bool isCompletelySeen;
  bool newArrival;

  StoryGroup({required this.id, required this.stories, required this.name})
      : lastShownStoryIndex = -1,
        isCompletelySeen = false,
        newArrival = false,
        lastSeenStoryIndex = -1;

  Story getStoryByIndex(int index) {
    // for backup
    if (index >= stories.length) {
      index = stories.length - 1;
      print('crashed actually');
    } else if (index <= 0) {
      print('crashed actually');
      index = 0;
    }
    return stories[index];
  }

  int getNextStory() {
    int toBeShown;
    if (newArrival) {
      if (isCompletelySeen || lastSeenStoryIndex >= stories.length - 1) {
        toBeShown = 0;
        lastShownStoryIndex = 0;
        lastSeenStoryIndex = 0;
      } else {
        toBeShown = lastSeenStoryIndex + 1;
        lastSeenStoryIndex = lastShownStoryIndex = lastSeenStoryIndex + 1;
        if (lastSeenStoryIndex >= stories.length - 1) {
          isCompletelySeen = true;
          lastSeenStoryIndex = lastShownStoryIndex = stories.length - 1;
        }
      }
      newArrival = false;
    } else {
      if (lastShownStoryIndex >= stories.length - 1) {
        isCompletelySeen = true;
        lastSeenStoryIndex = lastShownStoryIndex = stories.length - 1;
        return -1;
      } else {
        toBeShown = lastShownStoryIndex + 1;
        lastShownStoryIndex++;
        if (lastShownStoryIndex > lastSeenStoryIndex) {
          lastSeenStoryIndex = lastShownStoryIndex;
        }
        if (lastSeenStoryIndex >= stories.length - 1) {
          isCompletelySeen = true;
        }
      }
    }
    return toBeShown;
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
