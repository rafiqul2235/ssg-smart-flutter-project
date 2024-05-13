import 'package:ssg_smart2/utill/app_constants.dart';

class DownloadItems {
  static const documents = [
  ];

  static const images = [
  ];

  static const videos = [
  ];

  static const apks = [
    DownloadItem(
      name: 'Druti Int App',
      url: '${AppConstants.BASE_URL}API/ApkDownload/FromApp',
    )
  ];
}

class DownloadItem {
  const DownloadItem({this.name, this.url});

  final String? name;
  final String? url;
}
