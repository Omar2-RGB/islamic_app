import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'surah_reading_screen.dart';

// قائمة السور الـ 114 كاملة
final List<Map<String, dynamic>> _quranIndex = [
  {"id": 1, "name": "الفاتحة", "englishName": "Al-Fatihah", "type": "مكية", "ayahs": 7},
  {"id": 2, "name": "البقرة", "englishName": "Al-Baqarah", "type": "مدنية", "ayahs": 286},
  {"id": 3, "name": "آل عمران", "englishName": "Aal-Imran", "type": "مدنية", "ayahs": 200},
  {"id": 4, "name": "النساء", "englishName": "An-Nisa", "type": "مدنية", "ayahs": 176},
  {"id": 5, "name": "المائدة", "englishName": "Al-Ma'idah", "type": "مدنية", "ayahs": 120},
  {"id": 6, "name": "الأنعام", "englishName": "Al-An'am", "type": "مكية", "ayahs": 165},
  {"id": 7, "name": "الأعراف", "englishName": "Al-A'raf", "type": "مكية", "ayahs": 206},
  {"id": 8, "name": "الأنفال", "englishName": "Al-Anfal", "type": "مدنية", "ayahs": 75},
  {"id": 9, "name": "التوبة", "englishName": "At-Tawbah", "type": "مدنية", "ayahs": 129},
  {"id": 10, "name": "يونس", "englishName": "Yunus", "type": "مكية", "ayahs": 109},
  {"id": 11, "name": "هود", "englishName": "Hud", "type": "مكية", "ayahs": 123},
  {"id": 12, "name": "يوسف", "englishName": "Yusuf", "type": "مكية", "ayahs": 111},
  {"id": 13, "name": "الرعد", "englishName": "Ar-Ra'd", "type": "مدنية", "ayahs": 43},
  {"id": 14, "name": "إبراهيم", "englishName": "Ibrahim", "type": "مكية", "ayahs": 52},
  {"id": 15, "name": "الحجر", "englishName": "Al-Hijr", "type": "مكية", "ayahs": 99},
  {"id": 16, "name": "النحل", "englishName": "An-Nahl", "type": "مكية", "ayahs": 128},
  {"id": 17, "name": "الإسراء", "englishName": "Al-Isra", "type": "مكية", "ayahs": 111},
  {"id": 18, "name": "الكهف", "englishName": "Al-Kahf", "type": "مكية", "ayahs": 110},
  {"id": 19, "name": "مريم", "englishName": "Maryam", "type": "مكية", "ayahs": 98},
  {"id": 20, "name": "طه", "englishName": "Taha", "type": "مكية", "ayahs": 135},
  {"id": 21, "name": "الأنبياء", "englishName": "Al-Anbiya", "type": "مكية", "ayahs": 112},
  {"id": 22, "name": "الحج", "englishName": "Al-Hajj", "type": "مدنية", "ayahs": 78},
  {"id": 23, "name": "المؤمنون", "englishName": "Al-Mu'minun", "type": "مكية", "ayahs": 118},
  {"id": 24, "name": "النور", "englishName": "An-Nur", "type": "مدنية", "ayahs": 64},
  {"id": 25, "name": "الفرقان", "englishName": "Al-Furqan", "type": "مكية", "ayahs": 77},
  {"id": 26, "name": "الشعراء", "englishName": "Ash-Shu'ara", "type": "مكية", "ayahs": 227},
  {"id": 27, "name": "النمل", "englishName": "An-Naml", "type": "مكية", "ayahs": 93},
  {"id": 28, "name": "القصص", "englishName": "Al-Qasas", "type": "مكية", "ayahs": 88},
  {"id": 29, "name": "العنكبوت", "englishName": "Al-'Ankabut", "type": "مكية", "ayahs": 69},
  {"id": 30, "name": "الروم", "englishName": "Ar-Rum", "type": "مكية", "ayahs": 60},
  {"id": 31, "name": "لقمان", "englishName": "Luqman", "type": "مكية", "ayahs": 34},
  {"id": 32, "name": "السجدة", "englishName": "As-Sajdah", "type": "مكية", "ayahs": 30},
  {"id": 33, "name": "الأحزاب", "englishName": "Al-Ahzab", "type": "مدنية", "ayahs": 73},
  {"id": 34, "name": "سبأ", "englishName": "Saba", "type": "مكية", "ayahs": 54},
  {"id": 35, "name": "فاطر", "englishName": "Fatir", "type": "مكية", "ayahs": 45},
  {"id": 36, "name": "يس", "englishName": "Ya-Sin", "type": "مكية", "ayahs": 83},
  {"id": 37, "name": "الصافات", "englishName": "As-Saffat", "type": "مكية", "ayahs": 182},
  {"id": 38, "name": "ص", "englishName": "Sad", "type": "مكية", "ayahs": 88},
  {"id": 39, "name": "الزمر", "englishName": "Az-Zumar", "type": "مكية", "ayahs": 75},
  {"id": 40, "name": "غافر", "englishName": "Ghafir", "type": "مكية", "ayahs": 85},
  {"id": 41, "name": "فصلت", "englishName": "Fussilat", "type": "مكية", "ayahs": 54},
  {"id": 42, "name": "الشورى", "englishName": "Ash-Shura", "type": "مكية", "ayahs": 53},
  {"id": 43, "name": "الزخرف", "englishName": "Az-Zukhruf", "type": "مكية", "ayahs": 89},
  {"id": 44, "name": "الدخان", "englishName": "Ad-Dukhan", "type": "مكية", "ayahs": 59},
  {"id": 45, "name": "الجاثية", "englishName": "Al-Jathiyah", "type": "مكية", "ayahs": 37},
  {"id": 46, "name": "الأحقاف", "englishName": "Al-Ahqaf", "type": "مكية", "ayahs": 35},
  {"id": 47, "name": "محمد", "englishName": "Muhammad", "type": "مدنية", "ayahs": 38},
  {"id": 48, "name": "الفتح", "englishName": "Al-Fath", "type": "مدنية", "ayahs": 29},
  {"id": 49, "name": "الحجرات", "englishName": "Al-Hujurat", "type": "مدنية", "ayahs": 18},
  {"id": 50, "name": "ق", "englishName": "Qaf", "type": "مكية", "ayahs": 45},
  {"id": 51, "name": "الذاريات", "englishName": "Adh-Dhariyat", "type": "مكية", "ayahs": 60},
  {"id": 52, "name": "الطور", "englishName": "At-Tur", "type": "مكية", "ayahs": 49},
  {"id": 53, "name": "النجم", "englishName": "An-Najm", "type": "مكية", "ayahs": 62},
  {"id": 54, "name": "القمر", "englishName": "Al-Qamar", "type": "مكية", "ayahs": 55},
  {"id": 55, "name": "الرحمن", "englishName": "Ar-Rahman", "type": "مدنية", "ayahs": 78},
  {"id": 56, "name": "الواقعة", "englishName": "Al-Waqi'ah", "type": "مكية", "ayahs": 96},
  {"id": 57, "name": "الحديد", "englishName": "Al-Hadid", "type": "مدنية", "ayahs": 29},
  {"id": 58, "name": "المجادلة", "englishName": "Al-Mujadila", "type": "مدنية", "ayahs": 22},
  {"id": 59, "name": "الحشر", "englishName": "Al-Hashr", "type": "مدنية", "ayahs": 24},
  {"id": 60, "name": "الممتحنة", "englishName": "Al-Mumtahanah", "type": "مدنية", "ayahs": 13},
  {"id": 61, "name": "الصف", "englishName": "As-Saff", "type": "مدنية", "ayahs": 14},
  {"id": 62, "name": "الجمعة", "englishName": "Al-Jumu'ah", "type": "مدنية", "ayahs": 11},
  {"id": 63, "name": "المنافقون", "englishName": "Al-Munafiqun", "type": "مدنية", "ayahs": 11},
  {"id": 64, "name": "التغابن", "englishName": "At-Taghabun", "type": "مدنية", "ayahs": 18},
  {"id": 65, "name": "الطلاق", "englishName": "At-Talaq", "type": "مدنية", "ayahs": 12},
  {"id": 66, "name": "التحريم", "englishName": "At-Tahrim", "type": "مدنية", "ayahs": 12},
  {"id": 67, "name": "الملك", "englishName": "Al-Mulk", "type": "مكية", "ayahs": 30},
  {"id": 68, "name": "القلم", "englishName": "Al-Qalam", "type": "مكية", "ayahs": 52},
  {"id": 69, "name": "الحاقة", "englishName": "Al-Haqqah", "type": "مكية", "ayahs": 52},
  {"id": 70, "name": "المعارج", "englishName": "Al-Ma'arij", "type": "مكية", "ayahs": 44},
  {"id": 71, "name": "نوح", "englishName": "Nuh", "type": "مكية", "ayahs": 28},
  {"id": 72, "name": "الجن", "englishName": "Al-Jinn", "type": "مكية", "ayahs": 28},
  {"id": 73, "name": "المزمل", "englishName": "Al-Muzzammil", "type": "مكية", "ayahs": 20},
  {"id": 74, "name": "المدثر", "englishName": "Al-Muddaththir", "type": "مكية", "ayahs": 56},
  {"id": 75, "name": "القيامة", "englishName": "Al-Qiyamah", "type": "مكية", "ayahs": 40},
  {"id": 76, "name": "الإنسان", "englishName": "Al-Insan", "type": "مدنية", "ayahs": 31},
  {"id": 77, "name": "المرسلات", "englishName": "Al-Mursalat", "type": "مكية", "ayahs": 50},
  {"id": 78, "name": "النبأ", "englishName": "An-Naba", "type": "مكية", "ayahs": 40},
  {"id": 79, "name": "النازعات", "englishName": "An-Nazi'at", "type": "مكية", "ayahs": 46},
  {"id": 80, "name": "عبس", "englishName": "'Abasa", "type": "مكية", "ayahs": 42},
  {"id": 81, "name": "التكوير", "englishName": "At-Takwir", "type": "مكية", "ayahs": 29},
  {"id": 82, "name": "الانفطار", "englishName": "Al-Infitar", "type": "مكية", "ayahs": 19},
  {"id": 83, "name": "المطففين", "englishName": "Al-Mutaffifin", "type": "مكية", "ayahs": 36},
  {"id": 84, "name": "الانشقاق", "englishName": "Al-Inshiqaq", "type": "مكية", "ayahs": 25},
  {"id": 85, "name": "البروج", "englishName": "Al-Buruj", "type": "مكية", "ayahs": 22},
  {"id": 86, "name": "الطارق", "englishName": "At-Tariq", "type": "مكية", "ayahs": 17},
  {"id": 87, "name": "الأعلى", "englishName": "Al-A'la", "type": "مكية", "ayahs": 19},
  {"id": 88, "name": "الغاشية", "englishName": "Al-Ghashiyah", "type": "مكية", "ayahs": 26},
  {"id": 89, "name": "الفجر", "englishName": "Al-Fajr", "type": "مكية", "ayahs": 30},
  {"id": 90, "name": "البلد", "englishName": "Al-Balad", "type": "مكية", "ayahs": 20},
  {"id": 91, "name": "الشمس", "englishName": "Ash-Shams", "type": "مكية", "ayahs": 15},
  {"id": 92, "name": "الليل", "englishName": "Al-Layl", "type": "مكية", "ayahs": 21},
  {"id": 93, "name": "الضحى", "englishName": "Ad-Duhaa", "type": "مكية", "ayahs": 11},
  {"id": 94, "name": "الشرح", "englishName": "Ash-Sharh", "type": "مكية", "ayahs": 8},
  {"id": 95, "name": "التين", "englishName": "At-Tin", "type": "مكية", "ayahs": 8},
  {"id": 96, "name": "العلق", "englishName": "Al-'Alaq", "type": "مكية", "ayahs": 19},
  {"id": 97, "name": "القدر", "englishName": "Al-Qadr", "type": "مكية", "ayahs": 5},
  {"id": 98, "name": "البينة", "englishName": "Al-Bayyinah", "type": "مدنية", "ayahs": 8},
  {"id": 99, "name": "الزلزلة", "englishName": "Az-Zalzalah", "type": "مدنية", "ayahs": 8},
  {"id": 100, "name": "العاديات", "englishName": "Al-'Adiyat", "type": "مكية", "ayahs": 11},
  {"id": 101, "name": "القارعة", "englishName": "Al-Qari'ah", "type": "مكية", "ayahs": 11},
  {"id": 102, "name": "التكاثر", "englishName": "At-Takathur", "type": "مكية", "ayahs": 8},
  {"id": 103, "name": "العصر", "englishName": "Al-'Asr", "type": "مكية", "ayahs": 3},
  {"id": 104, "name": "الهمزة", "englishName": "Al-Humazah", "type": "مكية", "ayahs": 9},
  {"id": 105, "name": "الفيل", "englishName": "Al-Fil", "type": "مكية", "ayahs": 5},
  {"id": 106, "name": "قريش", "englishName": "Quraysh", "type": "مكية", "ayahs": 4},
  {"id": 107, "name": "الماعون", "englishName": "Al-Ma'un", "type": "مكية", "ayahs": 7},
  {"id": 108, "name": "الكوثر", "englishName": "Al-Kawthar", "type": "مكية", "ayahs": 3},
  {"id": 109, "name": "الكافرون", "englishName": "Al-Kafirun", "type": "مكية", "ayahs": 6},
  {"id": 110, "name": "النصر", "englishName": "An-Nasr", "type": "مدنية", "ayahs": 3},
  {"id": 111, "name": "المسد", "englishName": "Al-Masad", "type": "مكية", "ayahs": 5},
  {"id": 112, "name": "الإخلاص", "englishName": "Al-Ikhlas", "type": "مكية", "ayahs": 4},
  {"id": 113, "name": "الفلق", "englishName": "Al-Falaq", "type": "مكية", "ayahs": 5},
  {"id": 114, "name": "الناس", "englishName": "An-Nas", "type": "مكية", "ayahs": 6},
];

