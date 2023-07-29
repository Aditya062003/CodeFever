import 'dart:async';
import 'package:codefever/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen(
      {super.key,
      required this.isDarkModeEnabled,
      required this.toggleDarkMode});

  final bool isDarkModeEnabled;
  final void Function() toggleDarkMode;

  @override
  State<StatefulWidget> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isVerified = false;
  bool canResendEmail = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!_isVerified) {
      sendVerificationEmail();
      _timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkIsEmailVerified());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future checkIsEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      setState(() {
        _isVerified = true;
      });
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isVerified
        ? TabsScreen(
            isDarkModeEnabled: widget.isDarkModeEnabled,
            toggleDarkMode: widget.toggleDarkMode,
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify Email'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'A verification email has been sent to your email.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    icon: const Icon(
                      Icons.email,
                      size: 32,
                    ),
                    label: const Text(
                      'Resend Email',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
