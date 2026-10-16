import 'dart:convert';

enum UnitSystem {
  metric, // kg, cm, km, ml
  imperial, // lbs, inches, miles, fl oz
}

class UserProfile {
  final String name;
  final int age;
  final String gender;
  final double heightCm;
  final double currentWeightKg;
  final UnitSystem unitSystem;
  final String avatarUrl;

  const UserProfile({
    this.name = 'Alex Rider',
    this.age = 26,
    this.gender = 'Male',
    this.heightCm = 178.0,
    this.currentWeightKg = 72.5,
    this.unitSystem = UnitSystem.metric,
    this.avatarUrl = '',
  });

  double get bmi {
    if (heightCm <= 0) return 0.0;
    final heightInMeters = heightCm / 100.0;
    return currentWeightKg / (heightInMeters * heightInMeters);
  }

  String get bmiCategory {
    final val = bmi;
    if (val < 18.5) return 'Underweight';
    if (val < 25.0) return 'Normal Weight';
    if (val < 30.0) return 'Overweight';
    return 'Obese';
  }

  UserProfile copyWith({
    String? name,
    int? age,
    String? gender,
    double? heightCm,
    double? currentWeightKg,
    UnitSystem? unitSystem,
    String? avatarUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      unitSystem: unitSystem ?? this.unitSystem,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'heightCm': heightCm,
      'currentWeightKg': currentWeightKg,
      'unitSystem': unitSystem.name,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String? ?? 'Alex Rider',
      age: (map['age'] as num?)?.toInt() ?? 26,
      gender: map['gender'] as String? ?? 'Male',
      heightCm: (map['heightCm'] as num?)?.toDouble() ?? 178.0,
      currentWeightKg: (map['currentWeightKg'] as num?)?.toDouble() ?? 72.5,
      unitSystem: UnitSystem.values.firstWhere(
        (e) => e.name == map['unitSystem'],
        orElse: () => UnitSystem.metric,
      ),
      avatarUrl: map['avatarUrl'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);
}
