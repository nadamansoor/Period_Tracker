class Profile {
  String? name; 
  DateTime? lastPeriodDate; 
  int? cycleLength;  
  int? periodDuration; 
 

  Profile({
    this.name,
    this.lastPeriodDate,
    this.cycleLength,
    this.periodDuration,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastPeriodDate': lastPeriodDate?.toIso8601String(),
      'cycleLength': cycleLength,
      'periodDuration': periodDuration, 
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'],
      lastPeriodDate: map['lastPeriodDate'] != null
          ? DateTime.parse(map['lastPeriodDate'])
          : null,
      cycleLength: map['cycleLength'],
      periodDuration: map['periodDuration'], 
    );
  }
}