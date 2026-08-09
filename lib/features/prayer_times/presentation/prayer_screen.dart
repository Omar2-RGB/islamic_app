import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';

// هنا قمنا بإخفاء TextDirection الخاص بمكتبة intl لكي لا يتعارض مع فلاتر
import 'package:intl/intl.dart' hide TextDirection; 

import 'prayer_provider.dart';
import '../../../core/services/notification_service.dart';
class PrayerScreen extends ConsumerWidget {
  const PrayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimesAsyncValue = ref.watch(prayerTimesProvider);

    return Scaffold(
      body: prayerTimesAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('حدث خطأ: $error')),
        data: (prayerTimes) {
          if (prayerTimes == null) {
            return const Center(child: Text('يرجى تفعيل الموقع لمعرفة أوقات الصلاة.'));
          }

          String formatTime(DateTime time) {
            return DateFormat('hh:mm a').format(time);
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // العداد التنازلي للصلاة القادمة
              _NextPrayerCountdown(prayerTimes: prayerTimes),
              const SizedBox(height: 20),

              const Text(
                'أوقات الصلاة',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              _PrayerTile(id: 1, title: 'الفجر', timeString: formatTime(prayerTimes.fajr), dateTime: prayerTimes.fajr),
              _PrayerTile(id: 2, title: 'الشروق', timeString: formatTime(prayerTimes.sunrise), dateTime: prayerTimes.sunrise),
              _PrayerTile(id: 3, title: 'الظهر', timeString: formatTime(prayerTimes.dhuhr), dateTime: prayerTimes.dhuhr),
              _PrayerTile(id: 4, title: 'العصر', timeString: formatTime(prayerTimes.asr), dateTime: prayerTimes.asr),
              _PrayerTile(id: 5, title: 'المغرب', timeString: formatTime(prayerTimes.maghrib), dateTime: prayerTimes.maghrib),
              _PrayerTile(id: 6, title: 'العشاء', timeString: formatTime(prayerTimes.isha), dateTime: prayerTimes.isha),
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
      color: Colors.teal.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.teal.shade200, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              'الوقت المتبقي لصلاة $_nextPrayerName',
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _formatDuration(_timeRemaining),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                letterSpacing: 2.0, // تباعد بين الأرقام لتبدو كالساعة الرقمية
              ),
              textDirection: TextDirection.ltr, // لإجبار الأرقام على البقاء من اليسار لليمين
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// ويدجت تصميم سطر الصلاة مع زر الأذان (لم تتغير)
// ---------------------------------------------------------
class _PrayerTile extends StatefulWidget {
  final int id;
  final String title;
  final String timeString;
  final DateTime dateTime;

  const _PrayerTile({
    required this.id,
    required this.title,
    required this.timeString,
    required this.dateTime,
  });

  @override
  State<_PrayerTile> createState() => _PrayerTileState();
}

class _PrayerTileState extends State<_PrayerTile> {
  bool isAthanEnabled = true;

  @override
  void initState() {
    super.initState();
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(widget.timeString, style: const TextStyle(fontSize: 16, color: Colors.teal, fontWeight: FontWeight.w600)),
        trailing: IconButton(
          iconSize: 28,
          icon: Icon(
            isAthanEnabled ? Icons.volume_up : Icons.volume_off,
            color: isAthanEnabled ? Colors.teal : Colors.grey,
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
                content: Text(isAthanEnabled ? 'تم تفعيل الأذان لصلاة ${widget.title}' : 'تم كتم الأذان لصلاة ${widget.title}'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }
}