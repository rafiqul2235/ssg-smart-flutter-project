class ApiResonseNew {
  final dynamic data;
  final int? statusCode;
  final String? error;

  ApiResonseNew({this.data, this.statusCode, this.error});

  bool get isSuccess => error == null && statusCode == 200;

  ApiResonseNew.withError(String errorValue)
     : data = null,
       statusCode = null,
       error = errorValue;

  ApiResonseNew.withSuccess(dynamic responsValue)
      : data = responsValue.data,
        statusCode = responsValue.statusCode,
        error = null;

  @override
  String toString() {
    return 'ApiResonseNew{data: $data, statusCode: $statusCode, error: $error}';
  }
}