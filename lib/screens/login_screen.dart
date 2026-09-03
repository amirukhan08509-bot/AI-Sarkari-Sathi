import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Email aur Password enter karein');
      return;
    }

    if (!isLogin && name.isEmpty) {
      showMessage('Apna naam enter karein');
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await credential.user?.updateDisplayName(name);
        await credential.user?.reload();
      }

      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = 'Kuch galat ho gaya';

      if (e.code == 'email-already-in-use') {
        message = 'Is Email se account pehle se bana hua hai';
      } else if (e.code == 'invalid-email') {
        message = 'Email address sahi nahi hai';
      } else if (e.code == 'weak-password') {
        message = 'Password kam se kam 6 characters ka rakhein';
      } else if (e.code == 'user-not-found' ||
          e.code == 'invalid-credential') {
        message = 'Email ya Password galat hai';
      } else if (e.code == 'wrong-password') {
        message = 'Email ya Password galat hai';
      } else {
        message = e.message ?? message;
      }

      showMessage(message);
    } catch (e) {
      showMessage('Kuch galat ho gaya');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Naya Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              const Icon(
                Icons.account_circle,
                size: 90,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              Text(
                isLogin ? 'Apne account me Login karein' : 'Apna account banayein',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              if (!isLogin)
                TextField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Naam',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),

              if (!isLogin) const SizedBox(height: 16),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                onSubmitted: (_) => submit(),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submit,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(isLogin ? 'Login' : 'Account Banayein'),
                ),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? 'Naya account banana hai? Sign Up'
                      : 'Pehle se account hai? Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}