class UserMenu {

  String? id;
  String? name;


  UserMenu.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['name'] = name;
    return json;
  }

  @override
  String toString() {
    return 'UserMenu{id: $id, name: $name}';
  }
}