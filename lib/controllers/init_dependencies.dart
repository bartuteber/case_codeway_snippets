import 'package:codeway_snippets/controllers/story_controller.dart';
import 'package:codeway_snippets/controllers/story_group_controller.dart';
import 'package:get/get.dart';

Future<void> initDependencies() async {
  Get.lazyPut(() => StoryController());
  Get.lazyPut(() => StoryGroupController());
}
