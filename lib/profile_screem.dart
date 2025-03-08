import 'package:flutter/material.dart';
import 'profile_provider.dart'; 
import 'profile.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _cycleLengthController = TextEditingController();
  final _periodDurationController = TextEditingController(); 
  DateTime? _lastPeriodDate;

  @override
  void initState() {
    super.initState();
    _loadProfile(); 
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileProvider.getProfile();
    setState(() {
      _nameController.text = profile?.name ?? '';
      _cycleLengthController.text = profile?.cycleLength?.toString() ?? '28';
      _periodDurationController.text = profile?.periodDuration?.toString() ?? '5'; 
      _lastPeriodDate = profile?.lastPeriodDate;
    });
  }

  Future<void> _saveProfile() async {
    final profile = Profile(
      name: _nameController.text,
      lastPeriodDate: _lastPeriodDate,
      cycleLength: int.tryParse(_cycleLengthController.text) ?? 28,
      periodDuration: int.tryParse(_periodDurationController.text) ?? 5,
    );
    await ProfileProvider.saveProfile(profile);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data saved successfully')),
    );
  }

  Future<void> _selectLastPeriodDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastPeriodDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _lastPeriodDate) {
      setState(() {
        _lastPeriodDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF263238),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_nameController, 'Name', Icons.person),
            SizedBox(height: 15),
            _buildTextField(_cycleLengthController, 'Period Interval', Icons.timer, isNumeric: true),
            SizedBox(height: 15),
            _buildTextField(_periodDurationController, 'Cycle Length', Icons.access_time, isNumeric: true),
            SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
              title: Text('Last period date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Text(
                _lastPeriodDate != null
                    ? '${_lastPeriodDate!.toLocal()}'.split(' ')[0]
                    : 'Date not set',
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: Icon(Icons.calendar_today, color: Color(0xFF263238)),
              onTap: () => _selectLastPeriodDate(context),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF263238),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('SAVE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF263238)),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
