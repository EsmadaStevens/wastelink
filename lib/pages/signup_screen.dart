import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTerms = false;
  bool _isGoogleLoading = false;
  bool _isEmailLoading = false;
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _lgaController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();
  final SecureStorageService _storageService = SecureStorageService();

  // Define primary color as a constant
  static const Color primaryColor = Color(0xFF064E3B);

  // Variable to store the role passed from Onboarding
  String? _userRole;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the role argument passed from the onboarding screen
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _userRole = args;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _lgaController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isGoogleLoading = true);
    
    final user = await _authService.signInWithGoogle();
    if (!mounted) return;

    if (user != null) {
      final response = await _apiService.googleAuth(
        email: user.email,
        name: user.displayName ?? '',
        googleId: user.id,
        photoUrl: user.photoUrl,
      );

      if (mounted && response != null) {
        final token = response['token'];
        final role = response['role'];

        if (token != null) {
          await _storageService.saveAuthToken(token);
          // Save role if returned (important for app logic)
          if (role != null) {
            await _storageService.saveUserRole(role);
          }

          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google Sign-Up failed. Please try again.")),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google sign in not available'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    
    if (mounted) {
      setState(() => _isGoogleLoading = false);
    }
  }

  void _handleEmailSignUp() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to the Terms and Conditions.")),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isEmailLoading = true);

      final Map<String, dynamic> response = await _apiService.signUpWithEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passController.text,
        role: _userRole ?? "SME", 
        lga: _lgaController.text.trim(),
      );

      if (mounted) {
        final bool didSucceed = response['success'] == true;
        if (didSucceed) {
          // save name immediately so HomeScreen greeting works even before login
          await _storageService.saveUserDetails({'name': _nameController.text.trim(), 'email': _emailController.text.trim()});
          // also remember the role the user selected so we can double-check later
          if (_userRole != null) {
            await _storageService.saveUserRole(_userRole!);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account created! Please sign in.")),
          );
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sign-up failed. Email might be in use."),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        setState(() => _isEmailLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildFormFields(),
                const SizedBox(height: 24),
                _buildTermsAndConditions(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
                const SizedBox(height: 24),
                _buildSignInLink(),
                const SizedBox(height: 32),
                _buildDivider(),
                const SizedBox(height: 24),
                _buildGoogleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Extracted Builder Widgets ---

  Widget _buildHeader() {
    return const Text(
      "Create Account",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        fontFamily: 'Serif',
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person_outline)),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return "Name is required";
            if (v.contains(RegExp(r'''[<>"'&|{}]'''))) return "Invalid characters in name";
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lgaController,
          decoration: const InputDecoration(labelText: "LGA (Local Govt Area)", prefixIcon: Icon(Icons.location_city)),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return "LGA is required";
            if (v.contains(RegExp(r'''[<>"'&|{}]'''))) return "Invalid characters in LGA";
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email_outlined)),
          validator: (v) => v != null && v.contains("@") ? null : "Enter a valid email",
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passController,
          obscureText: _isPasswordObscured,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return "Password is required";
            if (v.length < 8) return "Password must be at least 8 characters";
            if (!v.contains(RegExp(r'[A-Z]'))) return "Must contain an uppercase letter";
            if (!v.contains(RegExp(r'[a-z]'))) return "Must contain a lowercase letter";
            if (!v.contains(RegExp(r'[0-9]'))) return "Must contain a number";
            if (!v.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return "Must contain a special character";
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPassController,
          obscureText: _isConfirmPasswordObscured,
          decoration: InputDecoration(
            labelText: "Confirm Password",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_isConfirmPasswordObscured ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
            ),
          ),
          validator: (v) => v == _passController.text ? null : "Passwords do not match",
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: _agreedToTerms,
          activeColor: primaryColor,
          onChanged: (val) => setState(() => _agreedToTerms = val!),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              children: [
                const TextSpan(text: "I agree to the "),
                TextSpan(
                  text: "Terms and Conditions.",
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: Navigate to your Terms and Conditions page
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isEmailLoading ? null : _handleEmailSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isEmailLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Create Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
          children: [
            TextSpan(
              text: "Sign in",
              style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("OR")),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: _isGoogleLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : OutlinedButton.icon(
              onPressed: _handleGoogleSignUp,
              icon: Image.asset('assets/images/google_pic.png', height: 24, width: 24),
              label: const Text("Continue with Google"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
    );
  }
}
