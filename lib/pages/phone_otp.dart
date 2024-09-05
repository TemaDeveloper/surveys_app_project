import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:surveys_app_project/colors.dart';

class PhoneOTPVerification extends StatefulWidget {
  final String phoneNumber;
  const PhoneOTPVerification({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<PhoneOTPVerification> createState() => _PhoneOTPVerificationState();
}

class _PhoneOTPVerificationState extends State<PhoneOTPVerification> {
  
  TextEditingController otpController = TextEditingController();
  bool otpVisible = false;
  bool isLoading = true;
  late ConfirmationResult confirmationResult;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _sendOTP();
    //otpVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputTextField("OTP", otpController, context),
            _buildStyledButton(
              onPressed: () => FirebaseAuthentication().authenticate(confirmationResult, otpController.text),
              text: "Submit"
              ),
          ],
        ),
      ),
    );
  }

  void _sendOTP() async {
    try {
      setState(() {
        isLoading = true; // Show loading spinner
      });
      confirmationResult = await FirebaseAuthentication().sendOTP(widget.phoneNumber);
      setState(() {
        otpVisible = true;  // Make OTP input visible
        isLoading = false;  // Hide loading spinner
      });
    } catch (e) {
      setState(() {
        isLoading = false;  // Hide loading spinner
      });
      print("Error sending OTP: $e");
      // You can show an error message here if needed
    }
  }

    Widget _buildStyledButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.facebookBlue,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(25.0),
          color: AppColors.facebookBlue,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.transparent, // Transparent to show the Container color
              shadowColor: Colors.transparent, // Remove shadow if needed
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'arial_rounded',
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

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
