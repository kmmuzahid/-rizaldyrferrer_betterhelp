class SinglePostModel {
  final bool? success;
  final String? message;
  final PostData? data;

  SinglePostModel({this.success, this.message, this.data});

  factory SinglePostModel.fromJson(Map<String, dynamic> json) {
    return SinglePostModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? PostData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class PostData {
  final String? id;
  final UserInfo? userId;
  final String? description;
  final List<String>? likes;
  final bool? highlights;
  final int? commentsCount;
  final int? likesCount;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final List<Comment>? comments;

  PostData({
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
    this.v,
    this.comments,
  });

  factory PostData.fromJson(Map<String, dynamic> json) {
    return PostData(
      id: json['_id'] as String?,
      userId: json['userId'] != null ? UserInfo.fromJson(json['userId']) : null,
      description: json['description'] as String?,
      likes: json['likes'] != null ? List<String>.from(json['likes']) : null,
      highlights: json['highlights'] as bool?,
      commentsCount: json['commentsCount'] as int?,
      likesCount: json['likesCount'] as int?,
      isDeleted: json['isDeleted'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      comments: json['comments'] != null
          ? (json['comments'] as List).map((e) => Comment.fromJson(e)).toList()
          : null,
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
      '__v': v,
      'comments': comments?.map((e) => e.toJson()).toList(),
    };
  }
}

class UserInfo {
  final String? id;
  final String? profile;
  final String? fullName;
  final String? email;
  final String? role;
  final String? address;

  UserInfo({
    this.id,
    this.profile,
    this.fullName,
    this.email,
    this.role,
    this.address,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
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

class Comment {
  final String? id;
  final PostReference? postId;
  final dynamic userId; // Can be String or CommentUser object
  final String? message;
  final List<dynamic>? likes;
  final String? parentId;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final List<Reply>? replies;
  bool? isLiked; // Mutable field to track if current user liked this

  Comment({
    this.id,
    this.postId,
    this.userId,
    this.message,
    this.likes,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.replies,
    this.isLiked,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] as String?,
      postId: json['postId'] != null
          ? PostReference.fromJson(json['postId'])
          : null,
      userId: json['userId'] is Map
          ? CommentUser.fromJson(json['userId'])
          : json['userId'] as String?,
      message: json['message'] as String?,
      likes: json['likes'] as List<dynamic>?,
      parentId: json['parentId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      replies: json['replies'] != null
          ? (json['replies'] as List).map((e) => Reply.fromJson(e)).toList()
          : null,
      isLiked: json['isLiked'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'postId': postId?.toJson(),
      'userId': userId is CommentUser
          ? (userId as CommentUser).toJson()
          : userId,
      'message': message,
      'likes': likes,
      'parentId': parentId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'replies': replies?.map((e) => e.toJson()).toList(),
      'isLiked': isLiked,
    };
  }

  // Helper method to get user name
  String getUserName() {
    if (userId is CommentUser) {
      return (userId as CommentUser).fullName ?? 'User';
    }
    return 'User';
  }

  // Helper method to get user profile
  String? getUserProfile() {
    if (userId is CommentUser) {
      return (userId as CommentUser).profile;
    }
    return null;
  }

  // Helper method to get likes count
  int getLikesCount() {
    return likes?.length ?? 0;
  }
}

// Add CommentUser class for populated user data
class CommentUser {
  final String? id;
  final String? profile;
  final String? fullName;
  final String? email;

  CommentUser({this.id, this.profile, this.fullName, this.email});

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['_id'] as String?,
      profile: json['profile'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'profile': profile,
      'fullName': fullName,
      'email': email,
    };
  }
}

class PostReference {
  final String? id;

  PostReference({this.id});

  factory PostReference.fromJson(Map<String, dynamic> json) {
    return PostReference(id: json['_id'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id};
  }
}

class Reply {
  final String? id;
  final ReplyUser? userId;
  final String? message;
  final List<dynamic>? likes;
  final List<Reply>? replies;
  bool? isLiked; // Track if current user liked this reply

  Reply({
    this.id,
    this.userId,
    this.message,
    this.likes,
    this.replies,
    this.isLiked,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['_id'] as String?,
      userId: json['userId'] != null
          ? ReplyUser.fromJson(json['userId'])
          : null,
      message: json['message'] as String?,
      likes: json['likes'] as List<dynamic>?,
      replies: json['replies'] != null
          ? (json['replies'] as List).map((e) => Reply.fromJson(e)).toList()
          : null,
      isLiked: json['isLiked'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId?.toJson(),
      'message': message,
      'likes': likes,
      'replies': replies?.map((e) => e.toJson()).toList(),
      'isLiked': isLiked,
    };
  }

  // Helper method to get likes count
  int getLikesCount() {
    return likes?.length ?? 0;
  }
}

class ReplyUser {
  final String? id;
  final String? profile;
  final String? fullName;

  ReplyUser({this.id, this.profile, this.fullName});

  factory ReplyUser.fromJson(Map<String, dynamic> json) {
    return ReplyUser(
      id: json['_id'] as String?,
      profile: json['profile'] as String?,
      fullName: json['fullName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'profile': profile, 'fullName': fullName};
  }
}
