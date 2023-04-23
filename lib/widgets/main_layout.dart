import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  const MainLayout(
      {super.key,
      required this.buttonIcon,
      required this.onPressed,
      required this.child});
  final Icon buttonIcon;
  final Function() onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/codeway_logo.png',
              width: 60,
            ),
            Text(
              "Snippets",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: buttonIcon,
            iconSize: 30,
            color: Theme.of(context).primaryColor,
            onPressed: onPressed,
          ),
        ],
        elevation: 0,
      ),
      body: child,
    );
  }
}
