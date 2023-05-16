import 'package:codeway_snippets/controllers/story_controller.dart';
import 'package:codeway_snippets/controllers/story_group_controller.dart';
import 'package:codeway_snippets/models/story_group_model.dart';
import 'package:codeway_snippets/widgets/story_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryPlayerPage extends StatelessWidget {
  const StoryPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    StoryController storyController = Get.find();
    StoryGroupController storyGroupController = Get.find();
    return WillPopScope(
      onWillPop: () async => false,
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
