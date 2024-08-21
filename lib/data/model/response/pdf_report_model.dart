import 'package:ssg_smart2/utill/app_constants.dart';

class PDFReportModel {

  int? _id;
  String? _name;
  String? _description;
  String? _reportCategory;
  String? _fpr;
  String? _fileName;
  String? _url;
  bool? _isActive;

  PDFReportModel({int? id, String? name, String? description, String? reportCategory, String? fpr, String? fileName,String? url, bool? isActive}) {
      _id = id;
      _name = name;
      _description = description;
      _reportCategory = reportCategory;
      _fpr = fpr;
      _url = url;
      _fileName = fileName;
      _isActive = isActive;
  }

  int? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get reportCategory => _reportCategory;
  String? get fpr => _fpr;
  String? get url => _url;
  String? get fileName => _fileName;
  bool? get isActive => _isActive;

  PDFReportModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _reportCategory = json['reportCategory'];
    _fpr = json['fpr'];
    _fileName = json['fileName'];
    _url = '${AppConstants.BASE_URL}${json['url']}';
    _isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['description'] = _description;
    data['reportCategory'] = _reportCategory;
    data['fpr'] = _fpr;
    data['fileName'] = _fileName;
    data['url'] = _url;
    data['isActive'] = _isActive;
    return data;
  }
}
