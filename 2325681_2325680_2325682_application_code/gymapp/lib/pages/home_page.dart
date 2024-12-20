import 'package:flutter/material.dart';

import '../data/excercise.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imageUrls = [
    // 'https://th.bing.com/th/id/OIP.dca5B7rvK8VCV_eboQecKAHaHa?rs=1&pid=ImgDetMain',
    // 'assets/images/chest_workout.png',
    "https://i.pinimg.com/236x/28/87/8d/28878d2dbe8caa961e44e82978a7a01e.jpg"
  ];
  final String dietUrl =
      'https://i.pinimg.com/736x/c1/a3/5f/c1a35f61a8bbbc989625433174446223.jpg';



  List<Map<String, dynamic>> getTodayExercises() {
    String today = DateTime.now().weekday == 1
        ? "Monday"
        : DateTime.now().weekday == 2
        ? "Tuesday"
        : DateTime.now().weekday == 3
        ? "Wednesday"
        : DateTime.now().weekday == 4
        ? "Thursday"
        : DateTime.now().weekday == 5
        ? "Friday"
        : DateTime.now().weekday == 6
        ? "Saturday"
        : "Sunday";

    return sevenexercises
        .firstWhere((element) => element['day'] == today)['exercises'] ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    final todayExercises = getTodayExercises();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(

        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text("HomePage"),

        centerTitle: true,


      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chest Workout Banner with Slideshow
            Container(
              height: 200,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: PageView.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      'https://i.pinimg.com/736x/e0/92/6e/e0926e27a858be396909c0a599b1b98d.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            // Today's Workout Section
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionHeader("Today's Workout", ""),
                  ...todayExercises.map((exercise) {
                    return workoutCard(
                      exercise['imageUrl'],
                      exercise['name'],
                      exercise['category'],
                      exercise['exercises'] + " Reps",
                    );
                  }).toList(),
                ],
              ),
            ),


            // Progress Status Section

            // Daily Diet Section
            sectionHeader("Daily Diet", "See More"),
            dietCard(
                dietUrl, "Breakfast", "Calories: 650 kcal", "Protein: 25g",
                "Fats: 28g, Carbs: 75-100g"),
            dietCard(
                dietUrl, "Lunch", "Calories: 800 kcal", "Protein: 30g",
                "Fats: 35g, Carbs: 85-110g"),
            dietCard(
                dietUrl, "Dinner", "Calories: 700 kcal", "Protein: 28g",
                "Fats: 25g, Carbs: 70-95g"),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            action,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  Widget workoutCard(String image, String title, String subtitle, String reps) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            reps,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  Widget progressCard(String image, String calories, String title,
      String percentage, double progress) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                Text(
                  calories,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  percentage,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal),
                ),
              ],
            ),
          ),
          CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget dietCard(String image, String title, String subtitle1,
      String subtitle2, String subtitle3) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                Text(
                  subtitle1,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  subtitle2,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                Text(
                  subtitle3,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}