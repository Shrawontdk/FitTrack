import 'package:flutter/material.dart';

class SExercisePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Exercise",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.book_outlined, color: Colors.white, size: 18),
              label: Text("Record Form"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                elevation: 2,
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 8), // Minor spacing

            // Exercise Image
            Container(
              height: 250,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                child: Image.network(
                  'https://th.bing.com/th/id/OIP.dca5B7rvK8VCV_eboQecKAHaHa?rs=1&pid=ImgDetMain',
                  fit: BoxFit.cover,
                  width: double.infinity, // Image fits container width
                ),
              ),
            ),

            // "Ready To Go" Title
            Column(
              children: [
                Text(
                  "Ready To Go",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 8),
                Text(
                  "Push-Ups",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700),
                ),
                SizedBox(height: 4),
                Text(
                  "x15 Reps",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  Flexible(
                    child: TextButton.icon(
                      onPressed: () {
                        // Add previous logic here
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          color: Colors.grey.shade600),
                      label: Text(
                        "Previous",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Completed Button
                  Flexible(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add complete logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Completed",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Skip Button
                  Flexible(
                    child: TextButton.icon(
                      onPressed: () {
                        // Add skip logic here
                      },
                      icon: Icon(Icons.arrow_forward_ios,
                          color: Colors.grey.shade600),
                      label: Text(
                        "Skip",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
