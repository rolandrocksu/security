import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'What is a permission manager app?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A permission manager app allows you to control the permissions that other apps have on your device. With a permission manager app, you can easily see which apps have access to your location, camera, microphone, contacts, and other sensitive information. You can then choose to revoke or grant access to specific apps.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Why do I need a permission manager app?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Many apps request permissions to access your personal information, such as your location or contacts, even if it\'s not necessary for the app to function properly. With a permission manager app, you can control which apps have access to this information and prevent apps from collecting data without your consent. This can help protect your privacy and personal data.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'How does a permission manager app work?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'A permission manager app uses the Android or iOS operating system\'s APIs to display a list of all the permissions that each app on your device has requested. You can then choose to allow or deny specific permissions for each app. Some permission manager apps also provide additional features, such as the ability to block certain apps from accessing the internet or to detect and block ads and trackers.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Is it safe to use a permission manager app?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Yes, it is safe to use a permission manager app. However, it\'s important to choose a reputable app from a trusted developer to ensure that your personal information is not compromised. Additionally, some apps may not function properly if certain permissions are denied, so it\'s important to be aware of the potential consequences before making any changes to app permissions.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions or feedback, please contact us at rolandrocking@gmail.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
