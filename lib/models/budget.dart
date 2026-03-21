class Budget {
  final int? id;
  final double weeklyBudget;
  final double weeklySpent;
  final String weekLabel;

  const Budget({
    this.id,
    required this.weeklyBudget,
    required this.weeklySpent,
    required this.weekLabel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weeklyBudget': weeklyBudget,
      'weeklySpent': weeklySpent,
      'weekLabel': weekLabel,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] as int?,
      weeklyBudget: (map['weeklyBudget'] as num).toDouble(),
      weeklySpent: (map['weeklySpent'] as num).toDouble(),
      weekLabel: map['weekLabel'] as String,
    );
  }

  Budget copyWith({
    int? id,
    double? weeklyBudget,
    double? weeklySpent,
    String? weekLabel,
  }) {
    return Budget(
      id: id ?? this.id,
      weeklyBudget: weeklyBudget ?? this.weeklyBudget,
      weeklySpent: weeklySpent ?? this.weeklySpent,
      weekLabel: weekLabel ?? this.weekLabel,
    );
  }
}