class QuranScreen extends ConsumerStatefulWidget {
  const QuranScreen({super.key});

  @override
  ConsumerState<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends ConsumerState<QuranScreen> {
  List<Map<String, dynamic>> _filteredSurahs = _quranIndex;

  // الألوان الداكنة الثابتة
  final Color bgColor = const Color(0xFF0D1818);
  final Color cardColor = const Color(0xFF162224);
  final Color goldColor = const Color(0xFFD4AF37);

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _quranIndex;
    } else {
      results = _quranIndex
          .where((s) => s['name'].contains(enteredKeyword) || s['englishName'].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() => _filteredSurahs = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('فهرس القرآن الكريم', style: TextStyle(fontWeight: FontWeight.bold, color: goldColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white), // لون النص أثناء الكتابة
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: goldColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: cardColor, // لون خلفية حقل البحث
              ),
            ),
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: _filteredSurahs.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.white.withOpacity(0.05)), // خط فاصل خفيف جداً
        itemBuilder: (context, index) {
          final surah = _filteredSurahs[index];
          return _SurahTile(surah: surah);
        },
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  final Map<String, dynamic> surah;

  const _SurahTile({required this.surah});

  @override
  Widget build(BuildContext context) {
    final Color cardColor = const Color(0xFF162224);
    final Color goldColor = const Color(0xFFD4AF37);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahReadingScreen(surahInfo: surah),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cardColor, // لون الدائرة الداكن
                shape: BoxShape.circle,
                border: Border.all(color: goldColor, width: 1.5), // إطار ذهبي للدائرة
              ),
              alignment: Alignment.center,
              child: Text(
                '${surah['id']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: goldColor), // الرقم بالذهبي
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah['englishName'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // النص باللون الأبيض
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${surah['type']} • ${surah['ayahs']} آية',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            Text(
              surah['name'],
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Uthmanic',
                color: goldColor, // اسم السورة بالعربي باللون الذهبي
              ),
            ),
          ],
        ),
      ),
    );
  }
}