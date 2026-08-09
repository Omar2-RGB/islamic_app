import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class NamesScreen extends StatefulWidget {
  const NamesScreen({super.key});

  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {
  List<dynamic> _names = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    try {
      final String response = await rootBundle.loadString('assets/json/names.json');
      final decodedData = json.decode(response);
      
      setState(() {
        // يدعم سواء كان الملف مصفوفة مباشرة أو كائن يحتوي على مفتاح data
        if (decodedData is Map && decodedData.containsKey('data')) {
          _names = decodedData['data'];
        } else if (decodedData is List) {
          _names = decodedData;
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("خطأ في التحميل: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('أسماء الله الحسنى', style: TextStyle(fontFamily: 'Uthmanic', color: Colors.teal)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : _names.isEmpty
              ? const Center(child: Text('لا توجد بيانات متاحة'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _names.length,
                  itemBuilder: (context, index) {
                    final item = _names[index];
                    
                    // استخراج المعنى بأمان تامة لتجنب الـ null
                    String meaningText = '';
                    if (item['en'] != null && item['en']['meaning'] != null) {
                      meaningText = item['en']['meaning'];
                    } else if (item['meaning'] != null) {
                      meaningText = item['meaning'];
                    }

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${item['number'] ?? (index + 1)}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['name'] ?? '',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Uthmanic', color: Colors.teal),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meaningText,
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}