import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:codeway_snippets/controllers/story_controller.dart';
import 'package:codeway_snippets/controllers/story_group_controller.dart';
import 'package:codeway_snippets/enums/media_type.dart';
import 'package:codeway_snippets/enums/page_arrival_type.dart';
import 'package:codeway_snippets/models/story_group_model.dart';
import 'package:codeway_snippets/views/story_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codeway_snippets/helper/download_image_data.dart' as di;
import 'package:codeway_snippets/widgets/main_layout.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    print("home page init");
  }

  @override
  Widget build(BuildContext context) {
    StoryGroupController storyGroupController = Get.find();
    return WillPopScope(
      onWillPop: () async => false,
      child: MainLayout(
          buttonIcon: const Icon(Icons.info),
          onPressed: () {
            Get.to(() => const AboutPage(), transition: Transition.fadeIn);
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "All Snippets",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          decoration: TextDecoration.none),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Set All Unseen',
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.background)),
                        IconButton(
                            tooltip: 'Refresh Story Groups',
                            color: Theme.of(context).colorScheme.background,
                            onPressed: () {
                              storyGroupController.setAllUnseen();
                            },
                            icon: const Icon(Icons.refresh))
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ListView.builder(
                    itemCount:
                        (storyGroupController.storyGroups.length / 2).ceil(),
                    itemBuilder: (BuildContext context, int index) {
                      int leftIndex = index * 2;
                      int rightIndex = leftIndex + 1;
                      bool hasRightStoryGroup =
                          rightIndex < storyGroupController.storyGroups.length;
                      return Row(
                        children: [
                          Expanded(
                            child: _buildStoryGroupContainer(leftIndex),
                          ),
                          Expanded(
                            child: hasRightStoryGroup
                                ? _buildStoryGroupContainer(rightIndex)
                                : Container(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget _buildStoryGroupContainer(int storyGroupIndex) {
    StoryGroupController storyGroupController = Get.find();
    StoryController storyController = Get.find();
    return GestureDetector(
      onTap: () {
        storyGroupController.storyGroups[storyGroupIndex].arrivalType =
            PageArrivalType.directTap;
        storyController.nextStory(directStoryGroupIndex: storyGroupIndex);
        storyGroupController.initializePageController(
            initialPage: storyGroupIndex);
        Get.to(() => const StoryPlayerPage(), transition: Transition.zoom);
      },
      child: Container(
        height: 250,
        margin: const EdgeInsets.only(bottom: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Obx(() {
          StoryGroup storyGroup =
              storyGroupController.storyGroups[storyGroupIndex];
          return Stack(
            children: [
              storyGroup.stories[0].mediaType == MediaType.image
                  ? Stack(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: storyGroup.stories[0].url,
                            imageBuilder: (context, imageProvider) {
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
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )),
                      if (!storyGroup.isCompletelySeen())
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color.fromARGB(255, 234, 255, 0),
                                width: 7,
                              ),
                            ),
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                    ])
                  : Image.asset(
                      'assets/codeway_logo.png',
                      width: 60,
                    ),
              Container(
                padding: storyGroup.isCompletelySeen()
                    ? const EdgeInsets.all(8)
                    : const EdgeInsets.all(13),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black.withAlpha(0),
                      Colors.black38,
                      Colors.black54
                    ],
                  ),
                ),
                child: Text(
                  storyGroup.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
