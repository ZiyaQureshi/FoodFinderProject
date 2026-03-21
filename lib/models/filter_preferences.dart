class FilterPreferences {
  final int? id;
  final String cuisine;
  final String priceCategory;
  final bool openNow;

  const FilterPreferences({
    this.id,
    required this.cuisine,
    required this.priceCategory,
    required this.openNow,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cuisine': cuisine,
      'priceCategory': priceCategory,
      'openNow': openNow ? 1 : 0,
    };
  }

  factory FilterPreferences.fromMap(Map<String, dynamic> map) {
    return FilterPreferences(
      id: map['id'] as int?,
      cuisine: map['cuisine'] as String,
      priceCategory: map['priceCategory'] as String,
      openNow: (map['openNow'] as int) == 1,
    );
  }

  FilterPreferences copyWith({
    int? id,
    String? cuisine,
    String? priceCategory,
    bool? openNow,
  }) {
    return FilterPreferences(
      id: id ?? this.id,
      cuisine: cuisine ?? this.cuisine,
      priceCategory: priceCategory ?? this.priceCategory,
      openNow: openNow ?? this.openNow,
    );
  }

  static const defaults = FilterPreferences(
    cuisine: 'All',
    priceCategory: 'All',
    openNow: false,
  );
}
