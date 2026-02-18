import 'package:flutter/material.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WasteLink Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              color: Colors.greenAccent,
              child: ListTile(
                title: Text('Estimated Waste Value'),
                subtitle: Text('\$450.00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
            ),
            const Expanded(
              child: Center(child: Text('Your logs will appear here.')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {}, // Navigate to Scanner here
        label: const Text('Scan Waste'),
        icon: const Icon(Icons.camera_alt),
      ),
    );
  }
}
