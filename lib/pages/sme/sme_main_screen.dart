import 'package:flutter/material.dart';
import '../../widgets/sme_bottom_nav_bar.dart';
import 'home_screen.dart';
import '/pages/sme/log_waste_step1_screen.dart';
import 'pickup_screen.dart';
import 'rewards_marketplace_screen.dart';
import 'profile.dart';

class SmeMainScreen extends StatefulWidget {
  const SmeMainScreen({super.key});

  @override
  State<SmeMainScreen> createState() => _SmeMainScreenState();
}

class _SmeMainScreenState extends State<SmeMainScreen> {
  SmeNavTab _activeTab = SmeNavTab.home;

  // This method handles the tab switching logic
  void _onTabSelected(SmeNavTab tab) {
    setState(() {
      _activeTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserves the state of the pages (so you don't lose form data)
      body: IndexedStack(
        index: _activeTab.index,
        children: const [
          // 1. Home Tab
          HomeScreen(),
          
          // 2. Log Waste Tab
          LogWasteStep1Screen(),
          
          // 3. Pickup Tab
          SmePickupScreen(),
          
          // 4. Rewards Tab
          SmeRewardsMarketplaceScreen(),
          
          // 5. Profile Tab
          SmeProfileScreen(),
        ],
      ),
      bottomNavigationBar: SmeBottomNavBar(
        activeTab: _activeTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}