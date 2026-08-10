import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../prayer_times/presentation/prayer_screen.dart';
import '../../quran/presentation/quran_screen.dart';
import '../../adhkar/presentation/adhkar_screen.dart';
import '../../tools/presentation/tools_screen.dart';
import '../../tasbih/presentation/tasbih_screen.dart';
import '../../qibla/presentation/qibla_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final Color bgColor = const Color(0xFF0D1818);
  final Color cardColor = const Color(0xFF162224);
  final Color goldColor = const Color(0xFFD4AF37);

  String _currentLocation = "جاري تحديد الموقع...";
  String _currentHijriDate = "...";
  String _nextPrayerName = "...";
  
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  Duration _timeUntilNextPrayer = Duration.zero;

  PrayerTimes? _prayerTimes;
  Position? _position;
  CalculationParameters? _calculationParameters;

  @override
  void initState() {
    super.initState();
    HijriCalendar.setLocal('ar');
    _currentHijriDate = _getFormattedHijriDate();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeAndCountdown();
    });

    _fetchLocationAndPrayerTimes();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getFormattedHijriDate() {
    HijriCalendar today = HijriCalendar.now();
    return "${today.dayWeName} ${today.hDay} ${today.longMonthName} ${today.hYear} هـ";
  }

  void _updateTimeAndCountdown() {
    setState(() {
      _currentTime = DateTime.now();
    });

    if (_prayerTimes == null || _position == null) return;

    DateTime now = DateTime.now();
    Prayer next = _prayerTimes!.nextPrayer();
    DateTime? nextTime;

    if (next == Prayer.none) {
      Coordinates coords = Coordinates(_position!.latitude, _position!.longitude);
      PrayerTimes tomorrowPT = PrayerTimes(
        coords,
        DateComponents.from(now.add(const Duration(days: 1))),
        _calculationParameters!,
      );
      next = Prayer.fajr;
      nextTime = tomorrowPT.fajr;
    } else {
      nextTime = _prayerTimes!.timeForPrayer(next);
    }

    if (nextTime != null) {
      setState(() {
        _nextPrayerName = _getPrayerNameInArabic(next);
        _timeUntilNextPrayer = nextTime!.difference(now);
      });
    }
  }

  String _getPrayerNameInArabic(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return "الفجر";
      case Prayer.sunrise: return "الشروق";
      case Prayer.dhuhr: return "الظهر";
      case Prayer.asr: return "العصر";
      case Prayer.maghrib: return "المغرب";
      case Prayer.isha: return "العشاء";
      case Prayer.none: return "";
    }
  }
