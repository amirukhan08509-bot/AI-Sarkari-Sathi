import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'scheme_detail_screen.dart';

class SchemeSearchScreen extends StatefulWidget {
  final String query;

  const SchemeSearchScreen({
    super.key,
    required this.query,
  });

  @override
  State<SchemeSearchScreen> createState() => _SchemeSearchScreenState();
}

class _SchemeSearchScreenState extends State<SchemeSearchScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<Map<String, dynamic>> results = [];

  static const String schemesUrl =
      'https://raw.githubusercontent.com/amirukhan08509-bot/sarkari-schemes/main/schemes.json';

  @override
  void initState() {
    super.initState();
    searchSchemes();
  }

  Future<void> searchSchemes() async {
    try {
      final response = await http.get(Uri.parse(schemesUrl));

      if (response.statusCode != 200) {
        throw Exception('Data load nahi hua');
      }

      final List<dynamic> data = jsonDecode(response.body);

      final query = widget.query.trim().toLowerCase();

      final filtered = data.where((item) {
        final map = item as Map<String, dynamic>;

        final title =
        (map['title'] ?? '').toString().toLowerCase();

        final description =
        (map['description'] ?? '').toString().toLowerCase();

        final category =
        (map['category'] ?? '').toString().toLowerCase();

        final amount =
        (map['amount'] ?? '').toString().toLowerCase();

        final eligibility =
        (map['eligibility'] ?? '').toString().toLowerCase();

        return title.contains(query) ||
            description.contains(query) ||
            category.contains(query) ||
            amount.contains(query) ||
            eligibility.contains(query);
      }).map<Map<String, dynamic>>((item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList();

      if (!mounted) return;

      setState(() {
        results = filtered;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'योजनाएँ खोजने में समस्या हुई';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xff065F46),
        foregroundColor: Colors.white,
        title: Text(
          '"${widget.query}" के परिणाम',
        ),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: const TextStyle(fontSize: 17),
        ),
      )
          : results.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off,
                size: 70,
                color: Colors.grey,
              ),

              const SizedBox(height: 15),

              Text(
                '"${widget.query}" से जुड़ी कोई योजना नहीं मिली।',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'दूसरे शब्द से खोजने की कोशिश करें।',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final scheme = results[index];

          final title =
              scheme['title']?.toString() ?? '';

          final description =
              scheme['description']?.toString() ?? '';

          final amount =
              scheme['amount']?.toString() ?? '';

          final category =
              scheme['category']?.toString() ?? '';

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SchemeDetailScreen(
                      title: title,
                      description: description,
                      eligibility:
                      scheme['eligibility']?.toString(),
                      documents:
                      scheme['documents']?.toString(),
                      officialWebsite:
                      scheme['officialWebsite']?.toString(),
                      helpline:
                      scheme['helpline']?.toString(),
                    ),
                  ),
                );
              },

              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xffDCFCE7),
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Color(0xff065F46),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          if (category.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            Text(
                              category,
                              style: const TextStyle(
                                color: Color(0xff16A34A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],

                          const SizedBox(height: 8),

                          Text(
                            description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),

                          if (amount.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              amount,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff065F46),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}