import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class DietPage extends StatefulWidget {
  @override
  _DietPlanPageState createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPage> {
  final String imageUrl =
      'https://th.bing.com/th/id/OIP.dca5B7rvK8VCV_eboQecKAHaHa?rs=1&pid=ImgDetMain';

  bool _isReminderOn = false;
  DateTime? _reminderTime;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize time zones
    _initializeNotifications();
    _loadReminderState(); // Load saved reminder state
  }

  Future<void> _initializeNotifications() async {
    // Create a notification channel (Android)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'meal_reminder_channel',
      'Meal Reminders',
      description: 'Channel for meal reminders',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Initialize notification settings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(DateTime scheduledTime) async {
    try {
      // Cancel any existing notifications
      await flutterLocalNotificationsPlugin.cancelAll();

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

      // If the time is in the past, schedule for the next day
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'meal_reminder_channel', // Channel ID
        'Meal Reminders',       // Channel Name
        channelDescription: 'Reminders for your meals', // Channel Description
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        1, // Notification ID
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
          _saveReminderState(); // Save state
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
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 6,
                      offset: Offset(0, 4),
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
                        SizedBox(width: 12),
                        const Text(
                          'Set Reminder',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
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
                              _saveReminderState(); // Save state
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
                        style: TextStyle(fontSize: 12, color: Colors.teal),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