Future<void> _fetchLocationAndPrayerTimes() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _currentLocation = "يرجى تفعيل الـ GPS");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _currentLocation = "تم رفض الصلاحية");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _currentLocation = "الصلاحية مرفوضة نهائياً");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
    String countryName = ""; 
    try {
      if (kIsWeb) {
        final url = Uri.parse('https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${position.latitude}&longitude=${position.longitude}&localityLanguage=ar');
        final response = await http.get(url);
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _currentLocation = data['city'] ?? data['locality'] ?? data['principalSubdivision'] ?? "موقع غير معروف";
            countryName = data['countryName'] ?? "";
          });
        } else {
          setState(() => _currentLocation = "تعذر تحديد المدينة (الويب)");
        }
      } else {
        // 📱 الطريقة الآمنة لاستخراج اسم المدينة في الإصدارات الحديثة
        try {
          List<Location> locations = []; // توافق إضافي إذا لزم
          var placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            setState(() {
              _currentLocation = placemarks.first.locality ?? placemarks.first.country ?? "موقع غير معروف";
              countryName = placemarks.first.country ?? "";
            });
          }
        } catch (_) {
          setState(() => _currentLocation = "موقع غير معروف");
        }
      }
    } catch (e) {
      setState(() => _currentLocation = "تعذر تحديد المدينة");
    }

    final coordinates = Coordinates(position.latitude, position.longitude);
    
    CalculationParameters params;
    if (countryName.contains("Egypt") || countryName.contains("مصر")) {
      params = CalculationMethod.egyptian.getParameters();
    } else if (countryName.contains("Saudi") || countryName.contains("السعودية")) {
      params = CalculationMethod.umm_al_qura.getParameters();
    } else if (countryName.contains("UAE") || countryName.contains("الإمارات")) {
      params = CalculationMethod.dubai.getParameters();
    } else if (countryName.contains("Kuwait") || countryName.contains("الكويت")) {
      params = CalculationMethod.kuwait.getParameters();
    } else if (countryName.contains("Qatar") || countryName.contains("قطر")) {
      params = CalculationMethod.qatar.getParameters();
    } else if (countryName.contains("Turkey") || countryName.contains("تركيا")) {
      params = CalculationMethod.turkey.getParameters();
    } else {
      params = CalculationMethod.muslim_world_league.getParameters();
    }
    
    params.madhab = Madhab.shafi;

    setState(() {
      _position = position;
      _calculationParameters = params;
      _prayerTimes = PrayerTimes.today(coordinates, params);
    });

    _updateTimeAndCountdown();
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    String period = hour >= 12 ? "م" : "ص";
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return "00:00:00";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: goldColor.withValues(alpha: 0.5)),
        ),
        title: Text(
          'عن تطبيق سُنّة',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Uthmanic', color: goldColor, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'تطبيق إسلامي شامل ومجاني، تم تطويره بعناية ليكون رفيقك اليومي.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: goldColor.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'اللهم إني أستودعك أبي الدكتور شعلان وأمي أم يوسف، فاحفظهم بحفظك، وألبسهم ثوب الصحة والعافية، وطول في أعمارهم على طاعتك، واجعل هذا التطبيق في ميزان حسناتهم وحسنات كل من ساهم فيه أو دعا لهم.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontFamily: 'Uthmanic',
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'إعداد وتطوير:\nالمهندس عمر شعلان عبد العزيز',
                textAlign: TextAlign.center,
                style: TextStyle(color: goldColor, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Uthmanic'),
              ),
              const SizedBox(height: 10),
              Text(
                'جميع الحقوق محفوظة © 2026',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: goldColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/mosque_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.black.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          _currentLocation,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentHijriDate,
                      style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      _formatTime(_currentTime),
                      style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, height: 1.0),
                    ),
                    Text(
                      _nextPrayerName,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '- ${_formatDuration(_timeUntilNextPrayer)} المتبقي للأذان',
                      style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _buildGridItem(Icons.access_time_filled, 'أوقات الصلاة', 'مواقيت دقيقة', tabIndex: 3),
                _buildGridItem(Icons.menu_book_rounded, 'القرآن الكريم', 'اقرأ وتدبر', tabIndex: 1),
                _buildGridItem(Icons.front_hand, 'الأذكار والأدعية', 'أذكارك اليومية', tabIndex: 2),
                _buildGridItem(Icons.circle_outlined, 'المسبحة', 'سبّح أينما كنت', pushScreen: const TasbihScreen()),
                _buildGridItem(Icons.bookmark, 'المفضلة', 'حفظ ما تحب', pushScreen: null),
                _buildGridItem(Icons.explore, 'القبلة', 'اعرف اتجاه القبلة', pushScreen: const QiblaScreen()),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String title, String subtitle, {int? tabIndex, Widget? pushScreen}) {
    return GestureDetector(
      onTap: () {
        if (tabIndex != null) {
          setState(() => _currentIndex = tabIndex);
        } else if (pushScreen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => pushScreen));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('شاشة $title قيد التطوير'), backgroundColor: goldColor),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: goldColor),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeScreen(), 
      const QuranScreen(), 
      const AdhkarScreen(), 
      const PrayerScreen(), 
      const ToolsScreen(), 
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'حول التطبيق',
            onPressed: () => _showAboutDialog(context),
          ),
          title: Text(
            'سُنّة',
            style: TextStyle(fontFamily: 'Uthmanic', fontSize: 32, fontWeight: FontWeight.bold, color: goldColor),
          ),
          centerTitle: true,
        ),
        body: screens[_currentIndex],
        bottomNavigationBar: Theme(
          data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
          child: BottomNavigationBar(
            backgroundColor: bgColor,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: goldColor,
            unselectedItemColor: Colors.grey.shade600,
            showUnselectedLabels: true,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            elevation: 0,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'الرئيسية'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'القرآن'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'أذكار'),
              BottomNavigationBarItem(icon: Icon(Icons.access_time_filled), label: 'مواقيت'),
              BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'المزيد'),
            ],
          ),
        ),
      ),
    );
  }
}