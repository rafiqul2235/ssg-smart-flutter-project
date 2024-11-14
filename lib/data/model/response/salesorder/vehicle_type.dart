
class VehicleType {
  String? typeId;
  String? typeName;
  List<VehicleTypeCategory>? categories;

  VehicleType(
      { this.typeId = "",
        this.typeName = ""});

  VehicleType.fromJson(Map<String, dynamic> json) {
    typeId = json['TYPE_ID'];
    typeName = json['TYPE_NAME'];
    if (json['CATEGORIES'] != null) {
      categories = [];
      json['CATEGORIES'].forEach((v) {
        categories?.add(new VehicleTypeCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TYPE_ID'] = typeId;
    data['TYPE_NAME'] = typeName;
    if (this.categories != null) {
      data['CATEGORIES'] = this.categories?.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class VehicleTypeCategory {
  String? categoryId;
  String? categoryName;

  VehicleTypeCategory(
      { this.categoryId = "",
        this.categoryName = ""});

  VehicleTypeCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['CATEGORY_ID'];
    categoryName = json['CATEGORY_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CATEGORY_ID'] = categoryId;
    data['CATEGORY_NAME'] = categoryName;
    return data;
  }

}
