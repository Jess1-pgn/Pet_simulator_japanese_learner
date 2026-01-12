class PetProfile {
  final String name;
  final DateTime createdAt;

  PetProfile({
    required this.name,
    required this.createdAt,
  });

  factory PetProfile.fromJson(Map<String, dynamic> json) {
    return PetProfile(
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  int get daysAlive {
    return DateTime.now().difference(createdAt).inDays;
  }
}