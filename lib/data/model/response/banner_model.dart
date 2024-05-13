class BannerModel {
  int? _id;
  String? _photo;
  String? _bannerType;
  int? _published;
  String? _createdAt;
  String? _updatedAt;
  String? _url;

  BannerModel({int? id, String? photo, String? bannerType, int? published, String? createdAt, String? updatedAt, String? url}) {
    _id = id;
    _photo = photo;
    _bannerType = bannerType;
    _published = published;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _url = url;
  }

  int? get id => _id;
  String? get photo => _photo;
  String? get bannerType => _bannerType;
  int? get published => _published;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get url => _url;

  BannerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _photo = json['name'];
    _bannerType = json['bannerType'];
    _published = json['published'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _url = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _photo;
    data['bannerType'] = _bannerType;
    data['published'] = _published;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['imageUrl'] = _url;
    return data;
  }
}
