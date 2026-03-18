import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/onboarding_screen.dart';
import '../services/secure_storage_service.dart';


const List<OnboardingSlide> slides = [
  OnboardingSlide(
    title: "Dispose with Purpose",
    description: "Seamlessly schedule pickups and track your recycling efforts in real time.",
    image: "assets/images/image1.png", 
  ),
  OnboardingSlide(
    title: "A Cleaner Legacy",
    description: "Join a community dedicated to turning the tide on pollution.",
    image: "assets/images/image2.png",
  ),
  OnboardingSlide(
    title: "Sort Like a Pro",
    description: "Distinguish the recyclables from the landfill.",
    image: "assets/images/image3.png",
  ),
  OnboardingSlide(
    title: "Choose Your Role",
    description: "Tell us how you will use WasteLink.",
    image: "assets/images/image4.png",
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentSlide = 0;
  final PageController _pageController = PageController();
  String? _selectedRole;

  // Centralized color constant
  static const Color primaryColor = Color(0xFF064E3B);

  void _onPageChanged(int index) {
    setState(() {
      _currentSlide = index;
    });
  }

  void _onButtonPressed() {
    if (_currentSlide < slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role to continue")),
      );
      return;
    }
    
    // Save that onboarding is done
    await SecureStorageService().setHasSeenOnboarding(true);
    
    if (mounted) {
      // Navigate to signup and pass the selected role
      Navigator.pushReplacementNamed(context, '/signup', arguments: _selectedRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: primaryColor,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPageView(),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  // --- Extracted Builder Widgets for Cleaner Code ---

  Widget _buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: slides.length,
        itemBuilder: (context, index) {
          final slide = slides[index];
          final isLastSlide = index == slides.length - 1;

          return Column(
            children: [
              // --- Image Area (Flex 5) ---
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  child: Image.asset(
                    slide.image,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              
              // --- Content Area (Flex 4) ---
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slide.title,
                        style: const TextStyle(
                          fontFamily: 'Serif',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      if (isLastSlide)
                        _buildRoleSelector()
                      else
                        Text(
                          slide.description,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "I am joining WasteLink as a:",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedRole,
              hint: const Text("Select Role"),
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: "SME",
                  child: Text("SME (Business Owner)"),
                ),
                DropdownMenuItem(
                  value: "Collector",
                  child: Text("Waste Collector"),
                ),
              ],
              onChanged: (val) => setState(() => _selectedRole = val),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page Indicators
          Row(
            children: List.generate(slides.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                height: 8,
                width: _currentSlide == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentSlide == index
                      ? primaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          
          // Next/Get Started Button
          ElevatedButton(
            onPressed: _onButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(_currentSlide == slides.length - 1 ? "Get Started" : "Next"),
          ),
        ],
      ),
    );
  }
}
