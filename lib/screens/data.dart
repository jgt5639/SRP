class DownloadItems {
  static const songs = [
    DownloadItem(
      name: 'Song1',
      url: 'www.google.com',
    ),
  ];
}

class DownloadItem {
  const DownloadItem({required this.name, required this.url});

  final String name;
  final String url;
}
