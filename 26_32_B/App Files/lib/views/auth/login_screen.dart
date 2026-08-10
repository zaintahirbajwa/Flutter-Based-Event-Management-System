import 'package:flutter/material.dart';
import 'package:event_management_system/services/auth_service.dart';
import 'package:event_management_system/utils/theme.dart';
import 'package:event_management_system/views/user/user_dashboard_screen.dart';
import 'package:event_management_system/views/admin/admin_dashboard_screen.dart';
import 'package:event_management_system/views/auth/signup_screen.dart'; // Import SignUpScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isPasswordVisible = false; // To toggle password visibility

  // Function to handle the login process
  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      AuthService authService = AuthService();

      final userCredential = await authService.login(email, password);

      setState(() {
        _isLoading = false;
      });

      if (userCredential != null) {
        if (email == 'admin@example.com') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const AdminDashboardScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const UserDashboardScreen()),
          );
        }
      } else {
        _showErrorMessage("Invalid email or password");
      }
    }
  }

  // Function to handle Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    AuthService authService = AuthService();

    final userCredential = await authService.signInWithGoogle(context);

    setState(() {
      _isLoading = false;
    });

    if (userCredential != null) {
      if (userCredential.user?.email == 'admin@example.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserDashboardScreen()),
        );
      }
    } else {
      _showErrorMessage("Google sign-in failed");
    }
  }

  // Function to show error message
  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Custom text field with toggleable password visibility
  Widget _buildTextFormField(
      TextEditingController controller, String hintText, IconData prefixIcon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText:
          isPassword && !_isPasswordVisible, // Mask password when not visible
      style: TextStyle(fontWeight: FontWeight.normal), // Normal text style
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppTheme.primaryColor), // Blue hint text
        prefixIcon: Icon(prefixIcon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Larger border radius
          borderSide: BorderSide(
              width: 2.0, color: AppTheme.primaryColor), // Thicker border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              width: 2.0,
              color: AppTheme.primaryColor), // Thicker border when focused
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              width: 2.0, color: AppTheme.primaryColor), // Thicker border
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppTheme.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText cannot be empty';
        }
        return null;
      },
      focusNode: isPassword ? _passwordFocusNode : _emailFocusNode,
      textInputAction: isPassword ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: (value) {
        if (isPassword) {
          _login(); // Trigger login when 'Enter' is pressed on password field
        } else {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login To Your Account"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(  // Wrap the entire body in a SingleChildScrollView
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Row(
                children: [
                  // Left Section for the Logo (40% of the screen width)
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Image.asset(
                        'assets/images/app_logo.png',
                        height: 300, // Larger logo for web
                      ),
                    ),
                  ),
                  // Right Section for the Login Form (60% of the screen width)
                  Expanded(
                    flex: 6,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 500),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Welcome To Event Management System!',
                                style: TextStyle(
                                  fontSize: 22, // Increased font size for the welcome text
                                  fontWeight: FontWeight.bold, // Bold for emphasis
                                  color: AppTheme.primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    _buildTextFormField(
                                        _emailController, 'Email', Icons.email),
                                    const SizedBox(height: 20),
                                    _buildTextFormField(_passwordController,
                                        'Password', Icons.lock,
                                        isPassword: true),
                                    const SizedBox(height: 40),
                                    OutlinedButton(
                                      onPressed: _isLoading ? null : _login,
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.black
                                                : Colors.white,
                                        foregroundColor: AppTheme.primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 24.0), // Increased padding
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0), // More rounded corners
                                        ),
                                        side: BorderSide(
                                            color: AppTheme.primaryColor,
                                            width: 2.0), // Thicker border
                                      ),
                                      child: _isLoading
                                          ? const CircularProgressIndicator(
                                              color: AppTheme.primaryColor)
                                          : const Text(
                                              'Login With Email',
                                              style: TextStyle(
                                                  fontSize: 18, // Larger font size for better visibility
                                                  fontWeight: FontWeight.bold), // Bold text
                                            ),
                                    ),
                                    const SizedBox(height: 20),
                                    OutlinedButton.icon(
                                      onPressed:
                                          _isLoading ? null : _signInWithGoogle,
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.black
                                                : Colors.white,
                                        foregroundColor: AppTheme.primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 16.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        side: BorderSide(
                                            color: AppTheme.primaryColor,
                                            width: 2.0), // Thicker border
                                      ),
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Image.asset(
                                            'assets/images/google_logo.png',
                                            height: 20),
                                      ),
                                      label: const Text(
                                        'Sign In With Google',
                                        style: TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Don't have an account? Sign Up",
                                        style: TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.bold, // Bold text
                                            fontSize: 16), // Larger font size
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/app_logo.png',
                        height: 200,
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Welcome To Event Management System!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            _buildTextFormField(
                                _emailController, 'Email', Icons.email),
                            const SizedBox(height: 20),
                            _buildTextFormField(_passwordController, 'Password',
                                Icons.lock,
                                isPassword: true),
                            const SizedBox(height: 40),
                            OutlinedButton(
                              onPressed: _isLoading ? null : _login,
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).brightness == Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                foregroundColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                side: BorderSide(
                                    color: AppTheme.primaryColor, width: 2.0),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: AppTheme.primaryColor)
                                  : const Text(
                                      'Login With Email',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                            const SizedBox(height: 20),
                            OutlinedButton.icon(
                              onPressed: _isLoading ? null : _signInWithGoogle,
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).brightness == Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                foregroundColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                side: BorderSide(
                                    color: AppTheme.primaryColor, width: 2.0),
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.asset(
                                    'assets/images/google_logo.png',
                                    height: 20),
                              ),
                              label: const Text(
                                'Sign In With Google',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Don't have an account? Sign Up",
                                style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
