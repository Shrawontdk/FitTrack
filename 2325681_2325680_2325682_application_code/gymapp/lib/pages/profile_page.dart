import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gymapp/pages/login.dart';
import 'package:gymapp/pages/termsandconditions.dart';

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

  // Theme mode variable
  ThemeMode _themeMode = ThemeMode.light;

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
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

  // Load preferences for mute state and theme mode
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMuted = prefs.getBool('isMuted') ?? false;
      String? savedTheme = prefs.getString('themeMode') ?? 'light';
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Save theme mode to SharedPreferences
  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'themeMode', themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Profile Page'),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Theme(
          data: Theme.of(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/147/147142.png'),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
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
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text("Mute Notification"),
                  trailing: Switch(
                    value: _isMuted,
                    onChanged: (bool value) {
                      setState(() {
                        _isMuted = value;
                      });
                      SharedPreferences.getInstance()
                          .then((prefs) => prefs.setBool('isMuted', value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isMuted
                                ? 'Notifications are muted'
                                : 'Mute notification is disabled',
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: _isMuted ? Colors.red : Colors.green,
                        ),
                      );
                    },
                  ),
                ),
                Divider(thickness: 1, color: Colors.grey.shade300),
                ListTile(
                  leading: const Icon(Icons.brightness_6),
                  title: const Text("Theme Mode"),
                  trailing: DropdownButton<ThemeMode>(
                    value: _themeMode,
                    onChanged: (ThemeMode? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _themeMode = newValue;
                        });
                        _saveThemeMode(newValue);
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text("Light"),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text("Dark"),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1, color: Colors.grey.shade300),
                buildListTile(
                  Icons.article_outlined,
                  "Terms & Conditions",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsAndConditionsPage(),
                      ),
                    );
                  },
                ),
                Divider(thickness: 1, color: Colors.grey.shade300),

                // Logout Button
                buildListTile(
                  Icons.logout,
                  "Logout",
                  () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildInfoColumn(String value, String title) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  ListTile buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
