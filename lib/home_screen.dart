import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? lastPeriodDate;
  int cycleLength = 28;
  int daysRemaining = 0;
  int? currentDayInPeriod;
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString('lastPeriodDate');
    final storedCycleLength = prefs.getInt('cycleLength') ?? 28;

    if (storedDate != null) {
      lastPeriodDate = DateTime.parse(storedDate);
      daysRemaining = _calculateDaysUntilNextPeriod(lastPeriodDate!, storedCycleLength);
      currentDayInPeriod = _calculateCurrentDayInPeriod(lastPeriodDate!);
    }

    setState(() {
      cycleLength = storedCycleLength;
    });
  }

  int _calculateDaysUntilNextPeriod(DateTime lastPeriod, int cycle) {
    final nextPeriod = lastPeriod.add(Duration(days: cycle));
    final diff = nextPeriod.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  int _calculateCurrentDayInPeriod(DateTime lastPeriod) {
    final diff = DateTime.now().difference(lastPeriod).inDays + 1;
    return diff > 0 ? diff : 0;
  }

  void _navigateDate(int days) {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 127, 40, 70), Colors.pink.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello, Gorgeous 🌟",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white, size: 32),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 50),
            
            // 📅 تاريخ اليوم بتنسيق أوضح
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                  onPressed: () => _navigateDate(-1),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateFormat('dd MMM yyyy').format(_currentDate),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 30),
                  onPressed: () => _navigateDate(1),
                ),
              ],
            ),
            SizedBox(height: 60),

            // 🌸 Period Cycle Display (Bigger Box)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(3, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Current Cycle Day",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  Text(
                    currentDayInPeriod != null && currentDayInPeriod! <= 6
                        ? 'DAY $currentDayInPeriod'
                        : 'Not in period',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Change Period Date",
                      style: TextStyle(color: Colors.pink, fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
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