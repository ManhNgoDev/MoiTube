class ChannelModel {
  final String id;
  final String handle;
  final String name;
  final String? description;
  final String? bannerUrl;
  final String? websiteUrl;
  final int subscriberCount;
  final String? avatarUrl;
  final Map<String, dynamic>? socialLinks;
  final DateTime createdAt;

  ChannelModel({
    required this.id,
    required this.handle,
    required this.name,
    this.description,
    this.bannerUrl,
    this.websiteUrl,
    required this.subscriberCount,
    this.avatarUrl,
    this.socialLinks,
    required this.createdAt,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    
    return ChannelModel(
      id: json['id'],
      handle: json['handle'],
      name: json['name'],
      description: json['description'],
      bannerUrl: json['banner_url'],
      websiteUrl: json['website_url'],
      subscriberCount: json['subscriber_count'] ?? 0,
      avatarUrl: user != null ? user['avatar_url'] : json['avatar_url'],
      socialLinks: json['social_link'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handle': handle,
      'name': name,
      'description': description,
      'banner_url': bannerUrl,
      'website_url': websiteUrl,
      'subscriber_count': subscriberCount,
      'avatar_url': avatarUrl,
      'social_link': socialLinks,
      'created_at': createdAt.toIso8601String(),
    };
  }

}
