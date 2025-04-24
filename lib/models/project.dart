class Project {
  Project({
    required this.name,
    required this.description,
    this.imageUrl,
    this.url = '',
    this.githubUrl = '',
    this.appstoreUrl = '',
    this.playstoreUrl = '',
    this.id,
  });

  factory Project.fromJson(Map<String, dynamic> json, {String? id}) {
    return Project(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      url: (json['url'] as String?) ?? '',
      githubUrl: (json['github_url'] as String?) ?? '',
      appstoreUrl: (json['appstore_url'] as String?) ?? '',
      playstoreUrl: (json['playstore_url'] as String?) ?? '',
    );
  }

  final String? id;
  final String name;
  final String description;
  final String? imageUrl;
  final String url;
  final String githubUrl;
  final String appstoreUrl;
  final String playstoreUrl;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'url': url,
      'github_url': githubUrl,
      'appstore_url': appstoreUrl,
      'playstore_url': playstoreUrl,
    };
  }

  Project copyWith({
    String? name,
    String? description,
    String? imageUrl,
    String? url,
    String? githubUrl,
    String? appstoreUrl,
    String? playstoreUrl,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      url: url ?? this.url,
      githubUrl: githubUrl ?? this.githubUrl,
      appstoreUrl: appstoreUrl ?? this.appstoreUrl,
      playstoreUrl: playstoreUrl ?? this.playstoreUrl,
    );
  }
}
