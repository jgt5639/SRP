import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:senior_project/screens/song_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
// Make New Function

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  MyHomeScreenState createState() => MyHomeScreenState();
}

class MyHomeScreenState extends State<MyHomeScreen> {
  // define on audio plugin
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List file = [];

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    _listofFiles();
  }

  void _listofFiles() async {
    //Directory? directory = (await getExternalStorageDirectory());
    setState(() {
      //print(
      // "PRINTING HERE MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      //print(file);

      ///data/user/0/com.example.senior_project/app_flutter/audios/
      //file = io.Directory("$directory/audios/").listSync();

      //print(file);
    });
  }

  //Ok Not just need to populate this list with the list of songs
  List<String> SampleList = [
    'heyWIDTH CHECKERRrRRRRRRRRRRRRRRRRRRRRRRRRRRRRRrRRRRRRRRRRRRRRRRRRRRRRRRRRRR',
    "hows",
    'it',
    'going?',
    'hey',
    "hows",
    'it',
    'going?',
    'hey',
    "hows",
    'it',
    'going?',
    'hey',
    "hows",
    'it',
    'going?',
    'hey',
    "hows",
    'it',
    'going?',
    'hey',
    "hows",
    'it',
    'going?'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.zero,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 36, 48, 94),
              Color.fromARGB(255, 55, 71, 133),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const _CustomeAppBar(),
          //Comment out the bottomNavigationBar below this line to make the bottom set of button disappear.
          bottomNavigationBar: const _CustomNavBar(),
          ///////
          body: FutureBuilder<List<SongModel>>(
            //default values
            future: _audioQuery.querySongs(
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.INTERNAL,
              ignoreCase: true,
              //path:
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
              return RawScrollbar(
                thumbVisibility: true,
                thickness: 6,
                thumbColor: Color.fromARGB(255, 247, 108, 108),
                radius: Radius.circular(5),
                crossAxisMargin: 5,
                minThumbLength: 50,
                child: ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        // color: Color.fromARGB(a, r, g, b)
                        margin: const EdgeInsets.only(
                            top: 50.0, left: 25.0, right: 25.0),
                        padding: const EdgeInsets.only(top: 2.0, bottom: 2),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(0, 248, 233, 161),
                          //borderRadius: BorderRadius.circular(20.0),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     blurRadius: 4.0,
                          //     offset: Offset(-4, -4),
                          //     color: Colors.white24,
                          //   ),
                          //   BoxShadow(
                          //     blurRadius: 4.0,
                          //     offset: Offset(4, 4),
                          //     color: Colors.black,
                          //   ),
                          // ],
                        ),

                        child: ListTile(
                          textColor: Color.fromARGB(255, 248, 233, 161),
                          title: Text(item.data![index].title),
                          subtitle: Text(
                            item.data![index].displayName,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 168, 208, 230),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.more_vert,
                            color: Color.fromARGB(255, 248, 233, 161),
                          ),
                          leading: QueryArtworkWidget(
                            id: item.data![index].id,
                            type: ArtworkType.AUDIO,
                          ),
                          onTap: () {
                            //toast message showing he selected song title
                            toast(context,
                                "You Selected:   ${item.data![index].title}");
                          },
                        ),
                      );
                    }),
              );
            },
          ),
        ));
  }

  /*body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            width: MediaQuery.of(context).size.width - 25,
            child: ListView.separated(
              itemCount: SampleList.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(SampleList[index]);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(thickness: 1),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
          ),
          SizedBox(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: "Home",
                    icon: const Icon(Icons.home),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: "Play",
                    icon: const Icon(Icons.play_circle_fill_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SongScreen()),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: "Unknown Files",
                    icon: const Icon(Icons.upload_file_rounded),
                    onPressed: () async {},
                  )
                ]),
          )
        ]),
      
      ),
    );
  }
  */
//define a toast method
  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text((text)),
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
}

class _CustomNavBar extends StatelessWidget {
  const _CustomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 55, 71, 133),
      unselectedItemColor: const Color.fromARGB(255, 247, 108, 108),
      selectedItemColor: const Color.fromARGB(255, 248, 233, 161),
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_fill_outlined),
          label: "Play",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.upload_file_rounded),
          label: "Unknown Files",
        ),
      ],
      //currentIndex: selectedIndex,
      //onTap: onItemTapped,
    );
  }
}

class _CustomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const _CustomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(
          0, 247, 108, 108), //const Color.fromARGB(255, 36, 48, 94),
      elevation: 0,
      leading: const Text(
        'Music Library',
        style: TextStyle(
            color: Color.fromARGB(255, 247, 108, 108),
            fontSize: 18,
            fontFamily: 'Schyler'),
      ),
      actions: <Widget>[
        IconButton(
          color: const Color.fromARGB(255, 248, 233, 161),
          icon: const Icon(Icons.my_library_music_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SongScreen()),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
