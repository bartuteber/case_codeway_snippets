import 'package:cached_network_image/cached_network_image.dart';
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
    return Get.currentRoute == "/StoryPlayerPage"
        ? Obx(() {
            StoryController storyController = Get.find();
            int currentStoryIndex = storyController.currentStoryIndex.value;
            VideoPlayerController? videoPlayerController =
                storyController.videoPlayerController.value;
            Story currentStory =
                currentStoryGroup.getStoryByIndex(currentStoryIndex);
            return Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: Stack(
                children: [
                  currentStory.mediaType == MediaType.image
                      ? Align(
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            imageUrl: currentStory.url,
                            imageBuilder: (context, imageProvider) {
                              if (Get.currentRoute == "/StoryPlayerPage") {
                                storyController.startAnimation(currentStory);
                              }
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )
                      : currentStory.mediaType == MediaType.video &&
                              videoPlayerController != null
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
                                          return AspectRatio(
                                            aspectRatio: videoPlayerController
                                                .value.aspectRatio,
                                            child: VideoPlayer(storyController
                                                .videoPlayerController.value!),
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    )),
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
                      right: 60,
                      child: Text(
                        currentStoryGroup.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                  Positioned.fill(
                    child: GestureDetector(
                      onLongPress: () => storyController.pauseStory(false),
                      onLongPressEnd: (_) => storyController.resumeStory(false),
                      onTapUp: (details) => storyController.handleTap(details),
                      onVerticalDragEnd: (details) {
                        if (details.primaryVelocity! > 100) {
                          videoPlayerController?.dispose();
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
                  Positioned(
                      top: 30,
                      right: 20,
                      child: IconButton(
                          onPressed: () {
                            videoPlayerController?.dispose();
                            Get.to(() => const HomePage(),
                                transition: Transition.downToUp);
                          },
                          iconSize: 30,
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                          )))
                ],
              ),
            );
          })
        : Container();
  }
}
