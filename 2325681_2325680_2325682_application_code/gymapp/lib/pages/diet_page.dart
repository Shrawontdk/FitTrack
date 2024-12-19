import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gymapp/pages/bmi.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  _DietPlanPageState createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPage> {
  final String imageUrl =
      'https://th.bing.com/th/id/OIP.dca5B7rvK8VCV_eboQecKAHaHa?rs=1&pid=ImgDetMain';

  bool _isReminderOn = false;
  DateTime? _reminderTime;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Controllers for each field (time, calories, food) for each meal
  TextEditingController breakfastTimeController = TextEditingController();
  TextEditingController breakfastCalController = TextEditingController();
  TextEditingController breakfastFoodController = TextEditingController();

  TextEditingController lunchTimeController = TextEditingController();
  TextEditingController lunchCalController = TextEditingController();
  TextEditingController lunchFoodController = TextEditingController();

  TextEditingController snackTimeController = TextEditingController();
  TextEditingController snackCalController = TextEditingController();
  TextEditingController snackFoodController = TextEditingController();

  TextEditingController dinnerTimeController = TextEditingController();
  TextEditingController dinnerCalController = TextEditingController();
  TextEditingController dinnerFoodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initializeNotifications();
    _loadReminderState();
  }

  Future<void> _initializeNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'meal_reminder_channel',
      'Meal Reminders',
      description: 'Channel for meal reminders',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(DateTime scheduledTime) async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'meal_reminder_channel',
        'Meal Reminders',
        channelDescription: 'Reminders for your meals',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Meal Reminder',
        'It\'s time for your scheduled meal!',
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reminder set for ${scheduledDate.toLocal()}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error scheduling notification: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to set reminder: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'meal_reminder_channel',
      'Meal Reminders',
      channelDescription: 'Reminders for your meals',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder Set',
      'Your diet reminder is now active!',
      notificationDetails,
    );
  }

  Future<void> _showDateTimePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _reminderTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });

        if (_isReminderOn && _reminderTime != null) {
          await _scheduleNotification(_reminderTime!);
          await _showNotification();
          _saveReminderState();
        }
      }
    }
  }

  Future<void> _loadReminderState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isReminderOn = prefs.getBool('isReminderOn') ?? false;
      final reminderTimeString = prefs.getString('reminderTime');
      if (reminderTimeString != null) {
        _reminderTime = DateTime.parse(reminderTimeString);
      }
    });
  }

  Future<void> _saveReminderState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isReminderOn', _isReminderOn);
    if (_reminderTime != null) {
      prefs.setString('reminderTime', _reminderTime!.toIso8601String());
    } else {
      prefs.remove('reminderTime');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Personalized Diet Plan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reminder Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Set Reminder',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: _isReminderOn,
                          onChanged: (val) async {
                            setState(() {
                              _isReminderOn = val;
                            });

                            if (val) {
                              _showDateTimePicker();
                            } else {
                              await flutterLocalNotificationsPlugin.cancelAll();
                              setState(() {
                                _reminderTime = null;
                              });
                              _saveReminderState();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Reminder cancelled'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Turn on the reminder to get a notification when it\'s time to eat.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (_reminderTime != null)
                      Text(
                        'Reminder set for: ${_reminderTime!.toLocal()}',
                        style:
                        const TextStyle(fontSize: 12, color: Colors.teal),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Calendar
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Diet Cards
              mealCard('Breakfast', breakfastTimeController, breakfastCalController, breakfastFoodController),
              mealCard('Lunch', lunchTimeController, lunchCalController, lunchFoodController),
              mealCard('Snack', snackTimeController, snackCalController, snackFoodController),
              mealCard('Dinner', dinnerTimeController, dinnerCalController, dinnerFoodController),
            ],
          ),
        ),
      ),
    );
  }

  // Meal Card Widget
  Widget mealCard(
      String mealType,
      TextEditingController timeController,
      TextEditingController calController,
      TextEditingController foodController) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealType,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Time: ${timeController.text.isEmpty ? "Not set" : timeController.text}',
                ),
                Text(
                  'Calories: ${calController.text.isEmpty ? "Not set" : calController.text}',
                ),
                Text(
                  'Food: ${foodController.text.isEmpty ? "Not set" : foodController.text}',
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              _showEditDietDialog(mealType, timeController, calController, foodController);
            },
          ),
        ],
      ),
    );
  }

  // Edit Diet Dialog for individual meals with 3 fields
  void _showEditDietDialog(
      String mealType,
      TextEditingController timeController,
      TextEditingController calController,
      TextEditingController foodController,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $mealType'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: calController,
                decoration: InputDecoration(labelText: 'Calories'),
              ),
              TextField(
                controller: foodController,
                decoration: InputDecoration(labelText: 'Food'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
