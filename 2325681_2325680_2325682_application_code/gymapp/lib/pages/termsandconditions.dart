import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to FitTrack! By accessing or using our application, you agree to the following terms and conditions. Please read them carefully.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '1. Acceptance of Terms\n'
                  'By downloading, installing, or using FitTrack, you agree to comply with and be bound by these terms and conditions, as well as our Privacy Policy. If you do not agree, please refrain from using our app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '2. Use of the App\n'
                  '- Eligibility: You must be at least 18 years old to use this app. If you are under 18, parental consent is required.\n'
                  '- Account Responsibility: You are responsible for maintaining the confidentiality of your account credentials and for all activities conducted through your account.\n'
                  '- Personal Use Only: The app is for personal and non-commercial use.',
              style: TextStyle(fontSize: 16),
            ),
            // Add more terms as needed...
            SizedBox(height: 8),
            Text(
              'Thank you for using FitTrack.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
