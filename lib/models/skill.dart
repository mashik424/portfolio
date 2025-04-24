class Skill {
  Skill({required this.name, this.avatar, this.id});

  factory Skill.fromJson(Map<String, dynamic> json, {String? id}) {
    return Skill(
      id: id,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Skill copyWith({String? name, String? avatar}) {
    return Skill(
      id: id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  final String? id;
  final String name;
  final String? avatar;

  Map<String, dynamic> toJson() {
    return {'name': name, 'avatar': avatar};
  }
}
