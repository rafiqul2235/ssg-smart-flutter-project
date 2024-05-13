
class ApiPaginationResponse {

  int? _pageNo;
  int? _pageSize;
  int? _totalPages;
  int? _totalRecords;
  String? _filterKey;
  String? _filterValue;
  bool? _succeeded;
  String? _message;
  List<dynamic>? _data;

  ApiPaginationResponse(
      {int? pageNo,
        int? pageSize,
        int? totalPages,
        int? totalRecords,
        String? filterKey,
        String? filterValue,
        bool? succeeded,
        String? message}) {

    _pageNo = pageNo;
    _pageSize = pageSize;
    _totalPages = totalPages;
    _totalRecords = totalRecords;
    _filterKey = filterKey;
    _filterValue = filterValue;
    _succeeded = succeeded;
    _message = message;
    //_data = data;
  }

  int? get pageNo => _pageNo;
  int? get pageSize => _pageSize;
  int? get totalPages => _totalPages;
  int? get totalRecords => _totalRecords;
  String? get filterKey => _filterKey;
  String? get filterValue => _filterValue;
  bool? get succeeded => _succeeded;
  String? get message => _message;
  List<dynamic>? get data => _data;

  ApiPaginationResponse.fromJson(Map<String, dynamic> json) {
    _pageNo = json['pageNo']??0;
    _pageSize = json['pageSize']??0;
    _totalPages = json['totalPages']??0;
    _totalRecords = json['totalRecords']??0;
    _filterKey = json['filterKey']??'';
    _filterValue = json['filterValue']??'';
    _data = json['data'];
    /*if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(SalesModel.fromJson(v));
      });
    }*/

  }

}