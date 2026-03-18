import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LogWasteStep2Screen extends StatefulWidget {
  const LogWasteStep2Screen({super.key});

  @override
  State<LogWasteStep2Screen> createState() => _LogWasteStep2ScreenState();
}

class _LogWasteStep2ScreenState extends State<LogWasteStep2Screen> {
  final _locationController = TextEditingController(text: "123 Main St, Lagos, Nigeria");
  final _dateController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _wasteType;
  
 
  String? _selectedQuantity;
  
  final List<String> _quantityOptions = [
    "1-5",
    "6-20",
    "21-100",
    "101+",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _wasteType = args['wasteType'];
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? photo = await _picker.pickImage(source: source);
    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
            color: const Color(0xFF005844),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Log Waste",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Serif',
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    const Icon(Icons.notifications, color: Colors.white),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF005844), width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Step 2 of 3",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          _buildDot(false),
                          const SizedBox(width: 6),
                          _buildDot(true),
                          const SizedBox(width: 6),
                          _buildDot(false),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text("Waste Details",
                      style: TextStyle(fontSize: 24, fontFamily: 'Serif', fontWeight: FontWeight.bold)),
                  Text("Provide information about your waste", style: TextStyle(color: Colors.grey.shade500)),
                  const SizedBox(height: 32),

                  // Form
                  _buildLabel("Quantity (Select Range)"),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _quantityOptions.length,
                    itemBuilder: (context, index) {
                      final option = _quantityOptions[index];
                      final isSelected = _selectedQuantity == option;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedQuantity = option;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF006442) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF006442) : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  _buildLabel("Upload Photos (Optional)"),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
                        image: _imageFile != null
                            ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _imageFile == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF006442).withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.photo_camera, color: Color(0xFF006442), size: 32),
                                ),
                                const SizedBox(height: 12),
                                const Text("Take or Upload Photo",
                                    style: TextStyle(
                                        color: Color(0xFF006442), fontSize: 18, fontFamily: 'Serif')),
                                Text("Helps with AI classification",
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildLabel("Location"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    decoration: _inputDecoration("Location")
                        .copyWith(prefixIcon: const Icon(Icons.location_on, color: Color(0xFF006442))),
                  ),
                  const SizedBox(height: 24),

                  _buildLabel("Date"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dateController,
                    decoration: _inputDecoration("mm/dd/yyyy")
                        .copyWith(suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF006442))),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _dateController.text = "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                      }
                    },
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedQuantity == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select a quantity range")),
                          );
                          return;
                        }
                        Navigator.pushNamed(context, '/log_waste_step3', arguments: {
                          'wasteType': _wasteType,
                          'quantity': _selectedQuantity, 
                          'location': _locationController.text,
                          'date': _dateController.text,
                          'imagePath': _imageFile?.path,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006442),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                      ),
                      child: const Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF006442) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade300),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF006442), width: 2),
      ),
    );
  }
}