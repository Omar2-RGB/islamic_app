import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'practice_screen.dart';
class KhatmahScreen extends StatefulWidget {
  const KhatmahScreen({super.key});

  @override
  State<KhatmahScreen> createState() => _KhatmahScreenState();
}

class _KhatmahScreenState extends State<KhatmahScreen> {
  // الألوان الداكنة الثابتة للتطبيق
  final Color bgColor = const Color(0xFF0D1818);
  final Color cardColor = const Color(0xFF162224);
  final Color goldColor = const Color(0xFFD4AF37);

  // متغيرات الخطة والإنجاز
  late Box _khatmahBox;
  int _days = 30;
  int _completedPages = 0;
  int _memorizedPages = 0;
  final int totalPages = 604;

  @override
  void initState() {
    super.initState();
    _khatmahBox = Hive.box('khatmahBox');
    _loadSavedData();
  }

  // دالة لجلب البيانات من قاعدة البيانات عند فتح الشاشة
  void _loadSavedData() {
    setState(() {
      _days = _khatmahBox.get('days', defaultValue: 30);
      _completedPages = _khatmahBox.get('completedPages', defaultValue: 0);
      _memorizedPages = _khatmahBox.get('memorizedPages', defaultValue: 0);
    });
  }

  // دوال لتحديث البيانات وحفظها فوراً في Hive
  void _updateDays(int days) {
    setState(() => _days = days);
    _khatmahBox.put('days', days);
  }

  void _addCompletedPages(int pages) {
    setState(() {
      if (_completedPages + pages <= totalPages) {
        _completedPages += pages;
      } else {
        _completedPages = totalPages;
      }
    });
    _khatmahBox.put('completedPages', _completedPages);
  }

  void _resetKhatmah() {
    setState(() => _completedPages = 0);
    _khatmahBox.put('completedPages', 0);
  }

