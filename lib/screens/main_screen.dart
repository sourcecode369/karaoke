import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/song.dart';
import '../cubit/song_cubit.dart';
import 'player_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karaoke App'),
        backgroundColor: Colors.black, // Dark AppBar color
        elevation: 0,
      ),
      body: BlocBuilder<SongCubit, List<Song>>(
        builder: (context, songs) {
          if (songs.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          // Assuming the first song is the popular one
          final popularSong = songs[0];
          final otherSongs = songs.sublist(1);

          return Container(
            color: Colors.black, // Dark background color
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Popular Song Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                PlayerScreen(song: popularSong),
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  popularSong.albumArt,
                                  height:
                                      250, // Increased height for better visibility
                                  width: MediaQuery.of(context)
                                      .size
                                      .width, // Full width
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      popularSong.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      popularSong.artist,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                            color: Colors.grey[400],
                                            fontSize: 16,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          icon: Icon(Icons.play_arrow,
                              size: 50, color: Colors.white), // Increased size
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PlayerScreen(song: popularSong),
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Other Songs',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: otherSongs.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey[800], // Divider color
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final song = otherSongs[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            song.albumArt,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        title: Text(
                          song.title,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          song.artist,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.play_arrow, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlayerScreen(song: song),
                            ));
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    PlayerScreen(song: song),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ));
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
