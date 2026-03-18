import 'package:flutter/material.dart';

enum CollectorNavTab { home, jobs, route, profile }

class CollectorBottomNavBar extends StatelessWidget {
  final CollectorNavTab activeTab;
  final ValueChanged<CollectorNavTab> onTabSelected;

  const CollectorBottomNavBar({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: activeTab.index,
      onTap: (index) {
        // Check if the "Route" tab was tapped (index 2)
        if (index == CollectorNavTab.route.index) {
          // If so, perform a direct navigation to the navigation page.
          Navigator.pushNamed(context, '/collector_navigation');
        } else {
          // For all other tabs, use the existing callback to switch views.
          onTabSelected(CollectorNavTab.values[index]);
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF005C46),
      unselectedItemColor: Colors.grey[600],
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          label: 'Jobs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.navigation_outlined),
          label: 'Route',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
