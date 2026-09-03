import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/feature_card.dart';
import 'schemes_screen.dart';
import 'ai_chat_screen.dart';
import 'document_help_screen.dart';
import 'government_office_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'scheme_search_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController searchController = TextEditingController();

  Future<DocumentSnapshot<Map<String, dynamic>>>? profileFuture;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      profileFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
    } else {
      profileFuture = null;
    }
  }

  void refreshProfile() {
    setState(() {
      loadProfile();
    });
  }

  void searchScheme() {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('योजना का नाम या शब्द लिखें'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SchemeSearchScreen(
          query: query,
        ),
      ),
    );
  }

  Future<void> openProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        user == null ? const LoginScreen() : const ProfileScreen(),
      ),
    );

    refreshProfile();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildUserWelcome() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Column(
          children: [
            Text(
              "नमस्ते 👋",
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "सरकारी योजनाएँ खोजें और AI से सहायता लें",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    final name =
    user.displayName?.trim().isNotEmpty == true ? user.displayName! : "साथी";

    if (profileFuture == null) {
      return _welcomeCard(
        name: name,
        state: '',
        category: '',
      );
    }

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: profileFuture,
      builder: (context, snapshot) {
        String state = '';
        String category = '';

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data();

          if (data != null) {
            state = data['state']?.toString() ?? '';
            category = data['category']?.toString() ?? '';
          }
        }

        return _welcomeCard(
          name: name,
          state: state,
          category: category,
        );
      },
    );
  }

  Widget _welcomeCard({
    required String name,
    required String state,
    required String category,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xff0A7A52),
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "नमस्ते, $name 👋",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                if (state.isNotEmpty || category.isNotEmpty)
                  Text(
                    [
                      if (state.isNotEmpty) state,
                      if (category.isNotEmpty) category,
                    ].join(" • "),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  )
                else
                  const Text(
                    "अपनी प्रोफ़ाइल पूरी करें",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: openProfile,
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 95,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xff0A7A52),
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff065F46),
                      Color(0xff16A34A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/sathi.png",
                      height: 150,
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "AI सरकारी साथी",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "सरकारी योजनाओं की जानकारी, अब आसान भाषा में",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 20),

                    buildUserWelcome(),

                    const SizedBox(height: 20),

                    // SEARCH
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => searchScheme(),
                        decoration: InputDecoration(
                          hintText: "कोई सरकारी योजना खोजें...",
                          prefixIcon: IconButton(
                            onPressed: searchScheme,
                            icon: const Icon(
                              Icons.search,
                              color: Color(0xff0A7A52),
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: searchController.clear,
                            icon: const Icon(Icons.clear),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // QUICK ACTIONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    buildQuickAction(
                      icon: Icons.search,
                      title: "योजना खोजें",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SchemesScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    buildQuickAction(
                      icon: Icons.smart_toy_outlined,
                      title: "AI से पूछें",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AIChatScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    buildQuickAction(
                      icon: Icons.person_outline,
                      title: "मेरी प्रोफ़ाइल",
                      onTap: openProfile,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "लोकप्रिय सेवाएँ",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    FeatureCard(
                      title: "सरकारी योजनाएँ",
                      icon: Icons.account_balance,
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SchemesScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    FeatureCard(
                      title: "AI से पूछें",
                      icon: Icons.smart_toy,
                      color: Colors.deepPurple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AIChatScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    FeatureCard(
                      title: "दस्तावेज़ सहायता",
                      icon: Icons.description,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DocumentHelpScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    FeatureCard(
                      title: "सरकारी कार्यालय",
                      icon: Icons.location_on,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const GovernmentOfficeScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    FeatureCard(
                      title: "मेरा प्रोफ़ाइल",
                      icon: Icons.person,
                      color: Colors.teal,
                      onTap: openProfile,
                    ),

                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}