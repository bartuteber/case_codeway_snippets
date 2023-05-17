import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Functional Limitations:',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
            ),
            SizedBox(height: 8),
            Text(
              'Please note that during the one-week development period, I learned Flutter from scratch, having zero prior experience with it. As a senior year Computer Science student at Bilkent University, my time was limited due to other responsibilities. Nonetheless, I pushed my limits to create this project, and I hope you enjoy it.\n\n- Videos are not supported, although non-functioning logic exists in the codebase for the video player.\n- Cubic transitions are not supported.',
              style: TextStyle(fontSize: 17, height: 1.5),
            ),
            SizedBox(height: 17),
            Text(
              'App Features:',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
            ),
            SizedBox(height: 8),
            Text(
              '- This app is for IOS and Android. MacOS is not supported\n - To provide a more meaningful experience without authentication or a database, I organized stories into categories that reflect what makes Codeway the perfect place for me.\n- Images are stored on Google Drive and fetched using the Google API. As the API has request limits, a "Set All Unseen" button is provided at the top right corner. For testing purposes, please use this button to avoid exceeding API request limits.\n- If a story group contains unseen stories, a yellow-to-green border surrounds the cover image. (As a colorblind individual, I hope it really transitions to green :) )',
              style: TextStyle(fontSize: 17, height: 1.5),
            ),
            SizedBox(height: 17),
            Text(
              'Packages Used:',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
            ),
            SizedBox(height: 8),
            Text(
              '- get\n- http (for fetching images via Google API)\n- video_player (not included in the feature scope)',
              style: TextStyle(fontSize: 17, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
