import 'package:codeway_snippets/helper/init_stories.dart';
import 'package:codeway_snippets/models/story_group_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryGroupController extends GetxController {
  final RxList<StoryGroup> _storyGroups = initialStoryGroups.obs;
  RxList<StoryGroup> get storyGroups => _storyGroups;
  PageController? pageController;

  set storyGroups(List<StoryGroup> storyGroups) {
    _storyGroups.value = storyGroups;
    update();
  }

  @override
  void onClose() {
    pageController?.dispose();
    super.onClose();
  }

  void updateStoryGroup(StoryGroup storyGroup) {
    int index = _storyGroups.indexWhere((sg) => storyGroup.id == sg.id);
    _storyGroups[index] = storyGroup;
  }

  StoryGroup getCurrentStoryGroup() {
    int index = 0;
    if (pageController?.positions.length == 1) {
      index = pageController?.page?.round() ?? 0;
    }

    return storyGroups[index];
  }

  int getCurrentStoryGroupIndex() {
    int index = 0;
    if (pageController?.positions.length == 1) {
      index = pageController?.page?.round() ?? 0;
    }
    return index;
  }

  void setAllUnseen() {
    List<StoryGroup> updatedStoryGroups = [];

    for (StoryGroup storyGroup in _storyGroups) {
      storyGroup.lastShownStoryIndex = -1;
      storyGroup.lastSeenStoryIndex = -1;
      storyGroup.newArrival = false;
      updatedStoryGroups.add(storyGroup);
    }

    _storyGroups.value = updatedStoryGroups;
  }

  void initializePageController({required int initialPage}) {
    pageController = PageController(initialPage: initialPage);
  }
}
