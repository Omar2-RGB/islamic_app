import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // تهيئة مكتبة الوقت
    tz.initializeTimeZones();

    // إعدادات الأندرويد
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    // تم التعديل هنا: استخدام `settings` كاسم للمتغير بناءً على طلب المكتبة
    await _notificationsPlugin.initialize(
      settings: initSettings,
    );
  }

  // دالة لجدولة الأذان
  static Future<void> schedulePrayer({
    required int id,
    required String prayerName,
    required DateTime time,
  }) async {
    // إذا كان وقت الصلاة قد مضى اليوم، لا تقم بجدولته
    if (time.isBefore(DateTime.now())) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'prayer_channel_id', 
      'أوقات الصلاة', 
      channelDescription: 'تنبيهات أوقات الصلاة والأذان',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('athan'), // اسم ملف الصوت
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: 'حان الآن موعد صلاة $prayerName',
      body: 'حي على الصلاة، حي على الفلاح',
      scheduledDate: tz.TZDateTime.from(time, tz.local),
      notificationDetails: platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, 
    );
  }

  // دالة لإلغاء تنبيه صلاة معينة عند كتمها
  static Future<void> cancelPrayer(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }
}