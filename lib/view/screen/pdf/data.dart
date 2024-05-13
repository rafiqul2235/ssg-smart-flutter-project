class DownloadItems {
  static const documents = [
    DownloadItem(
      name: 'Android Programming Cookbook',
      url:'http://202.164.208.12:29002/uploads/pdfs/DRUTI-MOVER-APP.pdf',
    ),
    DownloadItem(
      name: 'iOS Programming Guide',
      url:'http://202.164.208.12:29002/uploads/pdfs/DRUTI-MOVER-APP.pdf',
    ),
  ];

  static const images = [
  ];

  static const videos = [
  ];

  static const apks = [

  ];
}

class DownloadItem {
  const DownloadItem({this.name, this.url});
  final String? name;
  final String? url;
}
