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

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isGoogleLoading = true);
    
    // 1. Authenticate with Google
    final user = await _authService.signInWithGoogle();
    
    if (mounted) {
      if (user != null) {
        // 2. Send Google details to Backend to create account/login
        final response = await ApiService().googleAuth(
          email: user.email,
          name: user.displayName ?? '',
          googleId: user.id,
          photoUrl: user.photoUrl,
        );

        if (mounted) {
          if (response != null) {
            final token = response['token'];
            if (token != null) {
              // 3. Save token and navigate home
              await SecureStorageService().saveAuthToken(token);
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Google Sign-Up failed. Please try again.")),
            );
          }
        }
      }
      setState(() => _isGoogleLoading = false);
    }
  }

  void _handleEmailSignUp() async {
    if (_formKey.currentState!.validate() && _agreedToTerms) {
      setState(() => _isEmailLoading = true);

      final success = await ApiService().signUpWithEmail(
        name: _nameController.text,
        email: _emailController.text,
        password: _passController.text,
        role: "SME", // Default value
        lga: "Obafemi Owode", // Default value
      );

      if (mounted) {
        setState(() => _isEmailLoading = false);
        if (success) {
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
      }
    } else if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to the Terms and Conditions.")),
      );
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
          icon: const Icon(Icons.arrow_back, color: Color(0xFF064E3B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF064E3B),
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person_outline)),
                  validator: (v) => v!.isEmpty ? "Name is required" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email_outlined)),
                  validator: (v) => v!.contains("@") ? null : "Enter a valid email",
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock_outline)),
                  validator: (v) => v!.length < 6 ? "Password must be 6+ chars" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPassController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Confirm Password", prefixIcon: Icon(Icons.lock_outline)),
                  validator: (v) => v != _passController.text ? "Passwords do not match" : null,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      activeColor: const Color(0xFF064E3B),
                      onChanged: (val) => setState(() => _agreedToTerms = val!),
                    ),
                    const Expanded(child: Text("I agree to the Terms and Conditions.")),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isEmailLoading ? null : _handleEmailSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF064E3B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isEmailLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Next", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Sign in",
                          style: const TextStyle(color: Color(0xFF064E3B), fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, '/login'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("OR")), Expanded(child: Divider())]),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: _isGoogleLoading
                      ? const Center(child: CircularProgressIndicator())
                      : OutlinedButton.icon(
                          onPressed: _handleGoogleSignUp,
                          icon: Image.asset('images/google_pic.png', height: 24, width: 24),
                          label: const Text("Continue with Google"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}