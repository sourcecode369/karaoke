import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/song_cubit.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SongCubit()..loadSongs(),
      child: MaterialApp(
        title: 'Music Player',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey, // Set a primary color for the theme
          primarySwatch:
              Colors.blueGrey, // Define a primary swatch for the theme
          scaffoldBackgroundColor: Color(0xFF121212),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
            subtitle1: TextStyle(
              color: Colors.grey[400],
              fontFamily: 'Poppins',
            ),
            bodyText2: TextStyle(
              color: Colors.white70,
              fontFamily: 'Poppins',
            ),
          ),
          cardColor: Color(0xFF1E1E1E),
          appBarTheme: AppBarTheme(
            color: Color(0xFF212121),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey[700],
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          sliderTheme: SliderThemeData(
            thumbColor: Colors.blueGrey[300],
            activeTrackColor: Colors.blueGrey[600],
            inactiveTrackColor: Colors.grey[800],
            trackHeight: 4.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.grey[900],
            contentTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
            actionTextColor: Colors.blueGrey[300],
          ),
          iconTheme: IconThemeData(
            color: Colors.white70,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: Colors.grey[400]),
            labelStyle: TextStyle(color: Colors.white70),
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch:
                Colors.blueGrey, // Ensure primarySwatch is set to blueGrey
            brightness: Brightness.dark, // Set brightness to dark
            accentColor: Colors.blueGrey[700], // Accent color for widgets
            backgroundColor: Color(0xFF121212), // Background color
          ).copyWith(
            secondary: Colors.blueGrey[700], // Overriding accent color
          ),
        ),
        home: MainScreen(),
      ),
    );
  }
}
