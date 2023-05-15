import 'package:codeway_snippets/controllers/story_group_controller.dart';
import 'package:codeway_snippets/enums/media_type.dart';
import 'package:codeway_snippets/enums/page_arrival_type.dart';
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
  Rx<VideoPlayerController?> videoPlayerController =
      Rx<VideoPlayerController?>(null);
  Future<void>? initializeVideoPlayerFuture;
  bool isPaused = false;
  bool isTapping = false;
  var isVideoLoading = false.obs;

  int currentStoryIndex = 0;

  @override
  void onInit() {
    super.onInit();
    initVideoPlayerController();
    initAnimationController();
  }

  void initVideoPlayerController() {
    Story currentStory = storyGroupController
        .getCurrentStoryGroup()
        .getStoryByIndex(currentStoryIndex);
    if (currentStory.mediaType == MediaType.video) {
      videoPlayerController.value =
          VideoPlayerController.network(currentStory.url);
      initializeVideoPlayerFuture = videoPlayerController.value!.initialize();
      initializeVideoPlayerFuture!.then((_) {
        currentStory.duration = videoPlayerController.value!.value.duration;
        print(
            "animation will start, duration: ${currentStory.duration}, name: ${currentStory.id}");
        startAnimation(currentStory);
        update();
        videoPlayerController.value?.play();
      });
    }
  }

  void initAnimationController() {
    animationController = AnimationController(vsync: this);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("animation ended");
        nextStory();
      }
    });
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    videoPlayerController.value = null;
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
    await Future.delayed(const Duration(milliseconds: 500));
    isTapping = false;
  }

  void pauseStory() {
    isPaused = true;
    videoPlayerController.value?.pause();
    animationController.stop();
  }

  void resumeStory() {
    isPaused = false;
    videoPlayerController.value?.play();
    animationController.forward();
  }

  void startAnimation(Story story) {
    exitAnimation();
    animationController.duration = story.duration;
    animationController.forward();
  }

  void exitAnimation() {
    animationController.stop();
    animationController.reset();
  }

  void nextStory({int? directStoryGroupIndex}) {
    if (directStoryGroupIndex == null) {
      exitAnimation();
    }
    videoPlayerController.value?.dispose();
    videoPlayerController.value = null;
    StoryGroup currentStoryGroup;
    if (directStoryGroupIndex != null) {
      currentStoryGroup =
          storyGroupController.storyGroups[directStoryGroupIndex];
    } else {
      currentStoryGroup = storyGroupController.getCurrentStoryGroup();
    }
    int tempCurrentStoryIndex = currentStoryGroup.getNextStory();
    if (tempCurrentStoryIndex != -1) {
      //just a safeguard
      if (tempCurrentStoryIndex <
          storyGroupController.getCurrentStoryGroup().stories.length) {
        currentStoryIndex = tempCurrentStoryIndex;
      }
      //storyGroupController.updateStoryGroup(currentStoryGroup);
      initVideoPlayerController();
      if (directStoryGroupIndex == null) {
        update();
      }
    } else {
      nextStoryGroup();
    }
  }

  void previousStory() {
    exitAnimation();
    videoPlayerController.value?.dispose();
    videoPlayerController.value = null;
    StoryGroup currentStoryGroup = storyGroupController.getCurrentStoryGroup();
    int tempCurrentStoryIndex = currentStoryGroup.getPreviousStory();
    if (tempCurrentStoryIndex != -1) {
      //just a safeguard
      if (tempCurrentStoryIndex <
          storyGroupController.getCurrentStoryGroup().stories.length) {
        currentStoryIndex = tempCurrentStoryIndex;
      }
      //storyGroupController.updateStoryGroup(currentStoryGroup);
      initVideoPlayerController();
      update();
    } else {
      previousStoryGroup();
    }
  }

  void nextStoryGroup() {
    exitAnimation();
    videoPlayerController.value?.dispose();
    videoPlayerController.value = null;
    int tempIndex = storyGroupController.getCurrentStoryGroupIndex() + 1;
    List<StoryGroup> storyGroups = storyGroupController.storyGroups;
    bool isAnyGroupLeft = false;

    while (tempIndex < storyGroups.length) {
      if (!storyGroups[tempIndex].isCompletelySeen()) {
        StoryGroup toBeShown = storyGroupController.storyGroups[tempIndex];
        toBeShown.arrivalType = PageArrivalType.swipe;
        //storyGroupController.updateStoryGroup(toBeShown);
        currentStoryIndex = toBeShown.getNextStory();
        PageController? pageController = storyGroupController.pageController;
        pageController!
            .animateToPage(
          tempIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        )
            .then((_) {
          initVideoPlayerController();
        });
        isAnyGroupLeft = true;
        break;
      } else {
        tempIndex++;
      }
    }

    if (!isAnyGroupLeft) {
      exitAnimation();
      videoPlayerController.value?.dispose();
      videoPlayerController.value = null;
      Get.to(() => const HomePage(), transition: Transition.downToUp);
    }
  }

  void previousStoryGroup() {
    exitAnimation();
    videoPlayerController.value?.dispose();
    videoPlayerController.value = null;
    int tempIndex = storyGroupController.getCurrentStoryGroupIndex() - 1;
    List<StoryGroup> storyGroups = storyGroupController.storyGroups;
    bool isAnyGroupLeft = false;

    while (tempIndex >= 0) {
      if (!storyGroups[tempIndex].isCompletelySeen()) {
        PageController? pageController = storyGroupController.pageController;
        StoryGroup toBeShown = storyGroupController.storyGroups[tempIndex];
        toBeShown.arrivalType = PageArrivalType.swipe;
        //storyGroupController.updateStoryGroup(toBeShown);
        currentStoryIndex = toBeShown.getNextStory();
        pageController!
            .animateToPage(
          tempIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        )
            .then((_) {
          initVideoPlayerController();
        });
        isAnyGroupLeft = true;
        break;
      } else {
        tempIndex--;
      }
    }

    if (!isAnyGroupLeft) {
      exitAnimation();
      videoPlayerController.value?.dispose();
      videoPlayerController.value = null;
      Get.to(() => const HomePage(), transition: Transition.downToUp);
    }
  }
}
