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
  final int viewCont;
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
    required this.viewCont,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
  });

  CourseModel copywith({
    String? id,
    String? title,
    String? description,
    String? thumbnail,
    String? categoryId,
    String? categoryName,
    String? video,
    double? rating,
    double? price,
    int? reviews,
    int? viewCont,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      video: video ?? this.video,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      reviews: reviews ?? this.reviews,
      viewCont: viewCont ?? this.viewCont,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

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
      viewCont: (json['viewCount'] as num?)?.toInt() ?? 0,
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
      'viewUsers': viewCont,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}
