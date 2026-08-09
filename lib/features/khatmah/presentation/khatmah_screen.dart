import 'package:flutter/material.dart';

class KhatmahScreen extends StatefulWidget {
  const KhatmahScreen({super.key});

  @override
  State<KhatmahScreen> createState() => _KhatmahScreenState();
}

class _KhatmahScreenState extends State<KhatmahScreen> {
  int _days = 30; // عدد أيام الختمة الافتراضي
  int _completedPages = 0; // الصفحات المنجزة حالياً

  @override
  Widget build(BuildContext context) {
    int totalPages = 604;
    int pagesPerDay = (totalPages / _days).ceil();
    
    // حساب نسبة الإنجاز (مئوية من 0.0 إلى 1.0)
    double progress = (_completedPages / totalPages).clamp(0.0, 1.0);
    int percentage = (progress * 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('مخطط الختمة', style: TextStyle(fontFamily: 'Uthmanic', color: Colors.teal)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'اختر مدة ختمة القرآن الكريم:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Uthmanic'),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDayChip(10),
                _buildDayChip(15),
                _buildDayChip(30),
                _buildDayChip(60),
              ],
            ),
            const SizedBox(height: 30),

            // بطاقة الملخص والورد اليومي
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('وردك اليومي المطلوب:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text(
                      '$pagesPerDay صفحة',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'تقريباً ${(pagesPerDay / 20).toStringAsFixed(1)} جزء يومياً لختم القرآن في $_days يوماً.',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(height: 30),

                    // شريط التقدم (Progress Bar)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('نسبة الإنجاز الكلية:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('$percentage%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.teal.shade50,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'تم قراءة $_completedPages من $totalPages صفحة',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // زر إتمام الورد اليومي
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (_completedPages + pagesPerDay <= totalPages) {
                      _completedPages += pagesPerDay;
                    } else {
                      _completedPages = totalPages; // اكتمال الختمة
                    }
                  });
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: Text(
                  'أتممت وردي اليوم (+$pagesPerDay صفحة)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Uthmanic'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // زر إعادة ضبط الختمة
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _completedPages = 0;
                });
              },
              icon: const Icon(Icons.refresh, color: Colors.red),
              label: const Text('إعادة بدء الختمة', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayChip(int days) {
    bool isSelected = _days == days;
    return ChoiceChip(
      label: Text('$days أيام'),
      selected: isSelected,
      selectedColor: Colors.teal.shade200,
      onSelected: (bool selected) {
        setState(() {
          _days = days;
          // إعادة تعيين الصفحات المنجزة اختيارياً أو إبقاءها حسب الرغبة، هنا نتركها أو نصفرها
        });
      },
    );
  }
}