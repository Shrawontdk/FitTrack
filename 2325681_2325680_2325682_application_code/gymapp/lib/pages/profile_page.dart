import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore dependency
import 'package:gymapp/pages/login.dart'; // Import the LoginPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variables for user data
  String name = "";
  String email = "";
  String weight = "";
  String height = "";
  String age = "";

  bool _isMuted = false;

  // Function to fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        // Safely check if fields exist before accessing
        setState(() {
          name = userDoc['name'] ?? "Unknown";
          email = userDoc['email'] ?? "No email";
          weight = userDoc['weight'] ?? "No weight data";
          height = userDoc['height'] ?? "No height data";
          age = userDoc['age'] ?? "No age data";
        });
      } else {
        print("No user document found");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the page is loaded
  }

  // Function to show the confirmation dialog for logout
  Future<void> _showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                FirebaseAuth.instance.signOut(); // Log out the user
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage()), // Redirect to login
                );
              },
              child: const Text('Yes'),
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
        title: const Text(
          'Profile Page',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // Profile Image and Details
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/147/147142.png'), // Default Image
            ),
            const SizedBox(height: 8),
            Text(
              name, // Display user's name
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              email, // Display user's email
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 16),

            // Weight, Height, Age Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildInfoColumn(weight, "Weight"),
                VerticalDivider(thickness: 1, color: Colors.grey.shade400),
                buildInfoColumn(height, "Height"),
                VerticalDivider(thickness: 1, color: Colors.grey.shade400),
                buildInfoColumn(age, "Age"),
              ],
            ),

            Divider(thickness: 1, color: Colors.grey.shade300, height: 32),

            // Mute Notification
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.black),
              title: const Text(
                "Mute Notification",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              trailing: Switch(
                value: _isMuted, // The value is bound to _isMuted
                onChanged: (bool value) {
                  setState(() {
                    _isMuted =
                        value; // Update the state when the switch is toggled
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

            const SizedBox(height: 24),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(
                      context); // Show the logout confirmation dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Center(
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
            const SizedBox(height: 16),
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
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 4),
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
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
