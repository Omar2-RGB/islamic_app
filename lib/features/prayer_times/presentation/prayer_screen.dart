import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import 'package:audioplayers/audioplayers.dart'; // 💡 1. استيراد الحزمة

// هنا قمنا بإخفاء TextDirection الخاص بمكتبة intl لكي لا يتعارض مع فلاتر
import 'package:intl/intl.dart' hide TextDirection;

import 'prayer_provider.dart';
import '../../../core/services/notification_service.dart';

// الألوان الداكنة الثابتة للتطبيق
const Color bgColor = Color(0xFF0D1818);
const Color cardColor = Color(0xFF162224);
const Color goldColor = Color(0xFFD4AF37);

class PrayerScreen extends ConsumerStatefulWidget {
  const PrayerScreen({super.key});

  @override
  ConsumerState<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends ConsumerState<PrayerScreen> {
  // 💡 2. إنشاء كائن تشغيل الصوت عالمياً للشاشة للتحكم فيه من مكان واحد
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingAthan = false; // حالة التشغيل الحالية

  @override
  void dispose() {
    // 💡 3. تحرير كائن الصوت عند إغلاق الشاشة لتوفير موارد الجهاز
    _audioPlayer.dispose();
    super.dispose();
  }

  // 💡 4. دالة لتشغيل أو إيقاف صوت الأذان تجريبياً عند طلب الأبناء
  Future<void> _playTestAdhan() async {
    try {
      if (_isPlayingAthan) {
        await _audioPlayer.stop();
        setState(() => _isPlayingAthan = false);
      } else {
        // تشغيل الملف من الـ Assets
        // 💡 تأكد من وجود ملف assets/sounds/athan.mp3 وتعريفه في pubspec.yaml
        await _audioPlayer.play(AssetSource('sounds/athan.mp3'));
        setState(() => _isPlayingAthan = true);

        // الاستماع لانتهاء الصوت لإعادة الأيقونة لوضعها الطبيعي تلقائياً
        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) {
            setState(() => _isPlayingAthan = false);
          }
        });
      }
    } catch (e) {
      debugPrint("خطأ في تشغيل الصوت التجريبي: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر تشغيل ملف الصوت التجريبي')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prayerTimesAsyncValue = ref.watch(prayerTimesProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: prayerTimesAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator(color: goldColor)),
        error: (error, stack) => Center(child: Text('حدث خطأ: $error', style: const TextStyle(color: Colors.red))),
        data: (prayerTimes) {
          if (prayerTimes == null) {
            return const Center(
              child: Text('يرجى تفعيل الموقع لمعرفة أوقات الصلاة.', style: TextStyle(color: Colors.white, fontSize: 16))
            );
          }

          String formatTime(DateTime time) {
            // 💡 تنسيق الوقت ليناسب اللغة العربية (مثلاً 5:30 ص)
            return DateFormat.jm('ar').format(time);
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            physics: const BouncingScrollPhysics(),
            children: [
              // العداد التنازلي للصلاة القادمة
              _NextPrayerCountdown(prayerTimes: prayerTimes),
              const SizedBox(height: 30),

              const Text(
                'أوقات الصلاة',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: goldColor, fontFamily: 'Uthmanic'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              _PrayerTile(
                id: 1,
                title: 'الفجر',
                timeString: formatTime(prayerTimes.fajr),
                dateTime: prayerTimes.fajr,
                isPlayingAthan: _isPlayingAthan, // تمرير حالة التشغيل الحالية
                onPlayTest: _playTestAdhan, // تمرير الدالة لتنفيذها عند الضغط
              ),
              _PrayerTile(
                id: 2,
                title: 'الشروق',
                timeString: formatTime(prayerTimes.sunrise),
                dateTime: prayerTimes.sunrise,
                isPlayingAthan: _isPlayingAthan,
                onPlayTest: _playTestAdhan,
                isSunrise: true, // تمييز الشروق لأنه لا أذان له
              ),
              _PrayerTile(
                id: 3,
                title: 'الظهر',
                timeString: formatTime(prayerTimes.dhuhr),
                dateTime: prayerTimes.dhuhr,
                isPlayingAthan: _isPlayingAthan,
                onPlayTest: _playTestAdhan,
              ),
              _PrayerTile(
                id: 4,
                title: 'العصر',
                timeString: formatTime(prayerTimes.asr),
                dateTime: prayerTimes.asr,
                isPlayingAthan: _isPlayingAthan,
                onPlayTest: _playTestAdhan,
              ),
              _PrayerTile(
                id: 5,
                title: 'المغرب',
                timeString: formatTime(prayerTimes.maghrib),
                dateTime: prayerTimes.maghrib,
                isPlayingAthan: _isPlayingAthan,
                onPlayTest: _playTestAdhan,
              ),
              _PrayerTile(
                id: 6,
                title: 'العشاء',
                timeString: formatTime(prayerTimes.isha),
                dateTime: prayerTimes.isha,
                isPlayingAthan: _isPlayingAthan,
                onPlayTest: _playTestAdhan,
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// ويدجت العداد التنازلي للصلاة القادمة (Live Timer)
// ---------------------------------------------------------
class _NextPrayerCountdown extends StatefulWidget {
  final PrayerTimes prayerTimes;

  const _NextPrayerCountdown({required this.prayerTimes});

  @override
  State<_NextPrayerCountdown> createState() => _NextPrayerCountdownState();
}

class _NextPrayerCountdownState extends State<_NextPrayerCountdown> {
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;
  String _nextPrayerName = '';

  @override
  void initState() {
    super.initState();
    _calculateNextPrayer(); // الحساب لأول مرة
    // تحديث العداد كل ثانية
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateNextPrayer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // إيقاف العداد عند الخروج من الشاشة لتوفير البطارية
    super.dispose();
  }

  void _calculateNextPrayer() {
    final now = DateTime.now();
    DateTime? nextTime;

    // تحديد الصلاة القادمة يدوياً وبدقة
    if (now.isBefore(widget.prayerTimes.fajr)) {
      _nextPrayerName = 'الفجر';
      nextTime = widget.prayerTimes.fajr;
    } else if (now.isBefore(widget.prayerTimes.sunrise)) {
      _nextPrayerName = 'الشروق';
      nextTime = widget.prayerTimes.sunrise;
    } else if (now.isBefore(widget.prayerTimes.dhuhr)) {
      _nextPrayerName = 'الظهر';
      nextTime = widget.prayerTimes.dhuhr;
    } else if (now.isBefore(widget.prayerTimes.asr)) {
      _nextPrayerName = 'العصر';
      nextTime = widget.prayerTimes.asr;
    } else if (now.isBefore(widget.prayerTimes.maghrib)) {
      _nextPrayerName = 'المغرب';
      nextTime = widget.prayerTimes.maghrib;
    } else if (now.isBefore(widget.prayerTimes.isha)) {
      _nextPrayerName = 'العشاء';
      nextTime = widget.prayerTimes.isha;
    } else {
      // إذا انتهت صلاة العشاء، فالصلاة القادمة هي فجر اليوم التالي
      _nextPrayerName = 'الفجر';
      nextTime = widget.prayerTimes.fajr.add(const Duration(days: 1));
    }

    // حساب الفارق بين الوقت الحالي ووقت الصلاة القادمة
    if (mounted) {
      setState(() {
        _timeRemaining = nextTime!.difference(now);
      });
    }
  }

  // تنسيق الوقت ليظهر بشكل 00:00:00
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        // 💡 استخدام الطريقة الحديثة لتجنب تحذير withOpacity المستقبلي
        side: BorderSide(color: goldColor.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              'الوقت المتبقي لصلاة $_nextPrayerName',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Uthmanic',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _formatDuration(_timeRemaining),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: goldColor, // الأرقام باللون الذهبي
                letterSpacing: 2.0,
              ),
              textDirection: TextDirection.ltr,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// ويدجت تصميم سطر الصلاة مع زر الأذان وزر الاستماع
// ---------------------------------------------------------
class _PrayerTile extends StatefulWidget {
  final int id;
  final String title;
  final String timeString;
  final DateTime dateTime;
  final bool isPlayingAthan; // 💡 استقبال حالة التشغيل من الأب
  final VoidCallback onPlayTest; // 💡 استقبال دالة التشغيل من الأب
  final bool isSunrise; // تمييز الشروق

  const _PrayerTile({
    required this.id,
    required this.title,
    required this.timeString,
    required this.dateTime,
    required this.isPlayingAthan,
    required this.onPlayTest,
    this.isSunrise = false,
  });

  @override
  State<_PrayerTile> createState() => _PrayerTileState();
}

class _PrayerTileState extends State<_PrayerTile> {
  // 💡 يجب تخزين حالة الجرس لكل صلاة بشكل دائم (مثلاً في Hive أو SharedPreferences)
  // حالياً هي وهمية للتصميم وتعود لوضعها الأصلي عند الخروج.
  bool isAthanEnabled = true;

  @override
  void initState() {
    super.initState();
    // الشروق لا أذان له
    if (widget.isSunrise) {
      isAthanEnabled = false;
    }
    // جدولة الإشعار وقت التهيئة (برمجياً يجب أن تكون في الـ Provider للحفظ المستمر)
    if (isAthanEnabled) {
      NotificationService.schedulePrayer(
        id: widget.id,
        prayerName: widget.title,
        time: widget.dateTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor, // لون البطاقة الداكن
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // إطار خفيف جداً، استخدام الطريقة الحديثة لتجنب تحذير withOpacity
        side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text(widget.timeString, style: const TextStyle(fontSize: 16, color: goldColor, fontWeight: FontWeight.w600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 💡 5. تعديل هنا: إضافة زر الاستماع "يأذن كمان" إذا كانت الصلاة مكتومة وليست الشروق
            if (isAthanEnabled == false && widget.isSunrise == false)
              IconButton(
                visualDensity: VisualDensity.compact,
                // تغيير الأيقونة بناءً على حالة التشغيل الممرة من الأب
                icon: Icon(
                  widget.isPlayingAthan ? Icons.stop_circle_outlined : Icons.play_circle_outline_rounded,
                  color: widget.isPlayingAthan ? Colors.red.withValues(alpha: 0.7) : goldColor.withValues(alpha: 0.7),
                  size: 28,
                ),
                tooltip: widget.isPlayingAthan ? 'إيقاف الاستماع' : 'استماع لصوت المؤذن',
                onPressed: widget.onPlayTest, // استدعاء الدالة الممرة من الأب
              ),

            // زر كتم/تفعيل الأذان (الجرس)
            if (widget.isSunrise == false)
              IconButton(
                iconSize: 26,
                icon: Icon(
                  isAthanEnabled ? Icons.volume_up : Icons.volume_off,
                  color: isAthanEnabled ? goldColor : Colors.grey.shade600, // لون أيقونة الصوت
                ),
                onPressed: () {
                  setState(() {
                    isAthanEnabled = !isAthanEnabled;
                  });

                  if (isAthanEnabled) {
                    NotificationService.schedulePrayer(
                      id: widget.id,
                      prayerName: widget.title,
                      time: widget.dateTime,
                    );
                  } else {
                    NotificationService.cancelPrayer(widget.id);
                  }

                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: bgColor, // لون التنبيه متناسق
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: goldColor, width: 1),
                      ),
                      content: Text(
                        isAthanEnabled ? 'تم تفعيل الأذان لصلاة ${widget.title}' : 'تم كتم الأذان لصلاة ${widget.title}',
                        style: const TextStyle(color: Colors.white, fontFamily: 'Uthmanic', fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}