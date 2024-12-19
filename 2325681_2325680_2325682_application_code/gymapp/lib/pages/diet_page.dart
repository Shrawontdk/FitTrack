import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gymapp/pages/bmi.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class DietPage extends StatefulWidget {
  @override
  _DietPlanPageState createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPage> {
  final String imageUrl =
      'https://th.bing.com/th/id/OIP.dca5B7rvK8VCV_eboQecKAHaHa?rs=1&pid=ImgDetMain';

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime? _reminderTime;

  bool _isReminderOn = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
    InitializationSettings(android: androidInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();
  }

  Future<void> _scheduleNotification(DateTime scheduledTime) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel_id',
      'Reminder Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Meal Reminder',
      'It\'s time for your scheduled meal!',
      tzScheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _showDateTimePicker() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onChanged: (dateTime) {
        print('Selected Date-Time: $dateTime');
      },
      onConfirm: (dateTime) {
        setState(() {
          _reminderTime = dateTime;
        });

        if (_isReminderOn && _reminderTime != null) {
          _scheduleNotification(_reminderTime!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reminder set for $_reminderTime')),
          );
        }
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
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
              color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
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
                        Image.network(imageUrl,
                            width: 40, height: 40, fit: BoxFit.cover),
                        SizedBox(width: 12),
                        const Text(
                          'Set Reminder',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Spacer(),
                        Switch(
                          value: _isReminderOn,
                          onChanged: (val) {
                            setState(() {
                              _isReminderOn = val;
                            });

                            if (_isReminderOn) {
                              _showDateTimePicker();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Turn on the reminder to get notification when its time to eat.',
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
              SizedBox(height: 16),

              // Calendar and Meals...
              // Keep the rest of your original code here
            ],
          ),
        ),
      ),
    );
  }
}
