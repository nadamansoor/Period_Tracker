import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  DateTime? _lastPeriodDate;
  int? _cycleLength;
  int? _periodInterval;
  bool? _isRegular;
  bool _notificationsEnabled = false;
  int _currentStep = 0;

  Future<void> _saveData() async {
    if (_lastPeriodDate == null || _cycleLength == null || _periodInterval == null || _isRegular == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields before saving')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastPeriodDate', _lastPeriodDate!.toIso8601String());
    prefs.setInt('cycleLength', _cycleLength!);
    prefs.setInt('periodInterval', _periodInterval!);
    prefs.setBool('isRegular', _isRegular!);
    prefs.setBool('notificationsEnabled', _notificationsEnabled);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  void _nextStep() {
    if (_currentStep == 0 && _lastPeriodDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the last period date')),
      );
      return;
    }
    if (_currentStep == 1 && (_cycleLength == null || _cycleLength! <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid cycle length')),
      );
      return;
    }
    if (_currentStep == 2 && (_periodInterval == null || _periodInterval! <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid period interval')),
      );
      return;
    }
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      _saveData();
    }
  }
  TextEditingController _dateController = TextEditingController(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Setup',
        style: TextStyle(
          fontSize: 26 ),),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 130, 
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/set.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: _nextStep,
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep--);
                }
              },
              
              steps: [
                
                Step(
                  title: Text('Last Period Date'),
                  content: TextFormField(
                  controller: _dateController, 
                    decoration: InputDecoration(hintText: 'Select date'),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _lastPeriodDate = date;
                          _dateController.text = "${date.year}-${date.month}-${date.day}";
                        });
                      }
                    },
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: Text('Cycle Length'),
                  content: TextFormField(
                    decoration: InputDecoration(hintText: 'Enter cycle length (days)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _cycleLength = int.tryParse(value);
                      });
                    },
                  ),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: Text('Period Interval'),
                  content: TextFormField(
                    decoration: InputDecoration(hintText: 'Enter days between periods'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _periodInterval = int.tryParse(value);
                      });
                    },
                  ),
                  isActive: _currentStep >= 2,
                  state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: Text('Regular Cycle?'),
                  content: Row(
                    children: [
                      Text('Is your cycle regular?'),
                      SizedBox(width: 10),
                      Switch(
                        value: _isRegular ?? false,
                        onChanged: (value) {
                          setState(() {
                            _isRegular = value;
                          });
                        },
                        activeColor: Color(0xFF703E78),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 3,
                  state: _currentStep == 3 ? StepState.indexed : StepState.complete,
                ),
                Step(
                  title: Text('Enable Notifications'),
                  content: Row(
                    children: [
                      Text('Would you like to receive reminders?'),
                      SizedBox(width: 10),
                      Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                        activeColor: Color(0xFF703E78),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 4,
                  state: _currentStep == 4 ? StepState.indexed : StepState.complete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
