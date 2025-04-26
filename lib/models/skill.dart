class Skill {
  Skill({required this.name, this.avatar, this.id, this.order = 0});

  factory Skill.fromJson(Map<String, dynamic> json, {String? id}) {
    return Skill(
      id: id,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      order: (json['order'] as num).toInt(),
    );
  }

  Skill copyWith({String? name, String? avatar, int? order}) {
    return Skill(
      id: id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      order: order ?? this.order,
    );
  }

  final String? id;
  final String name;
  final String? avatar;
  final int order;

  Map<String, dynamic> toJson() {
    return {'name': name, 'avatar': avatar};
  }
}
