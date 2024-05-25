import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:surveys_app_project/manager/shared_pref_manager.dart';
import 'package:surveys_app_project/models/user.dart';
import 'package:surveys_app_project/pages/waiting_page.dart';
import 'package:surveys_app_project/user_auth/firebase_auth.dart';
import 'package:surveys_app_project/user_auth/toast.dart';
import '../pages/questioner.dart';
import 'package:surveys_app_project/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(
        primarySwatch: AppColors.facebookBlueMaterial,
      ),
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserDataManager _userDataManager = UserDataManager();

  bool isSigningUp = false;
  bool _isSigning = false;

  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful')),
      );

      _signUp();
    }
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signing in Successful')),
      );
      _signIn();
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0), // Adjust the height as needed
        child: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/nightcaps_logo.png",
                fit: BoxFit.contain,
                height: 200, // Adjust the height as needed
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.facebookBlue,
            dividerColor: AppColors.facebookBlue,
            indicatorColor: AppColors.facebookBlue,
            labelStyle: TextStyle(
              fontFamily: 'arial_rounded',
              fontSize: 16,
            ),
            tabs: [
              Tab(text: 'Create Account'),
              Tab(text: 'Log In'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCreateAccountForm(),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildCreateAccountForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _buildTextFormField(
              controller: _nameController,
              labelText: 'Name',
              hintText: 'Enter your name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _buildTextFormField(
              controller: _phoneController,
              labelText: 'Phone no.',
              hintText: 'Enter your phone',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _buildTextFormField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _buildTextFormField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _buildStyledButton(
              text: "Sign up",
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextFormField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _buildTextFormField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _buildStyledButton(
              text: "Log in",
              onPressed: () {
                _login();
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.facebookBlue,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.facebookBlue),
        ),
        labelStyle: TextStyle(color: AppColors.grey),
      ),
      validator: validator,
    );
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

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });
    if (user != null) {
      showToast(message: "User is successfully created");
      _userDataManager.saveUserData(user.uid, email);
      _addUser(user); // Pass the user to _addUser
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuestionnaireScreen()),
      );
    } else {
      showToast(message: "Some error happened");
    }
  }

  void _signIn() async {
  setState(() {
    _isSigning = true;
  });

  String email = _emailController.text;
  String password = _passwordController.text;

  User? user = await _auth.signInWithEmailAndPassword(email, password);

  setState(() {
    _isSigning = false;
  });

  if (user != null) {
    showToast(message: "User is successfully signed in");
    _userDataManager.saveUserData(user.uid, email);

    // Check the survey status
    bool? surveyCompleted = await getSurveyCompletedStatus(user);

    if (surveyCompleted == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CompletedSurveyPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuestionnaireScreen()),
      );
    }
  } else {
    showToast(message: "Some error occurred");
  }
}

Future<bool?> getSurveyCompletedStatus(User user) async {
  final userCollection = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot docSnapshot = await userCollection.doc(user.uid).get();

  if (docSnapshot.exists) {
    // Extract the survey_completed field
    var data = docSnapshot.data() as Map<String, dynamic>;
    bool? surveyCompleted = data['survey_completed'] as bool?;
    return surveyCompleted;
  } else {
    print('Document does not exist');
    return null;
  }
}


  void _addUser(User user) {
    String username = _nameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;

    saveUserToFirestore(user, UserModel(
      name: username,
      email: email,
      phone: phone,
      date: Timestamp.now(),
      survey_completed: false,
    ));
  }
}

Future<void> saveUserToFirestore(User userauth, UserModel user) async {
  final userCollection = FirebaseFirestore.instance.collection('users');
  String userId = userauth.uid;

  try {
    final newUser = UserModel(
      id: userId,
      name: user.name,
      email: user.email,
      date: user.date,
      phone: user.phone,
      survey_completed: user.survey_completed,
    ).toJson();

    await userCollection.doc(userId).set(newUser);
    print('User data saved successfully.');
  } catch (e) {
    print('Error saving user data: $e');
  }
}
