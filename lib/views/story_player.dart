import 'package:codeway_snippets/controllers/story_controller.dart';
import 'package:codeway_snippets/controllers/story_group_controller.dart';
import 'package:codeway_snippets/models/story_group_model.dart';
import 'package:codeway_snippets/widgets/story_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryPlayerPage extends StatefulWidget {
  const StoryPlayerPage({super.key, required this.initialGroupIndex});
  final int initialGroupIndex;

  @override
  State<StoryPlayerPage> createState() => _StoryPlayerPageState();
}

class _StoryPlayerPageState extends State<StoryPlayerPage> {
  @override
  void initState() {
    StoryController storyController = Get.find();
    StoryGroupController storyGroupController = Get.find();
    storyController.nextStory(directStoryGroupIndex: widget.initialGroupIndex);
    storyGroupController.initializePageController(
        initialPage: widget.initialGroupIndex);
    super.initState();
  }

  @override
  void dispose() {
    StoryGroupController storyGroupController = Get.find();
    StoryController storyController = Get.find();
    storyGroupController.pageController?.dispose();
    storyController.animationController.dispose();
    storyController.videoPlayerController.value?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StoryController storyController = Get.find();
    StoryGroupController storyGroupController = Get.find();
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: PageView.builder(
            controller: storyGroupController.pageController,
            itemCount: storyGroupController.storyGroups.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int groupIndex) {
              StoryGroup currentStoryGroup =
                  storyGroupController.storyGroups[groupIndex];
              return GetBuilder<StoryController>(
                init: storyController,
                builder: (storyController) {
                  return StoryItem(currentStoryGroup: currentStoryGroup);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
