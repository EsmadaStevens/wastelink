import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isGoogleLoading = false;
  bool _isEmailLoading = false;
  bool _isPasswordObscured = true;

  final AuthService _authService = AuthService();

  // Define primary color constant
  static const Color primaryColor = Color(0xFF064E3B);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);
    final user = await _authService.signInWithGoogle();

    if (!mounted) return;

    if (user != null) {
      // For Google Sign In, you might want to call a backend endpoint to get the token/role
      // For now, we just navigate home
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
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

  Future<void> _handleEmailSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isEmailLoading = true);

      final response = await ApiService().signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      setState(() => _isEmailLoading = false);

      if (response != null) {
        final token = response['token'];
        final user = response['user'];

        String? extractRoleFromToken(String? jwt) {
          if (jwt == null) return null;
          try {
            final parts = jwt.split('.');
            if (parts.length != 3) return null;
            final payload = parts[1];
            String normalized = base64.normalize(payload);
            final decoded = utf8.decode(base64Url.decode(normalized));
            final payloadMap = jsonDecode(decoded);
            final role = payloadMap['role'];
            if (role == null) return null;
            final low = role.toString().toLowerCase();
            if (low.contains('collector')) return 'Collector';
            return 'SME';
          } catch (_) {
            return null;
          }
        }

        if (token != null) {
          final storage = SecureStorageService();
          await storage.saveAuthToken(token);

          // Extract role from JWT token
          String? finalRole = extractRoleFromToken(token);
          if (finalRole == null) {
            // fallback: try stored role or default to SME
            final storedRole = await storage.getUserRole();
            if (storedRole != null) {
              final low = storedRole.toLowerCase();
              finalRole = low.contains('collector') ? 'Collector' : 'SME';
            } else {
              finalRole = 'SME';
            }
          }

          await storage.saveUserRole(finalRole);

          if (user != null) {
            await storage.saveUserDetails(user);
          } else {
            await storage.saveUserDetails({'name': _emailController.text.split('@').first});
          }

          if (mounted) {
            if (finalRole == 'Collector') {
              Navigator.of(context).pushReplacementNamed('/collector_home');
            } else {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful but no token returned.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password.")),
        );
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
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildOptionsRow(),
                const SizedBox(height: 32),
                _buildLoginButton(),
                const SizedBox(height: 24),
                _buildSignupLink(),
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

  // --- Helper Widgets ---

  Widget _buildHeader() {
    return const Text(
      "Welcome Back",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        fontFamily: 'Serif',
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Email",
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) => value!.isEmpty ? "Please enter your email" : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _isPasswordObscured,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
        ),
      ),
      validator: (value) => value!.isEmpty ? "Please enter your password" : null,
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _rememberMe,
                activeColor: primaryColor,
                onChanged: (val) => setState(() => _rememberMe = val!),
                visualDensity: VisualDensity.compact,
              ),
              const Flexible(child: Text("Remember me")),
            ],
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/forgot_password'),
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            padding: EdgeInsets.zero,
          ),
          child: const Text("Forgot Password?"),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isEmailLoading ? null : _handleEmailSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isEmailLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSignupLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an Account? ",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
          children: [
            TextSpan(
              text: "Sign Up",
              style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, '/signup'),
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
          ? const Center(child: CircularProgressIndicator())
          : OutlinedButton.icon(
              onPressed: _handleGoogleSignIn,
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
