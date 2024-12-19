import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Ensure HomePage is correctly imported
import 'package:gymapp/pages/signup.dart';

import '../bnav.dart';     // Ensure SignUpPage is correctly imported

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image (using local image)
            Container(
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_background.jpg'), // Local image
                  fit: BoxFit.cover,
                ),
              ),
              child: const Stack(
                children: [
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      'GET\nBETTER\nRESULTS\nEASILY!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Login Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Login Title
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Welcome Back! Login using your details',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Email TextField
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Colors.teal),
                      hintText: 'Email Address',
                      filled: true,
                      fillColor: Colors.teal.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Password TextField
                  TextField(
                    controller: password,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.teal),
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        color: Colors.grey,
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.teal.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                     onPressed: () {
                       Navigator.push(context,MaterialPageRoute(builder: (context)=>BottomNavBar()));
                     }, // Trigger the SignIn method on button press

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Or Connect Section
                  const Row(
                    children: [
                      Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'or connect with',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          )),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Google Button (optional)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add your Google login logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/images/google_icon.png', // Replace with your local Google icon
                        width: 24,
                        height: 24,
                      ),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Login using Google',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Sign Up Section
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
