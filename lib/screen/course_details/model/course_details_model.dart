class CourseDetailsModel {
  final CourseData data;
  final List<ReviewRating> reviewRating;

  CourseDetailsModel({required this.data, required this.reviewRating});

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsModel(
      data: CourseData.fromJson(json['data'] ?? {}),
      reviewRating: (json['reviewRating'] as List? ?? [])
          .map((e) => ReviewRating.fromJson(e))
          .toList(),
    );
  }
}

class CourseData {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String categoryId;
  final String categoryName;
  final String video;
  final double price;
  final double ratings;
  final int reviews;
  final int viewCount;
  final List<String> viewUsers;
  final bool isDeleted;
  final bool isFavorite;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CourseData({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.categoryId,
    required this.categoryName,
    required this.video,
    required this.price,
    required this.ratings,
    required this.reviews,
    required this.viewCount,
    required this.viewUsers,
    required this.isDeleted,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      video: json['video'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      ratings: (json['ratings'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      viewUsers: List<String>.from(json['viewUsers'] ?? []),
      isDeleted: json['isDeleted'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}

class ReviewRating {
  final int rating;
  final int count;

  ReviewRating({required this.rating, required this.count});

  factory ReviewRating.fromJson(Map<String, dynamic> json) {
    return ReviewRating(rating: json['rating'] ?? 0, count: json['count'] ?? 0);
  }
}
