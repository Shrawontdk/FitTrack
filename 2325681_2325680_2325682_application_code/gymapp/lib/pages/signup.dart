import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:gymapp/question.dart';
import '../bnav.dart'; // Import BottomNavBar

class SignUp extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightcontroller = TextEditingController();

  SignUp({super.key});

  void signUpUser(BuildContext context) async {
    try {
      if (passwordController.text != confirmPasswordController.text) {
        throw Exception("Passwords do not match");
      }

      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Access user details
      User? user = userCredential.user;
      if (user == null) {
        throw Exception("Failed to retrieve user details");
      }

      // Log user information for debugging
      print("User signed up: ${user.uid}, ${user.email}");

      // Add additional user data (name, weight, and age) to Firestore
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'weight': weightController.text.trim(),
        'age': ageController.text.trim(),
        'height': heightcontroller.text.trim(),
      }).then((_) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup successful")),
        );

        // Navigate to BottomNavBar after successful signup
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => QuestionPage()),
          (route) => false, // Clears the navigation stack
        );
      }).catchError((error) {
        // Handle Firestore errors
        print("Error adding user data to Firestore: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${error.toString()}")),
        );
      });
    } catch (e) {
      print("Error during signup: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    InputDecoration textFieldDecoration(String hintText, IconData icon) {
      return InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Create your new account",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: nameController,
                decoration: textFieldDecoration("Full Name", Icons.person),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: emailController,
                decoration: textFieldDecoration("Email Address", Icons.email),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: textFieldDecoration("Password", Icons.lock),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: textFieldDecoration("Confirm Password", Icons.lock),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: weightController,
                decoration: textFieldDecoration("Weight", Icons.fitness_center),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: ageController,
                decoration: textFieldDecoration("Age", Icons.calendar_today),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: heightcontroller,
                decoration: textFieldDecoration("Height", Icons.height),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: screenWidth * 0.9,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => signUpUser(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Signup",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
