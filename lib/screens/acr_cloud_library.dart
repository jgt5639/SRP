import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:senior_project/screens/acr_cloud_line.dart';

class AcrCloudLibrary extends StatefulWidget {
  const AcrCloudLibrary({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => AcrCloudLibraryState();
}

class AcrCloudLibraryState extends State<AcrCloudLibrary> {
//define on audio plugin
  final OnAudioQuery _audioQuery = OnAudioQuery();

  //today
  //player

  //more variables
  List<SongModel> songs = [];

  //request permission from initStateMethod
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }

  //dispose the player when done
  @override
  void dispose() {
    super.dispose();
  }

  // Color changeing stuff
  Color bgColor = const Color.fromARGB(255, 36, 48, 94);
  Color twoColor = const Color.fromARGB(255, 55, 71, 133);
  Color threeColor = const Color.fromARGB(255, 247, 108, 108);
  Color fourColor = const Color.fromARGB(255, 248, 233, 161);
  Color fiveColor = const Color.fromARGB(255, 168, 208, 230);

  @override
  Widget build(BuildContext context) {
    /**
    if (isPlayerViewVisible) {
      return const Scaffold(
        body: Text("isPlayerViewVisible"),
      );
    }
    **/
    //
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgColor, twoColor],
          ),
        ),
        child: FutureBuilder<List<SongModel>>(
          //default values
          future: _audioQuery.querySongs(
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
          ),
          builder: (context, item) {
            //loading content indicator
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //no songs found
            if (item.data!.isEmpty) {
              return const Center(
                child: Text("No Songs Found"),
              );
            }

            // You can use [item.data!] direct or you can create a list of songs as
            // List<SongModel> songs = item.data!;
            //showing the songs

            //add songs to the song list

            songs.clear();
            songs = item.data!;

            songs.removeWhere((element) => element.artist != "<unknown>");

            //songs.removeRange(5, songs.length);

            return RawScrollbar(
                //thumbVisibility: true,
                crossAxisMargin: 4,
                radius: const Radius.circular(10.0),
                thumbColor: threeColor,
                child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                            top: 15.0, left: 20.0, right: 20.0),
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: ListTile(
                          selectedTileColor: fiveColor,
                          textColor: fourColor,
                          title: Text(
                            "title: ${songs[index].title}",
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "artist: ${songs[index].artist.toString()}",
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 168, 208, 230),
                                  ),
                                ),
                              ]),
                          leading: QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(10.0),
                            id: songs[index].id,
                            type: ArtworkType.AUDIO,
                          ),
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AcrCloudLine(
                                          songPassed: songs[index],
                                        )));
                            //_changePlayerViewVisibility(songs);
                          },
                        ),
                      );
                    }));
          },
        ),
      ),
    );
  }

  //define a toast method
  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    ));
  }

  void requestStoragePermission() async {
    //only if the platform is not web, coz web have no permissions
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }

      //ensure build method is called
      setState(() {});
    }
  }

  BoxDecoration getDecoration(
    BoxShape shape,
    Offset offset,
    double blurRadius,
    double spreadRadius,
  ) {
    return BoxDecoration(
      color: bgColor,
      shape: shape,
      boxShadow: [
        BoxShadow(
          offset: -offset,
          color: const Color.fromARGB(125, 168, 208, 230),
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        ),
        BoxShadow(
          offset: offset,
          color: const Color.fromARGB(50, 248, 233, 161),
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        )
      ],
    );
  }
}
