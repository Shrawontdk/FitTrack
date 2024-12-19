import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymapp/pages/login.dart';

import '../question.dart';

// AuthMethod for handling signup process
class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'displayName': name,
          'uid': cred.user!.uid,
          'email': email,
        });
        res = "success";
      } else {
        res = "Please fill out all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}

// SignUpPage class
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // signupUser function to handle the signup logic and navigate to the next page
  void signupUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    String res = await AuthMethod().signupUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (res == "success") {
      // Navigate to another page on successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AnotherPage()), // Replace with your destination page
      );
    } else {
      // Show error if signup failed
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Signup Error"),
            content: Text(res),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
              ),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              CustomInputField(
                controller: nameController,
                icon: Icons.person,
                hintText: "Full Name",
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: emailController,
                icon: Icons.email,
                hintText: "Email Address",
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: passwordController,
                icon: Icons.lock,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: confirmPasswordController,
                icon: Icons.lock,
                hintText: "Confirm Password",
                obscureText: true,
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: screenWidth * 0.9,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>QuestionPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomInputField widget for input fields
class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool obscureText;

  const CustomInputField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
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
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
    );
  }
}

// AnotherPage widget to navigate to after successful signup
class AnotherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text(
          'You have successfully signed up!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