  void _incrementMemorized() {
    if (_memorizedPages < totalPages) {
      setState(() => _memorizedPages++);
      _khatmahBox.put('memorizedPages', _memorizedPages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text('مخطط القرآن الكريم', style: TextStyle(fontFamily: 'Uthmanic', color: goldColor, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: goldColor,
            labelColor: goldColor,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: const [
              Tab(text: 'الخطة والإنجاز', icon: Icon(Icons.track_changes)),
              Tab(text: 'الحفظ', icon: Icon(Icons.menu_book)),
              Tab(text: 'التسميع', icon: Icon(Icons.mic_none)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReadingPlanTab(), 
            _buildMemorizationTab(), 
            _buildRecitationTab(), 
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. تبويب الخطة والإنجاز
  // ==========================================
  Widget _buildReadingPlanTab() {
    int pagesPerDay = (totalPages / _days).ceil();
    double progress = (_completedPages / totalPages).clamp(0.0, 1.0);
    int percentage = (progress * 100).toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'اختر مدة الختمة:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Uthmanic', color: goldColor),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _buildDayChip(10),
              _buildDayChip(15),
              _buildDayChip(30),
              _buildDayChip(60),
            ],
          ),
          const SizedBox(height: 30),

          Card(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text('وردك اليومي المطلوب:', style: TextStyle(fontSize: 16, color: Colors.grey.shade400)),
                  const SizedBox(height: 10),
                  Text(
                    '$pagesPerDay صفحة',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: goldColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'تقريباً ${(pagesPerDay / 20).toStringAsFixed(1)} جزء يومياً لختم القرآن في $_days يوماً.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                  Divider(height: 40, color: Colors.white.withOpacity(0.1)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('نسبة الإنجاز:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('$percentage%', style: TextStyle(fontWeight: FontWeight.bold, color: goldColor)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: bgColor,
                      valueColor: AlwaysStoppedAnimation<Color>(goldColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'تم قراءة $_completedPages من $totalPages صفحة',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: () => _addCompletedPages(pagesPerDay),
              icon: const Icon(Icons.check_circle_outline, color: Color(0xFF0D1818)),
              label: Text(
                'أتممت وردي اليوم (+$pagesPerDay صفحة)',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D1818), fontFamily: 'Uthmanic'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: goldColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
          const SizedBox(height: 15),

          TextButton.icon(
            onPressed: _resetKhatmah,
            icon: const Icon(Icons.refresh, color: Colors.redAccent),
            label: const Text('إعادة بدء الختمة', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildDayChip(int days) {
    bool isSelected = _days == days;
    return ChoiceChip(
      label: Text('$days أيام', style: TextStyle(color: isSelected ? bgColor : Colors.white, fontWeight: FontWeight.bold)),
      selected: isSelected,
      selectedColor: goldColor,
      backgroundColor: cardColor,
      showCheckmark: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (bool selected) {
        if (selected) {
          _updateDays(days);
        }
      },
    );
  }

  // ==========================================
  // 2. تبويب الحفظ
  // ==========================================
  Widget _buildMemorizationTab() {
    double memProgress = (_memorizedPages / totalPages).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('مقدار الحفظ الكلي', style: TextStyle(fontSize: 18, color: goldColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: goldColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: CircularProgressIndicator(
                        value: memProgress,
                        strokeWidth: 10,
                        backgroundColor: bgColor,
                        valueColor: AlwaysStoppedAnimation<Color>(goldColor),
                      ),
                    ),
                    Text(
                      '${(memProgress * 100).toInt()}%\nمحفوظ',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('حفظت $_memorizedPages صفحة من أصل $totalPages', style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text('السورة الحالية:', style: TextStyle(fontSize: 18, color: goldColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListTile(
            tileColor: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            leading: CircleAvatar(backgroundColor: goldColor, child: Text('2', style: TextStyle(color: bgColor))),
            title: const Text('سورة البقرة', style: TextStyle(color: Colors.white, fontFamily: 'Uthmanic', fontSize: 20)),
            subtitle: Text('تم حفظ $_memorizedPages صفحة', style: TextStyle(color: Colors.grey.shade400)),
            trailing: IconButton(
              icon: Icon(Icons.add_circle, color: goldColor, size: 35),
              onPressed: _incrementMemorized,
            ),
          )
        ],
      ),
    );
  }

  // ==========================================
  // 3. تبويب التسميع (مع ميزة إخفاء الآيات تفاعلياً)
  // ==========================================
// استبدل دالة _buildRecitationTab القديمة بهذا الكود في ملف khatmah_screen.dart
Widget _buildRecitationTab() {
  List<dynamic> savedSurahs = _khatmahBox.get('savedSurahs', defaultValue: []);

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'سورك المحفوظة للمراجعة:',
          style: TextStyle(fontSize: 18, color: goldColor, fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(
        child: savedSurahs.isEmpty 
          ? Center(child: Text("لا توجد سور مضافة للمراجعة.\nاضغط على علامة المرجعية (Bookmark) في شاشة القرآن.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)))
          : ListView.builder(
              itemCount: savedSurahs.length,
              itemBuilder: (context, index) {
                final surah = savedSurahs[index];
                return ListTile(
                  title: Text(surah['name'], style: const TextStyle(color: Colors.white, fontSize: 18)),
                  trailing: Icon(Icons.arrow_back_ios, color: goldColor),
                  onTap: () {
                    // فتح شاشة التسميع الخاصة بهذه السورة
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => PracticeScreen(surahInfo: surah),
                    ));
                  },
                );
              },
            ),
      ),
    ],
  );
}}
// ---------------------------------------------------------
// ويدجت فرعية تفاعلية لإخفاء وإظهار الآيات (Active Recall)
// ---------------------------------------------------------
class AyahQuizCard extends StatefulWidget {
  final String ayahText;
  const AyahQuizCard({super.key, required this.ayahText});

  @override
  State<AyahQuizCard> createState() => _AyahQuizCardState();
}

class _AyahQuizCardState extends State<AyahQuizCard> {
  bool _isHidden = true; // تبدأ مخفية لاختبار الذاكرة

  @override
  Widget build(BuildContext context) {
    final cardColor = const Color(0xFF162224);
    final goldColor = const Color(0xFFD4AF37);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isHidden = !_isHidden; // عند النقر يتم التبديل بين الإخفاء والإظهار
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: goldColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              _isHidden ? "اضغط هنا لاختبار حفظ الآية (انقر لإظهارها)" : widget.ayahText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Uthmanic',
                color: _isHidden ? Colors.grey.shade500 : Colors.white,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isHidden ? Icons.visibility_off : Icons.visibility,
                  color: goldColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _isHidden ? "الآية مخفية" : "الآية ظاهرة",
                  style: TextStyle(color: goldColor, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}