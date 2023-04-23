import 'package:codeway_snippets/utils/theme_colors.dart';
import 'package:codeway_snippets/views/about_page.dart';
import 'package:codeway_snippets/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codeway_snippets/controllers/init_dependencies.dart' as id;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await id.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Codeway Snippets',
      theme: customTheme,
      initialRoute: "/",
      getPages: [
        GetPage(
            name: "/",
            page: () => const HomePage(),
            transition: Transition.fadeIn),
        GetPage(
            name: "/about",
            page: () => const AboutPage(),
            transition: Transition.fadeIn)
      ],
    );
  }
}
