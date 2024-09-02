class Song {
  final String title;
  final String artist;
  final String filePath;
  final String albumArt;
  final String lyricsPath; // Path to the LRC file

  Song({
    required this.title,
    required this.artist,
    required this.filePath,
    required this.albumArt,
    required this.lyricsPath, // Initialize this field
  });
}
