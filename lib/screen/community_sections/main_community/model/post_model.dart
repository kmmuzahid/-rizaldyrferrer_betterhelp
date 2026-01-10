class PostModel {
  final bool? success;
  final String? message;
  final Meta? meta;
  final List<Post>? data;

  PostModel({this.success, this.message, this.meta, this.data});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => Post.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'meta': meta?.toJson(),
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  Meta({this.page, this.limit, this.total, this.totalPage});

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

class Post {
  final String? id;
  final User? userId;
  final String? description;
  final List<dynamic>? likes;
  final bool? highlights;
  final int? commentsCount;
  final int? likesCount;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final bool? isLiked;

  Post({
    this.id,
    this.userId,
    this.description,
    this.likes,
    this.highlights,
    this.commentsCount,
    this.likesCount,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] as String?,
      userId: json['userId'] != null ? User.fromJson(json['userId']) : null,
      description: json['description'] as String?,
      likes: json['likes'] as List<dynamic>?,
      highlights: json['highlights'] as bool?,
      commentsCount: json['commentsCount'] as int?,
      likesCount: json['likesCount'] as int?,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isLiked: json['isLiked'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId?.toJson(),
      'description': description,
      'likes': likes,
      'highlights': highlights,
      'commentsCount': commentsCount,
      'likesCount': likesCount,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isLiked': isLiked,
    };
  }
}

class User {
  final String? id;
  final String? profile;
  final String? fullName;
  final String? email;
  final String? role;
  final String? address;

  User({
    this.id,
    this.profile,
    this.fullName,
    this.email,
    this.role,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String?,
      profile: json['profile'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'profile': profile,
      'fullName': fullName,
      'email': email,
      'role': role,
      'address': address,
    };
  }
}
