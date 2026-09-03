import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController districtController = TextEditingController();

  String? selectedState;
  String? selectedCategory;

  bool isLoading = true;
  bool isSaving = false;

  final List<String> states = [
    'राजस्थान',
    'उत्तर प्रदेश',
    'मध्य प्रदेश',
    'गुजरात',
    'महाराष्ट्र',
  ];

  final List<String> categories = [
    'किसान',
    'छात्र',
    'महिला',
    'वरिष्ठ नागरिक',
    'नौकरी तलाश',
    'व्यवसाय',
    'अन्य',
  ];

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      return;
    }

    try {
      final doc =
      await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data();

        if (data != null) {
          final savedState = data['state'] as String?;
          final savedCategory = data['category'] as String?;

          if (savedState != null && states.contains(savedState)) {
            selectedState = savedState;
          }

          if (savedCategory != null &&
              categories.contains(savedCategory)) {
            selectedCategory = savedCategory;
          }

          districtController.text =
              data['district'] as String? ?? '';
        }
      }
    } catch (e) {
      if (mounted) {
        showMessage('Profile load nahi ho saka');
      }
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveProfile() async {
    final user = _auth.currentUser;

    if (user == null) return;

    if (selectedState == null) {
      showMessage('राज्य चुनें');
      return;
    }

    if (districtController.text.trim().isEmpty) {
      showMessage('जिला दर्ज करें');
      return;
    }

    if (selectedCategory == null) {
      showMessage('श्रेणी चुनें');
      return;
    }

    setState(() => isSaving = true);

    try {
      await _firestore.collection('users').doc(user.uid).set(
        {
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'state': selectedState,
          'district': districtController.text.trim(),
          'category': selectedCategory,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (mounted) {
        showMessage('प्रोफ़ाइल सेव हो गई');
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        showMessage('Save error: ${e.message ?? e.code}');
      }
    } catch (e) {
      if (mounted) {
        showMessage('प्रोफ़ाइल सेव नहीं हो सकी');
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    final String name =
    user.displayName?.trim().isNotEmpty == true
        ? user.displayName!
        : 'उपयोगकर्ता';

    final String email = user.email ?? 'Email उपलब्ध नहीं';

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        title: const Text(
          'मेरा प्रोफ़ाइल',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xff065F46),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 15),

              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xff16A34A),
                child: Icon(
                  Icons.person,
                  size: 65,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                name,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                email,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedState,
                      decoration: const InputDecoration(
                        labelText: 'राज्य',
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Color(0xff065F46),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      items: states.map((state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedState = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: districtController,
                      decoration: const InputDecoration(
                        labelText: 'जिला',
                        hintText: 'जैसे: बीकानेर',
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Color(0xff065F46),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'श्रेणी / व्यवसाय',
                        prefixIcon: Icon(
                          Icons.work_outline,
                          color: Color(0xff065F46),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xff065F46),
                          foregroundColor: Colors.white,
                        ),
                        onPressed:
                        isSaving ? null : saveProfile,
                        icon: const Icon(Icons.save),
                        label: isSaving
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'प्रोफ़ाइल सेव करें',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await _auth.signOut();

                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                          (route) => route.isFirst,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}