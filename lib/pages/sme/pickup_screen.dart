import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class SmePickupScreen extends StatefulWidget {
  const SmePickupScreen({super.key});

  @override
  State<SmePickupScreen> createState() => _SmePickupScreenState();
}

class _SmePickupScreenState extends State<SmePickupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wasteTypeController = TextEditingController(text: 'Plastics');
  final _quantityController = TextEditingController(text: '10-20kg');
  final _locationController = TextEditingController(text: 'Ikeja, Lagos');
  final _dateController = TextEditingController();
  
  String _selectedTimeSlot = 'Morning (8am - 12pm)';
  final List<String> _timeSlots = [
    'Morning (8am - 12pm)',
    'Afternoon (12pm - 4pm)',
    'Evening (4pm - 8pm)'
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _wasteTypeController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF064E3B),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _handleRequestPickup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final response = await ApiService().requestPickup(
        wasteType: _wasteTypeController.text,
        quantity: _quantityController.text,
        location: _locationController.text,
        date: _dateController.text,
        timeSlot: _selectedTimeSlot,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response != null && response['pickupId'] != null) {
        final pickupId = response['pickupId'];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pickup requested successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to tracking screen with the new job ID
        Navigator.pushReplacementNamed(
          context,
          '/sme_pickup_tracking',
          arguments: pickupId,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to request pickup. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF064E3B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a Pickup'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter Pickup Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _wasteTypeController,
                decoration: const InputDecoration(
                  labelText: 'Waste Type',
                  prefixIcon: Icon(Icons.recycling),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter waste type' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Quantity (e.g., 10-20kg)',
                  prefixIcon: Icon(Icons.scale),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter quantity' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Pickup Location',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter location' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  labelText: 'Pickup Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please select a date' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedTimeSlot,
                decoration: const InputDecoration(
                  labelText: 'Preferred Time',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                items: _timeSlots.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedTimeSlot = val!),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleRequestPickup,
                  icon: _isLoading
                      ? const SizedBox.shrink()
                      : const Icon(Icons.local_shipping_outlined),
                  label: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Confirm Request',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}