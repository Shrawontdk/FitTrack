import 'package:flutter/material.dart';
import 'package:gymapp/pages/login.dart'; // Import the LoginPage

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variable to manage the mute notification state
  bool _isMuted = false;

  // Function to show the confirmation dialog
  Future<void> _showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog and do nothing
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog and navigate to the LoginPage
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),

            // Profile Image and Details
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/147/147142.png'), // Replace with your image
            ),
            SizedBox(height: 8),
            Text(
              'Sabal Shakya',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              'shrawon@gmail.com',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),

            SizedBox(height: 16),

            // Weight, Height, Age Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildInfoColumn("75 kg", "Weight"),
                VerticalDivider(thickness: 1, color: Colors.grey.shade400),
                buildInfoColumn("5.10 ft", "Height"),
                VerticalDivider(thickness: 1, color: Colors.grey.shade400),
                buildInfoColumn("19 years", "Age"),
              ],
            ),

            Divider(thickness: 1, color: Colors.grey.shade300, height: 32),

            // Mute Notification
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.black),
              title: Text(
                "Mute Notification",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              trailing: Switch(
                value: _isMuted, // The value is bound to _isMuted
                onChanged: (bool value) {
                  setState(() {
                    _isMuted = value; // Update the state when the switch is toggled
                  });
                },
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade300),

            // Account Section
            buildListTile(Icons.account_circle, "Account", () {}),
            Divider(thickness: 1, color: Colors.grey.shade300),

            // Privacy Policy
            buildListTile(Icons.privacy_tip, "Privacy Policy", () {}),
            Divider(thickness: 1, color: Colors.grey.shade300),

            // Terms & Conditions
            buildListTile(Icons.article_outlined, "Term & Condition", () {}),

            SizedBox(height: 24),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Show the logout confirmation dialog
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper method for Info Column
  Column buildInfoColumn(String value, String title) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // Helper method for ListTile
  ListTile buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}
