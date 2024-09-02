import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

// Function to load lyrics from a file in assets
Future<String> loadLyrics(String path) async {
  try {
    final lyrics = await rootBundle.loadString(path);
    return lyrics;
  } catch (e) {
    print('Error loading lyrics: $e');
    return '';
  }
}

// Function to parse lyrics into a list of widgets for display
List<Widget> parseLyrics(String lyrics) {
  final lines = lyrics.split('\n');
  final parsedLines = <Widget>[];

  for (final line in lines) {
    final parts = line.split(']');
    if (parts.length > 1) {
      final lyricText = parts[1].trim();
      if (lyricText.isNotEmpty) {
        parsedLines.add(
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 4.0), // Space between lines
            child: Text(
              lyricText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400, // Adjust font weight
                letterSpacing: 0.5, // Slight spacing between letters
                overflow: TextOverflow.ellipsis, // Handle long lines
              ),
              maxLines: 2, // Limit to two lines if necessary
            ),
          ),
        );
      }
    }
  }

  return parsedLines;
}

// Function to format the LRC timestamp into a Duration object
Duration parseTimestamp(String timestamp) {
  final parts = timestamp.split(':');
  final minutes = int.tryParse(parts[0]) ?? 0;
  final secondsAndMilliseconds = parts[1].split('.');
  final seconds = int.tryParse(secondsAndMilliseconds[0]) ?? 0;
  final milliseconds = int.tryParse(secondsAndMilliseconds[1] ?? '0') ?? 0;

  return Duration(
      minutes: minutes, seconds: seconds, milliseconds: milliseconds);
}
