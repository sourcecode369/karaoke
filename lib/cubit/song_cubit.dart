import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/song.dart';

class SongCubit extends Cubit<List<Song>> {
  SongCubit() : super([]);
  // - assets/lyrics/Skyfall.lrc
  //   - assets/lyrics/BlindingLights.lrc
  //   - assets/lyrics/Levitating.lrc
  //   - assets/lyrics/Shapeofyou.lrc
  //   - assets/lyrics/Watermelonsugar.lrc
  //   - assets/lyrics/Flowers.lrc
  void loadSongs() {
    final songs = [
      Song(
          title: 'Adele - Skyfall',
          artist: 'Adele',
          filePath: 'music/Adele_Skyfall.mp3',
          albumArt: 'assets/album/skyfall.jpg',
          lyricsPath: 'assets/lyrics/Skyfall.lrc'),
      Song(
          title: 'Dua Lipa - Levitating',
          artist: 'Dua Lipa',
          filePath: 'music/DuaLipa-Levitating.mp3',
          albumArt: 'assets/album/levitating.jpg',
          lyricsPath: 'assets/lyrics/Levitating.lrc'),
      Song(
          title: 'Ed Sheeran - Shape of You',
          artist: 'Ed Sheeran',
          filePath: 'music/EdSheeran-ShapeOfYou.mp3',
          albumArt: 'assets/album/shapeofyou.jpg',
          lyricsPath: 'assets/lyrics/Shapeofyou.lrc'),
      Song(
          title: 'Harry Styles - Watermelon Sugar',
          artist: 'Harry Styles',
          filePath: 'music/HarryStyle-WatermelonSugar.mp3',
          albumArt: 'assets/album/watermelonsugar.jpg',
          lyricsPath: 'assets/lyrics/Watermelonsugar.lrc'),
      Song(
          title: 'Miley Cyrus - Flowers',
          artist: 'Miley Cyrus',
          filePath: 'music/MileyCyrus-Flowers.mp3',
          albumArt: 'assets/album/flowers.jpg',
          lyricsPath: 'assets/lyrics/Flowers.lrc'),
      Song(
          title: 'The Weeknd - Blinding Lights',
          artist: 'The Weeknd',
          filePath: 'music/TheWeekend-BlindingLights.mp3',
          albumArt: 'assets/album/blindinglights.jpg',
          lyricsPath:
              'assets/lyrics/BlindingLights.lrc' // Make sure this file exists
          ),
    ];

    emit(songs);
  }
}
