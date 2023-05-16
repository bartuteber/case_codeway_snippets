import 'dart:typed_data';
import 'package:codeway_snippets/helper/download_image_data.dart' as di;
import 'package:codeway_snippets/controllers/story_controller.dart';
import 'package:codeway_snippets/enums/media_type.dart';
import 'package:codeway_snippets/models/story_group_model.dart';
import 'package:codeway_snippets/models/story_model.dart';
import 'package:codeway_snippets/views/home_page.dart';
import 'package:codeway_snippets/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class StoryItem extends StatelessWidget {
  const StoryItem({
    super.key,
    required this.currentStoryGroup,
  });
  final StoryGroup currentStoryGroup;

  @override
  Widget build(BuildContext context) {
    StoryController storyController = Get.find();
    int currentStoryIndex = storyController.currentStoryIndex;
    Story currentStory = currentStoryGroup.getStoryByIndex(currentStoryIndex);
    return Get.currentRoute == "/StoryPlayerPage"
        ? Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Stack(
              children: [
                currentStory.mediaType == MediaType.image
                    ? FutureBuilder<Uint8List>(
                        future: di.downloadImageData(currentStory.url, () {
                          print("function called");
                          storyController.startAnimation(currentStory);
                        }),
                        builder: (BuildContext context,
                            AsyncSnapshot<Uint8List> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            return const Center(child: Icon(Icons.error));
                          } else {
                            return GestureDetector(
                              onLongPress: () => storyController.pauseStory(),
                              onLongPressEnd: (_) =>
                                  storyController.resumeStory(),
                              onTapUp: (details) =>
                                  storyController.handleTap(details),
                              onVerticalDragEnd: (details) {
                                if (details.primaryVelocity! > 200) {
                                  storyController.videoPlayerController.value
                                      ?.dispose();
                                  storyController.exitAnimation();
                                  Get.to(() => const HomePage(),
                                      transition: Transition.downToUp);
                                }
                              },
                              onHorizontalDragEnd: (details) {
                                if (details.primaryVelocity! < 0) {
                                  storyController.nextStoryGroup();
                                } else if (details.primaryVelocity! > 0) {
                                  storyController.previousStoryGroup();
                                }
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : currentStory.mediaType == MediaType.video &&
                            storyController.videoPlayerController.value != null
                        ? Stack(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: FutureBuilder(
                                    future: storyController
                                        .initializeVideoPlayerFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return storyController
                                                    .videoPlayerController
                                                    .value !=
                                                null
                                            ? AspectRatio(
                                                aspectRatio: storyController
                                                    .videoPlayerController
                                                    .value!
                                                    .value
                                                    .aspectRatio,
                                                child: VideoPlayer(
                                                    storyController
                                                        .videoPlayerController
                                                        .value!),
                                              )
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  )),
                              Positioned.fill(
                                child: GestureDetector(
                                  onLongPress: () =>
                                      storyController.pauseStory(),
                                  onLongPressEnd: (_) =>
                                      storyController.resumeStory(),
                                  onTapUp: (details) =>
                                      storyController.handleTap(details),
                                  onVerticalDragEnd: (details) {
                                    if (details.primaryVelocity! > 200) {
                                      storyController
                                          .videoPlayerController.value
                                          ?.dispose();
                                      Get.to(() => const HomePage(),
                                          transition: Transition.downToUp);
                                    }
                                  },
                                  onHorizontalDragEnd: (details) {
                                    if (details.primaryVelocity! < 0) {
                                      storyController.nextStoryGroup();
                                    } else if (details.primaryVelocity! > 0) {
                                      storyController.previousStoryGroup();
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                Positioned(
                  top: 20.0,
                  left: 10.0,
                  right: 10.0,
                  child: Row(
                    children: currentStoryGroup.stories
                        .asMap()
                        .map((i, e) {
                          return MapEntry(
                            i,
                            ProgressBar(
                              animController:
                                  storyController.animationController,
                              position: i,
                              currentIndex: currentStoryIndex,
                            ),
                          );
                        })
                        .values
                        .toList(),
                  ),
                ),
                Positioned(
                    top: 40,
                    left: 20,
                    child: Text(
                      currentStoryGroup.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          )
        : Container();
  }
}
