class DownloadItems {
  static const Songs = [
    DownloadItem(
      name: 'Song1',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    DownloadItem(
      name: 'Song7',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
    ),
    DownloadItem(
      name: 'Song 2',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    ),
    DownloadItem(
      name: 'Song4',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    ),
    DownloadItem(
      name: 'Death Valley National Park',
      url:
          'https://upload.wikimedia.org/wikipedia/commons/b/b2/Sand_Dunes_in_Death_Valley_National_Park.jpg',
    ),
    DownloadItem(
      name: 'Gates of the Arctic National Park and Preserve',
      url:
          'https://upload.wikimedia.org/wikipedia/commons/e/e4/GatesofArctic.jpg',
    ),
  ];
}

class DownloadItem {
  const DownloadItem({required this.name, required this.url});

  final String name;
  final String url;
}
