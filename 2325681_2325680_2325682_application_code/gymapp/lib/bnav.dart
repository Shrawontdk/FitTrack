import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

// Importing pages
import 'pages/home_page.dart';
import 'pages/workout_page.dart';
import 'pages/diet_page.dart';
import 'pages/profile_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // List of pages
  final List<Widget> _pages = [
    HomePage(),
    WorkoutPage(),
    DietPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Page background color
      body: _pages[_selectedIndex], // Display the corresponding page
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Navigation bar background color
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            rippleColor: Colors.grey[800]!, // Ripple effect color
            hoverColor: Colors.grey[900]!, // Hover color
            gap: 8,
            activeColor: Colors.red, // Active icon and text color
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor:
                Colors.red.withOpacity(0.2), // Background for the active tab
            color: Colors.black, // Inactive icon color
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
                textStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GButton(
                icon: LineIcons.dumbbell,
                text: 'Workout',
                textStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GButton(
                icon: LineIcons.utensils,
                text: 'Diet',
                textStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
                textStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
