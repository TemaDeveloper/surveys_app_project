import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isEmailVerified = false;
  bool _isLoading = false;
  bool _verificationEmailSent = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  Future<void> _sendVerificationEmail() async {
    setState(() {
      _isLoading = true;
    });

    User? user = _auth.currentUser;
    try {
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() {
          _verificationEmailSent = true;
        });
      }
    } catch (e) {
      print("Error sending email verification: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkEmailVerified() async {
    User? user = _auth.currentUser;
    await user?.reload();
    setState(() {
      _isEmailVerified = user?.emailVerified ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _verificationEmailSent
                  ? "A verification email has been sent to ${widget.email}. Please check your inbox."
                  : "Sending verification email...",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (!_isEmailVerified)
              ElevatedButton(
                onPressed: _checkEmailVerified,
                child: Text("Check Verification Status"),
              ),
            if (_isEmailVerified)
              Text(
                "Your email has been verified!",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendVerificationEmail,
                    child: Text("Resend Verification Email"),
                  ),
          ],
        ),
      ),
    );
  }
}
