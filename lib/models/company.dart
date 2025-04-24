class Company {
  Company({
    required this.name,
    required this.description,
    required this.startDate,
    this.id,
    this.logoUrl,
    this.endDate,
  });

  factory Company.fromJson(Map<String, dynamic> json, {String? id}) {
    return Company(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      logoUrl: json['logoUrl'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate:
          json['endDate'] != null
              ? DateTime.parse(json['endDate'] as String)
              : null,
    );
  }

  final String? id;
  final String name;
  final String description;
  final String? logoUrl;
  final DateTime startDate;
  final DateTime? endDate;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  Company copyWith({
    String? name,
    String? description,
    String? logoUrl,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Company(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
