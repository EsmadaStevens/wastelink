import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../services/api_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 120;
  bool _isVerifying = false;
  String? _email;

  bool get _isResendActive => _secondsRemaining == 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_email == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _email = args;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _secondsRemaining = 120);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => timer.cancel());
      }
    });
  }

  String _maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex < 2) return email;
    final localPart = email.substring(0, atIndex);
    final domainPart = email.substring(atIndex);
    if (localPart.length <= 2) return '${localPart[0]}*@$domainPart';
    final maskedLocal = localPart.substring(0, 2) + '*' * (localPart.length - 2);
    return '$maskedLocal$domainPart';
  }

  void _handleResendOtp() async {
    if (_isResendActive && _email != null) {
      final success = await ApiService().sendOtp(_email!);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("A new OTP has been sent."),
            backgroundColor: Color(0xFF064E3B),
          ),
        );
        _startTimer();
      }
    }
  }

  void _handleVerifyOtp() async {
    if (_otpController.text.length != 6 || _email == null) return;

    setState(() => _isVerifying = true);

    final success = await ApiService().verifyOtp(_email!, _otpController.text);

    if (mounted) {
      setState(() => _isVerifying = false);
      if (success) {
        // Navigate to Reset Password, passing email and OTP (token)
        Navigator.pushReplacementNamed(
          context, 
          '/reset_password', 
          arguments: {'email': _email, 'otp': _otpController.text}
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid OTP. Please try again."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/forgot_password_email.png', height: 200),
              const SizedBox(height: 32),
              const Text("Verify Email", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF064E3B), fontFamily: 'Serif')),
              const SizedBox(height: 16),
              if (_email != null)
                Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    children: [
                      const TextSpan(text: "An OTP has been sent to "),
                      TextSpan(text: _maskEmail(_email!), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 32),
              Pinput(
                length: 6,
                controller: _otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(decoration: defaultPinTheme.decoration!.copyWith(border: Border.all(color: const Color(0xFF064E3B), width: 2))),
                autofocus: true,
              ),
              const SizedBox(height: 24),
              if (!_isResendActive)
                Text(
                  'Resend code in 0${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: "Didn't receive the code? ",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Resend",
                      style: TextStyle(
                        color: _isResendActive ? const Color(0xFF064E3B) : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: _isResendActive ? (TapGestureRecognizer()..onTap = _handleResendOtp) : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _handleVerifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF064E3B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isVerifying
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Verify", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}