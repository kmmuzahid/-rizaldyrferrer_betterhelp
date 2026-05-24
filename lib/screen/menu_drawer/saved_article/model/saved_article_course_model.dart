class SavedArticleResponse {
  final bool? success;
  final String? message;
  final Meta? meta;
  final Data? data;

  SavedArticleResponse({
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory SavedArticleResponse.fromJson(dynamic json) {
    if (json == null) return SavedArticleResponse();
    return SavedArticleResponse(
      data: Data.fromJson(json as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'meta': meta?.toJson(),
      'data': data?.toJson(),
    };
  }
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPage: json['totalPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPage': totalPage,
    };
  }
}

class Data {
  final List<SavedCourse>? allCourses;
  final List<SavedArticle>? allArticles;

  Data({
    this.allCourses,
    this.allArticles,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      allCourses: json['allCourses'] != null
          ? (json['allCourses'] as List)
              .map((e) => SavedCourse.fromJson(e))
              .toList()
          : null,
      allArticles: json['allArticles'] != null
          ? (json['allArticles'] as List)
              .map((e) => SavedArticle.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allCourses': allCourses?.map((e) => e.toJson()).toList(),
      'allArticles': allArticles?.map((e) => e.toJson()).toList(),
    };
  }
}

class SavedCourse {
  final String? id;
  final String? type;
  final String? userId;
  final CourseDetail? courseId;
  final dynamic articleId;
  final String? createdAt;
  final String? updatedAt;

  SavedCourse({
    this.id,
    this.type,
    this.userId,
    this.courseId,
    this.articleId,
    this.createdAt,
    this.updatedAt,
  });

  factory SavedCourse.fromJson(Map<String, dynamic> json) {
    return SavedCourse(
      id: json['_id'] as String?,
      type: json['type'] as String?,
      userId: json['userId'] as String?,
      courseId: json['courseId'] != null
          ? CourseDetail.fromJson(json['courseId'])
          : null,
      articleId: json['articleId'],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'userId': userId,
      'courseId': courseId?.toJson(),
      'articleId': articleId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CourseDetail {
  final String? id;
  final String? title;
  final String? description;
  final String? thumbnail;
  final String? categoryId;
  final String? categoryName;
  final String? video;
  final double? ratings;
  final int? reviews;
  final List<String>? viewUsers;
  final int? viewCount;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  CourseDetail({
    this.id,
    this.title,
    this.description,
    this.thumbnail,
    this.categoryId,
    this.categoryName,
    this.video,
    this.ratings,
    this.reviews,
    this.viewUsers,
    this.viewCount,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      video: json['video'] as String?,
      ratings: (json['ratings'] as num?)?.toDouble(),
      reviews: json['reviews'] as int?,
      viewUsers: json['viewUsers'] != null
          ? (json['viewUsers'] as List).map((e) => e.toString()).toList()
          : null,
      viewCount: json['viewCount'] as int?,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
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
      'ratings': ratings,
      'reviews': reviews,
      'viewUsers': viewUsers,
      'viewCount': viewCount,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class SavedArticle {
  final String? id;
  final String? type;
  final String? userId;
  final dynamic courseId;
  final ArticleDetail? articleId;
  final String? createdAt;
  final String? updatedAt;

  SavedArticle({
    this.id,
    this.type,
    this.userId,
    this.courseId,
    this.articleId,
    this.createdAt,
    this.updatedAt,
  });

  factory SavedArticle.fromJson(Map<String, dynamic> json) {
    return SavedArticle(
      id: json['_id'] as String?,
      type: json['type'] as String?,
      userId: json['userId'] as String?,
      courseId: json['courseId'],
      articleId: json['articleId'] != null
          ? ArticleDetail.fromJson(json['articleId'])
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'userId': userId,
      'courseId': courseId,
      'articleId': articleId?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ArticleDetail {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final String? publicationDate;
  final String? sourseName;
  final String? readTime;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  ArticleDetail({
    this.id,
    this.title,
    this.description,
    this.image,
    this.publicationDate,
    this.sourseName,
    this.readTime,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ArticleDetail.fromJson(Map<String, dynamic> json) {
    return ArticleDetail(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      publicationDate: json['publicationDate'] as String?,
      sourseName: json['sourseName'] as String?,
      readTime: json['readTime'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'image': image,
      'publicationDate': publicationDate,
      'sourseName': sourseName,
      'readTime': readTime,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}