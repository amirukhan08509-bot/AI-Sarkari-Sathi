import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/scheme_model.dart';
import '../services/github_service.dart';
import 'scheme_detail_screen.dart';

class SchemeResultScreen extends StatelessWidget {
  final String state;
  final String category;

  const SchemeResultScreen({
    super.key,
    required this.state,
    required this.category,
  });

  Future<List<SchemeModel>> loadSchemes() async {
    final data = await GitHubService.getSchemes();

    print("Selected Category: $category");

    return data
        .map((e) => SchemeModel.fromJson(e as Map<String, dynamic>))
        .where((scheme) {
      print("${scheme.title} -> ${scheme.category}");
      return scheme.matchesState(state) &&
          scheme.category == category;
    })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('आपके लिए योजनाएँ'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'राज्य: $state',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'श्रेणी: $category',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<SchemeModel>>(
                future: loadSchemes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'योजनाएँ लोड नहीं हो सकीं',
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    );
                  }

                  final schemes = snapshot.data ?? [];

                  if (schemes.isEmpty) {
                    return const Center(
                      child: Text(
                        'इस श्रेणी के लिए कोई योजना नहीं मिली',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: schemes.length,
                    itemBuilder: (context, index) {
                      final scheme = schemes[index];

                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SchemeDetailScreen(
                                  title: scheme.title,
                                  description: scheme.description,
                                  eligibility: scheme.eligibility,
                                  documents: scheme.documents,
                                  officialWebsite: scheme.officialWebsite,
                                  helpline: scheme.helpline,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.green.shade100,
                                      child: Icon(
                                        scheme.icon,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        scheme.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (scheme.popular)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'POPULAR',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  scheme.description,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.currency_rupee,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    Text(
                                      scheme.amount,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SchemeDetailScreen(
                                              title: scheme.title,
                                              description: scheme.description,
                                              eligibility: scheme.eligibility,
                                              documents: scheme.documents,
                                              officialWebsite: scheme.officialWebsite,
                                              helpline: scheme.helpline,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('देखें'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
