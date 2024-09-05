import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';

class PhoneOTPVerification extends StatefulWidget {
  const PhoneOTPVerification({Key? key}) : super(key: key);

  @override
  State<PhoneOTPVerification> createState() => _PhoneOTPVerificationState();
}

class _PhoneOTPVerificationState extends State<PhoneOTPVerification> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool otpVisible = false;
  late ConfirmationResult confirmationResult;

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Phone OTP Authentication"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputTextField("Contact Number", phoneNumberController, context),
            otpVisible ? inputTextField("OTP", otpController, context) : SizedBox(),
            !otpVisible ? sendOTPButton("Send OTP") : submitOTPButton("Submit"),
          ],
        ),
      ),
    );
  }

  Widget sendOTPButton(String text) => ElevatedButton(
        onPressed: () async {
          setState(() {
            otpVisible = true;
          });
          confirmationResult = await FirebaseAuthentication().sendOTP(phoneNumberController.text);
        },
        child: Text(text),
      );

  Widget submitOTPButton(String text) => ElevatedButton(
        onPressed: () => FirebaseAuthentication().authenticate(confirmationResult, otpController.text),
        child: Text(text),
      );

  Widget inputTextField(
      String labelText, TextEditingController textEditingController, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.5,
        child: TextFormField(
          obscureText: labelText == "OTP" ? true : false,
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: labelText,
            hintStyle: TextStyle(color: Colors.blue),
            filled: true,
            fillColor: Colors.blue[100],
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(5.5),
            ),
          ),
        ),
      ),
    );
  }
}

class FirebaseAuthentication {
  String phoneNumber = "";

  Future<ConfirmationResult> sendOTP(String phoneNumber) async {
    this.phoneNumber = phoneNumber;
    FirebaseAuth auth = FirebaseAuth.instance;

    // Declare and initialize the RecaptchaVerifier
    RecaptchaVerifier verifier = RecaptchaVerifier(
      container: 'recaptcha', // The div ID where reCAPTCHA will be rendered
      auth: FirebaseAuthWeb.instance,
      size: RecaptchaVerifierSize.normal, // Display full reCAPTCHA challenge
      theme: RecaptchaVerifierTheme.light, // Light or dark theme
      onSuccess: () {
        print('reCAPTCHA completed successfully');
      },
      onError: (error) {
        print('reCAPTCHA error: $error');
      },
      onExpired: () {
        print('reCAPTCHA expired, re-rendering...');
      },
    );

    // Ensure the verifier is rendered after it's declared
    verifier.render(); // Explicitly render the reCAPTCHA

    // Pass the reCAPTCHA verifier to signInWithPhoneNumber
    try {
      ConfirmationResult result = await auth.signInWithPhoneNumber(
        phoneNumber.trim(), 
        verifier,
      );
      print("OTP Sent to $phoneNumber");
      return result;
    } catch (e) {
      print('Error sending OTP: $e');
      rethrow;
    }
  }

  Future<void> authenticate(ConfirmationResult confirmationResult, String otp) async {
    try {
      UserCredential userCredential = await confirmationResult.confirm(otp);
      if (userCredential.additionalUserInfo!.isNewUser) {
        print("Authentication Successful, New User");
      } else {
        print("User already exists");
      }
    } catch (e) {
      print("Failed to authenticate: $e");
    }
  }
}
