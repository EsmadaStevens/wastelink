import 'package:flutter/material.dart';
import '../../../../widgets/collector_bottom_nav_bar.dart';
import 'collector_home_screen.dart';
import 'collector_available_jobs_screen.dart';
import 'collector_earnings_screen.dart';
import 'collector_profile_screen.dart';

// Placeholder screens for other tabs
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title, style: Theme.of(context).textTheme.headlineMedium)),
    );
  }
}

class CollectorMainScreen extends StatefulWidget {
  const CollectorMainScreen({super.key});

  @override
  State<CollectorMainScreen> createState() => _CollectorMainScreenState();
}

class _CollectorMainScreenState extends State<CollectorMainScreen> {
  CollectorNavTab _activeTab = CollectorNavTab.home;

  void _onTabSelected(CollectorNavTab tab) {
    setState(() {
      _activeTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _activeTab.index,
        children: const [
          CollectorHomeScreen(),
          CollectorAvailableJobsScreen(),
          CollectorEarningsScreen(),
          CollectorProfileScreen(),
        ],
      ),
      bottomNavigationBar: CollectorBottomNavBar(
        activeTab: _activeTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}