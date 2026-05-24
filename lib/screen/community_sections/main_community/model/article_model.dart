import 'dart:convert';

class ArticleModel {
  Meta? meta;
  final List<Datum>? data;

  ArticleModel({this.meta, this.data});

  factory ArticleModel.fromRawJson(String str) =>
      ArticleModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArticleModel.fromJson(dynamic json) {
    if (json == null) return ArticleModel();

    return ArticleModel(
      data: (json as List).map((x) => Datum.fromJson(x)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? title;
  String? description;
  String? image;
  DateTime? publicationDate;
  String? sourseName;
  String? readTime;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isFavorite;

  Datum({
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
    this.isFavorite,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    publicationDate: json["publicationDate"] == null
        ? null
        : DateTime.parse(json["publicationDate"]),
    sourseName: json["sourseName"],
    readTime: json["readTime"],
    isDeleted: json["isDeleted"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    isFavorite: json["isFavorite"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "image": image,
    "publicationDate": publicationDate?.toIso8601String(),
    "sourseName": sourseName,
    "readTime": readTime,
    "isDeleted": isDeleted,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "isFavorite": isFavorite,
  };
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Meta({this.page, this.limit, this.total, this.totalPage});

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPage: json["totalPage"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPage": totalPage,
  };
}
