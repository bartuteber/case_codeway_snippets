import 'dart:ui';
import 'package:codeway_snippets/controllers/story_group_controller.dart';
import 'package:codeway_snippets/models/story_group_model.dart';
import 'package:codeway_snippets/widgets/story_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class StoryPlayerPage extends StatefulWidget {
  const StoryPlayerPage({super.key, required this.initialGroupIndex});

  final int initialGroupIndex;

  @override
  State<StoryPlayerPage> createState() => _StoryPlayerPageState();
}

class _StoryPlayerPageState extends State<StoryPlayerPage> {
  double? currentPageValue;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    currentPageValue = widget.initialGroupIndex.toDouble();
    StoryGroupController storyGroupController = Get.find();
    pageController = storyGroupController.pageController;

    pageController!.addListener(() {
      setState(() {
        currentPageValue = pageController!.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    StoryGroupController storyGroupController = Get.find();
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Colors.black,
        child: Scaffold(
          body: SafeArea(
            child: PageView.builder(
              controller: storyGroupController.pageController,
              itemCount: storyGroupController.storyGroups.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int groupIndex) {
                StoryGroup currentStoryGroup =
                    storyGroupController.storyGroups[groupIndex];
                final isLeaving = (groupIndex - currentPageValue!) <= 0;
                final t = (groupIndex - currentPageValue!);
                final rotationY = lerpDouble(0, 30, t)!;
                const maxOpacity = 0.8;
                final num opacity =
                    lerpDouble(0, maxOpacity, t.abs())!.clamp(0.0, maxOpacity);
                final isPaging = opacity != maxOpacity;
                final transform = Matrix4.identity();
                transform.setEntry(3, 2, 0.003);
                transform.rotateY(-rotationY * (pi / 180.0));
                return Transform(
                  alignment:
                      isLeaving ? Alignment.centerRight : Alignment.centerLeft,
                  transform: transform,
                  child: Stack(children: [
                    StoryItem(currentStoryGroup: currentStoryGroup),
                    if (isPaging && !isLeaving)
                      Positioned.fill(
                        child: Opacity(
                          opacity: opacity as double,
                          child: const ColoredBox(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                  ]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
