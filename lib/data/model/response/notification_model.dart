class NotificationModel {
  int? _id;
  String? _sender;
  String? _category;
  String? _title;
  String? _description;
  String? _image;
  bool? _isVisitActionLog;
  int? _visitActionLogId;
  int? _status;
  bool? _isViewed;
  String? _createdAt;
  String? _updatedAt;

  NotificationModel(
      {int? id,
        String? sender,
        String? category,
        String? title,
        String? description,
        String? image,
        int? status,
        bool? isVisitActionLog,
        bool? isViewed,
        int? visitActionLogId,
        String? createdAt,
        String? updatedAt}) {
      _id = id;
      _sender = sender;
      _category = category;
      _title = title;
      _description = description;
      _image = image;
      _status = status;
      _isViewed = isViewed;
      _isVisitActionLog = isVisitActionLog;
      _visitActionLogId = visitActionLogId;
      _createdAt = createdAt;
      _updatedAt = updatedAt;
  }

  int? get id => _id;
  String? get sender => _sender;
  String? get category => _category;
  String? get title => _title;
  String? get description => _description;
  String? get image => _image;
  int? get status => _status;
  bool? get isVisitActionLog => _isVisitActionLog;
  bool? get isViewed => _isViewed??false;
  int? get visitActionLogId => _visitActionLogId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  void changeMessageFlag(){
    _isViewed = true;
  }

  NotificationModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _sender = json['sender'];
    _category = json['category'];
    _title = json['subject'];
    _description = json['text'];
    _isViewed = json['isViewed']??false;
    //_image = json['image'];
    //_status = json['status'];
    //_isVisitActionLog = json['isVisitActionLog'];
    //_visitActionLogId = json['visitActionLogId'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this._id;
    data['title'] = this._title;
    data['description'] = this._description;
    data['image'] = this._image;
    data['status'] = this._status;
    data['isVisitActionLog'] = this._isVisitActionLog;
    data['visitActionLogId'] = this._visitActionLogId;
    data['createdAt'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
