/*
 * @Author: Km Muzahid
 * @Date: 2026-01-09 11:21:25
 * @Email: km.muzahid@gmail.com
 */
class CourseModel {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String categoryId;
  final String categoryName;
  final String video;
  final double rating;
  final double price;
  final int reviews;
  final List<String> viewUsers;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.categoryId,
    required this.categoryName,
    required this.video,
    required this.rating,
    required this.price,
    required this.reviews,
    required this.viewUsers,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      video: json['video'] ?? '',
      rating: (json['ratings'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      reviews: (json['reviews'] as num?)?.toInt() ?? 0,
      viewUsers: List<String>.from(json['viewUsers'] ?? const []),
      isDeleted: json['isDeleted'] ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'video': video,
      'ratings': rating,
      'price': price,
      'reviews': reviews,
      'viewUsers': viewUsers,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}
