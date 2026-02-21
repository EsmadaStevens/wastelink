import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/onboarding_screen.dart';


const List<OnboardingSlide> slides = [
  OnboardingSlide(
    title: "Dispose with Purpose",
    description: "Seamlessly schedule pickups and track your recycling efforts in real time .",
    image: "images/image1.png", 
  ),
  OnboardingSlide(
    title: "A cleaner legacy",
    description: "Join a community dedicated to turning the tide on pollution.",
    image: "images/image2.png",
  ),
  OnboardingSlide(
    title: "Sort like a pro",
    description: "Distinguish the recyclables from the landfill.",
    image: "images/image3.png",
  ),
  OnboardingSlide(
    title: "Choose Your Role",
    description: "Tell us how you will use WasteLink.",
    image: "/images/image4.png",
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
  String? _selectedRole; // 'SME' or 'Collector'

  void _nextSlide() {
    if (_currentSlide < slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role to continue")),
      );
      return;
    }
    Navigator.pushNamed(context, '/signup', arguments: _selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xFF064E3B),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF064E3B),
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentSlide = index),
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  final isLastSlide = index == slides.length - 1;

                  return Column(
                    children: [
                      // --- Image Area ---
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
                              child: const Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      
                      // --- Content Area ---
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
                                  color: Color(0xFF064E3B),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              if (isLastSlide) ...[
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
                              ] else ...[
                                Text(
                                  slide.description,
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            
            // --- Bottom Controls ---
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(slides.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: _currentSlide == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentSlide == index
                              ? const Color(0xFF064E3B)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  
                  ElevatedButton(
                    onPressed: _nextSlide,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF064E3B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(_currentSlide == slides.length - 1 ? "Get Started" : "Next"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}