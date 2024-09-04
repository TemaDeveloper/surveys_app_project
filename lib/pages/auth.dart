import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:surveys_app_project/manager/shared_pref_manager.dart';
import 'package:surveys_app_project/models/user.dart';
import 'package:surveys_app_project/pages/waiting_page.dart';
import 'package:surveys_app_project/user_auth/firebase_auth.dart';
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
  bool _obscureConfirmPassword = true; 

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
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
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

   void _forgotPassword() {
    if (_emailController.text.isNotEmpty) {
      //_auth.sendPasswordResetEmail(_emailController.text);
      // Show confirmation message or navigate accordingly
    } else {
      // Show a message to enter email first
    }
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
      ),
    ),
    body: Center(
      child: SingleChildScrollView(
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensure card height matches content height
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.facebookBlue,
                  indicatorColor: AppColors.facebookBlue,
                  labelStyle: TextStyle(
                    fontFamily: 'arial_rounded',
                    fontSize: 16,
                    fontWeight: FontWeight.bold, // Bold tabs for Sign In / Create Account
                  ),
                  tabs: [
                    Tab(text: 'Sign In'),
                    Tab(text: 'Create Account'),
                  ],
                ),
                SizedBox(height: 16.0), // Add spacing between the TabBar and the content
                // No Flexible or Expanded here, let the TabBarView take the natural height
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6, // Adjust height as needed
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLoginForm(),
                      _buildCreateAccountForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}



Widget _buildLoginForm() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,
      child: ListView(
        children: [
          _buildTextFormField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Enter your Email',
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
            hintText: 'Enter your Password',
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
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildStyledButton(
            text: "Sign in",
            onPressed: _login,
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: _forgotPassword,
            child: Text("Forgot your password?", style: TextStyle(color: AppColors.facebookBlue)),
          ),
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

Widget _buildCreateAccountForm() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,
      child: ListView(
        children: [
          _buildTextFormField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Enter your Email',
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
            hintText: 'Enter your Password',
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
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildTextFormField(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            hintText: 'Please confirm your Password',
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildTextFormField(
            controller: _phoneController,
            labelText: 'Phone Number',
            hintText: 'Enter your Phone Number',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildTextFormField(
            controller: _firstNameController,
            labelText: 'First Name',
            hintText: 'Enter your first name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildTextFormField(
            controller: _lastNameController,
            labelText: 'Last Name',
            hintText: 'Enter your last name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildTextFormField(
            controller: _zipCodeController,
            labelText: 'Zip Code',
            hintText: 'Enter zip (or postal code)',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your zip code';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildStyledButton(
            text: "Create Account",
            onPressed: _register,
          ),
        ],
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
      SnackBar(content: Text('User is successfully created'));
      _userDataManager.saveUserData(user.uid, email);
      _addUser(user); // Pass the user to _addUser
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuestionnaireScreen()),
      );
    } else {
      SnackBar(content: Text('Some error happened'));

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
    SnackBar(content: Text('User is successfully signed in'));
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
    SnackBar(content: Text('Some error occurred'));
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
    String lastName = _lastNameController.text;
    String zip = _zipCodeController.text;

    saveUserToFirestore(user, UserModel(
      first_name: username,
      last_name: lastName,
      email: email,
      phone: phone,
      zip: zip,
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
      first_name: user.first_name,
      last_name: user.last_name,
      zip: user.zip,
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
