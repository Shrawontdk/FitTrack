import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imageUrls = [
    // 'https://th.bing.com/th/id/OIP.dca5B7rvK8VCV_eboQecKAHaHa?rs=1&pid=ImgDetMain',
    // 'assets/images/chest_workout.png',
    "https://i.pinimg.com/236x/28/87/8d/28878d2dbe8caa961e44e82978a7a01e.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: const Text("HomePage"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chest Workout Banner with Slideshow
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
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
            sectionHeader("Today's Workout", "View All"),
            workoutCard(imageUrls[0], "Push-ups",
                "Chest, shoulders, triceps, core strength", "15 Reps x3"),

            // Progress Status Section
            sectionHeader("Progress Status", "See More"),
            progressCard(
                imageUrls[0], "12.100 Kcal", "Calories Loss", "+12.5 %", 0.45),
            progressCard(
                imageUrls[0], "12.100 Kcal", "Calories Loss", "+12.5 %", 0.45),
            progressCard(
                imageUrls[0], "12.100 Kcal", "Calories Loss", "+12.5 %", 0.45),

            // Daily Diet Section
            sectionHeader("Daily Diet", "See More"),
            dietCard(imageUrls[0], "Breakfast", "Calories: 650 kcal",
                "Protein: 25g", "Fats: 28g, Carbs: 75-100g"),
            dietCard(imageUrls[0], "Lunch", "Calories: 800 kcal",
                "Protein: 30g", "Fats: 35g, Carbs: 85-110g"),
            dietCard(imageUrls[0], "Dinner", "Calories: 700 kcal",
                "Protein: 28g", "Fats: 25g, Carbs: 70-95g"),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            action,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  Widget workoutCard(String image, String title, String subtitle, String reps) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
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
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  Widget progressCard(String image, String calories, String title,
      String percentage, double progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
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
                  style: const TextStyle(
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
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
