import 'package:codeway_snippets/controllers/story_group_controller.dart';
import 'package:codeway_snippets/enums/media_type.dart';
import 'package:codeway_snippets/models/story_group_model.dart';
import 'package:codeway_snippets/models/story_model.dart';
import 'package:codeway_snippets/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class StoryController extends GetxController with GetTickerProviderStateMixin {
  final StoryGroupController storyGroupController = Get.find();
  late AnimationController animationController;
  VideoPlayerController? videoPlayerController;
  bool isPaused = false;
  bool isTapping = false;
  int currentStoryIndex = 0;

  @override
  void onInit() async {
    super.onInit();
    await initVideoPlayerController();
    initAnimationController();
  }

  Future<void> initVideoPlayerController() async {
    Story currentStory = storyGroupController
        .getCurrentStoryGroup()
        .getStoryByIndex(currentStoryIndex);
    if (currentStory.mediaType == MediaType.video) {
      videoPlayerController = VideoPlayerController.network(currentStory.url);
      await videoPlayerController!.initialize();
      currentStory.duration = videoPlayerController!.value.duration;
    }
  }

  void initAnimationController() {
    animationController = AnimationController(vsync: this);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        nextStory();
      }
    });
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    animationController.dispose();
    super.onClose();
  }

  void handleTap(TapUpDetails details) async {
    if (isPaused) {
      return;
    }
    if (isTapping) {
      return;
    }
    isTapping = true;
    animationController.stop();
    final double screenWidth = Get.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth * 0.4) {
      previousStory();
    } else {
      nextStory();
    }
    await Future.delayed(const Duration(seconds: 1));
    isTapping = false;
  }

  void pauseStory() {
    isPaused = true;
    videoPlayerController?.pause();
    animationController.stop();
  }

  void resumeStory() {
    isPaused = false;
    videoPlayerController?.play();
    animationController.forward();
  }

  void startAnimation() {
    StoryGroup currentStoryGroup = storyGroupController.getCurrentStoryGroup();
    exitAnimation();
    animationController.duration =
        currentStoryGroup.stories[currentStoryIndex].duration;
    animationController.forward();
  }

  void exitAnimation() {
    animationController.stop();
    animationController.reset();
  }

  void nextStory() {
    exitAnimation();
    StoryGroup currentStoryGroup = storyGroupController.getCurrentStoryGroup();
    currentStoryIndex = currentStoryGroup.getNextStory();
    if (currentStoryIndex != -1) {
      storyGroupController.updateStoryGroup(currentStoryGroup);
      videoPlayerController?.dispose();
      initVideoPlayerController();
      update();
    } else {
      nextStoryGroup();
    }
  }

  void previousStory() {
    exitAnimation();
    StoryGroup currentStoryGroup = storyGroupController.getCurrentStoryGroup();
    currentStoryIndex = currentStoryGroup.getPreviousStory();
    if (currentStoryIndex != -1) {
      storyGroupController.updateStoryGroup(currentStoryGroup);
      videoPlayerController?.dispose();
      initVideoPlayerController();
      update();
    } else {
      previousStoryGroup();
    }
  }

  void nextStoryGroup() {
    exitAnimation();
    int tempIndex = storyGroupController.getCurrentStoryGroupIndex() + 1;
    List<StoryGroup> storyGroups = storyGroupController.storyGroups;
    bool isAnyGroupLeft = false;

    while (tempIndex < storyGroups.length) {
      if (!storyGroups[tempIndex].isCompletelySeen) {
        PageController? pageController = storyGroupController.pageController;
        StoryGroup toBeShown = storyGroupController.storyGroups[tempIndex];
        toBeShown.newArrival = true;
        storyGroupController.updateStoryGroup(toBeShown);
        currentStoryIndex =
            storyGroupController.storyGroups[tempIndex].getNextStory();
        pageController!.animateToPage(
          tempIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        isAnyGroupLeft = true;
        videoPlayerController?.dispose();
        initVideoPlayerController();
        break;
      } else {
        tempIndex++;
      }
    }

    if (!isAnyGroupLeft) {
      exitAnimation();
      Get.to(() => const HomePage(), transition: Transition.downToUp);
    }
  }

  void previousStoryGroup() {
    exitAnimation();
    int tempIndex = storyGroupController.getCurrentStoryGroupIndex() - 1;
    List<StoryGroup> storyGroups = storyGroupController.storyGroups;
    bool isAnyGroupLeft = false;

    while (tempIndex >= 0) {
      if (!storyGroups[tempIndex].isCompletelySeen) {
        PageController? pageController = storyGroupController.pageController;
        StoryGroup toBeShown = storyGroupController.storyGroups[tempIndex];
        toBeShown.newArrival = true;
        storyGroupController.updateStoryGroup(toBeShown);
        currentStoryIndex =
            storyGroupController.storyGroups[tempIndex].getNextStory();
        pageController!.animateToPage(
          tempIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        isAnyGroupLeft = true;
        videoPlayerController?.dispose();
        initVideoPlayerController();
        break;
      } else {
        tempIndex--;
      }
    }

    if (!isAnyGroupLeft) {
      exitAnimation();
      Get.to(() => const HomePage(), transition: Transition.downToUp);
    }
  }
}
