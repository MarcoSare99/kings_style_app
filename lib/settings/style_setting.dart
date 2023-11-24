import 'package:flutter/material.dart';

class MyThemes {
  static final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: "PopPins",
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF1F1A1D)),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCA5A57)),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
            borderRadius: BorderRadius.circular(20)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
            borderRadius: BorderRadius.circular(20)),
        hintStyle: const TextStyle(color: Color(0xFF1F1A1D)),
        labelStyle: const TextStyle(
          color: Color(0xFF1F1A1D),
        ),
      ),
      textTheme: const TextTheme(displayLarge: TextStyle(color: Colors.amber)));

  static final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      fontFamily: "PopPins",
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFEAE0E3)),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFFB3AE)),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF690005)),
            borderRadius: BorderRadius.circular(20)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF690005)),
            borderRadius: BorderRadius.circular(20)),
        hintStyle: const TextStyle(color: Color(0xFFEAE0E3)),
        labelStyle: const TextStyle(
          color: Color(0xFFEAE0E3),
        ),
      ),
      textTheme: const TextTheme(displayLarge: TextStyle(color: Colors.amber)));
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFCA5A57),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFDAD7),
  onPrimaryContainer: Color(0xFF410004),
  secondary: Color(0xFF735C00),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFE088),
  onSecondaryContainer: Color(0xFF241A00),
  tertiary: Color(0xFF686000),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFF3E569),
  onTertiaryContainer: Color(0xFF1F1C00),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF221B00),
  surface: Color(0xFFFFFBFF),
  onSurface: Color(0xFF221B00),
  surfaceVariant: Color(0xFFF5DDDB),
  onSurfaceVariant: Color(0xFF534342),
  outline: Color(0xFF857371),
  onInverseSurface: Color(0xFFFFF0C0),
  inverseSurface: Color(0xFF3A3000),
  inversePrimary: Color(0xFFFFB3AE),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFA03E3B),
  outlineVariant: Color(0xFFD8C2C0),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFB3AE),
  onPrimary: Color(0xFF621013),
  primaryContainer: Color(0xFF812726),
  onPrimaryContainer: Color(0xFFFFDAD7),
  secondary: Color(0xFFE7BDB9),
  onSecondary: Color(0xFF442928),
  secondaryContainer: Color(0xFF5D3F3D),
  onSecondaryContainer: Color(0xFFFFDAD7),
  tertiary: Color(0xFFE2C28C),
  onTertiary: Color(0xFF402D04),
  tertiaryContainer: Color(0xFFFBDE8E),
  onTertiaryContainer: Color(0xFFFFDEA7),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF201A1A),
  onBackground: Color(0xFFEDE0DE),
  surface: Color(0xFF201A1A),
  onSurface: Color(0xFFEDE0DE),
  surfaceVariant: Color(0xFF534342),
  onSurfaceVariant: Color(0xFFD8C2C0),
  outline: Color(0xFFA08C8B),
  onInverseSurface: Color(0xFF201A1A),
  inverseSurface: Color(0xFFEDE0DE),
  inversePrimary: Color(0xFFA03E3B),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFFB3AE),
  outlineVariant: Color(0xFF534342),
  scrim: Color(0xFF000000),
);
