// question_page.dart
import 'package:flutter/material.dart';

import 'bnav.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  // List of questions and their options
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the biggest challenge to achieving your goal?',
      'options': [
        'Lack of structure or guidance',
        'Tracking and measuring progress',
        'Limited time or equipment',
        'Accountability or motivation',
        'Something else'
      ]
    },
    {
      'question': 'How often do you track your progress?',
      'options': ['Daily', 'Weekly', 'Monthly', 'Rarely', 'Never']
    },
    {
      'question': 'What motivates you to work out?',
      'options': [
        'Physical appearance/fitness goals',
        'Mental health/stress relief',
        'Strength and performance improvement',
        'Social reasons (working out with friends)',
        'Other'
      ]
    },
    {
      'question': 'What type of workouts do you prefer?',
      'options': [
        'Strength training (weightlifting, resistance)',
        'Cardio (running, cycling, swimming)',
        'Yoga or Pilates',
        'High-intensity interval training (HIIT)',
        'Other'
      ]
    },
    {
      'question':
          'What is your biggest obstacle in maintaining a consistent workout routine?',
      'options': [
        'Lack of time',
        'Lack of motivation',
        'Physical injuries or limitations',
        'Not seeing quick enough results',
        'Other'
      ]
    }
  ];

  int currentQuestionIndex = 0; // Track the current question
  String? selectedAnswer; // Store the selected answer
  final Map<int, String> userAnswers = {}; // To store answers

  void _nextQuestion() {
    if (selectedAnswer != null) {
      setState(() {
        userAnswers[currentQuestionIndex] = selectedAnswer!; // Store the answer
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
          selectedAnswer = null;
        } else {
          _showResults();
        }
      });
    }
  }

  void _showResults() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BottomNavBar()));
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Your Answers'),
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: userAnswers.entries.map((entry) {
    //         return Text('Q${entry.key + 1}: ${entry.value}');
    //       }).toList(),
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //         child: const Text('Close'),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            if (currentQuestionIndex > 0) {
              setState(() {
                currentQuestionIndex--;
                selectedAnswer = userAnswers[currentQuestionIndex];
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'Fitness Goal (${currentQuestionIndex + 1}/${questions.length})',
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: _showResults,
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.red, fontSize: 16.0),
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: Padding(
          key: ValueKey<int>(currentQuestionIndex),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                currentQuestion['question'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Choose only one option.',
                style: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              const SizedBox(height: 20),
              ...currentQuestion['options'].map<Widget>((option) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAnswer = option;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: selectedAnswer == option
                            ? Colors.red
                            : Colors.grey.shade800,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedAnswer == option
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: selectedAnswer == option
                              ? Colors.red
                              : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          option,
                          style: TextStyle(
                            color: selectedAnswer == option
                                ? Colors.red
                                : Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedAnswer != null
                        ? Colors.red
                        : Colors.red.shade900,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
