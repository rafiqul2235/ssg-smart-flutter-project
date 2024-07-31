class ChatModel {
  int? _id;
  int? _userId;
  int? _sellerId;
  String? _message;
  int? _sentByCustomer;
  int? _sentBySeller;
  int? _seenByCustomer;
  int? _seenBySeller;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _shopId;

  ChatModel(
      {int? id,
        int? userId,
        int? sellerId,
        String? message,
        int? sentByCustomer,
        int? sentBySeller,
        int? seenByCustomer,
        int? seenBySeller,
        int? status,
        String? createdAt,
        String? updatedAt,
        int? shopId}) {
        _id = id;
        _userId = userId;
        _sellerId = sellerId;
        _message = message;
        _sentByCustomer = sentByCustomer;
        _sentBySeller = sentBySeller;
        _seenByCustomer = seenByCustomer;
        _seenBySeller = seenBySeller;
        _status = status;
        _createdAt = createdAt;
        _updatedAt = updatedAt;
        _shopId = shopId;
  }

  int? get id => _id;
  int? get userId => _userId;
  int? get sellerId => _sellerId;
  String? get message => _message;
  int? get sentByCustomer => _sentByCustomer;
  int? get sentBySeller => _sentBySeller;
  int? get seenByCustomer => _seenByCustomer;
  int? get seenBySeller => _seenBySeller;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get shopId => _shopId;

  ChatModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _sellerId = json['seller_id'];
    _message = json['message'];
    _sentByCustomer = json['sent_by_customer'];
    _sentBySeller = json['sent_by_seller'];
    _seenByCustomer = json['seen_by_customer'];
    _seenBySeller = json['seen_by_seller'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _shopId = json['shop_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['seller_id'] = _sellerId;
    data['message'] = _message;
    data['sent_by_customer'] = _sentByCustomer;
    data['sent_by_seller'] = _sentBySeller;
    data['seen_by_customer'] = _seenByCustomer;
    data['seen_by_seller'] = _seenBySeller;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['shop_id'] = _shopId;
    return data;
  }
}
