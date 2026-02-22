import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color _primary = Color(0xFF0D9488);
  static const Color _surface = Color(0xFFF8FAFC);
  static const Color _surfaceVariant = Color(0xFFF1F5F9);
  static const Color _onSurface = Color(0xFF0F172A);
  static const Color _onSurfaceVariant = Color(0xFF64748B);
  static const Color _sidebarBg = Color(0xFF0F172A);
  static const Color _sidebarSelected = Color(0xFF1E293B);
  static const Color _sidebarHover = Color(0xFF334155);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: _primary,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFCCFBF1),
        surface: _surface,
        onSurface: _onSurface,
        surfaceContainerHighest: _surfaceVariant,
        onSurfaceVariant: _onSurfaceVariant,
        outline: Color(0xFFE2E8F0),
        error: Color(0xFFDC2626),
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _onSurface,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _onSurface,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _onSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: _onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: _onSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        backgroundColor: _surface,
        foregroundColor: _onSurface,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: _onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      scaffoldBackgroundColor: _surface,
    );
  }

  static const Color sidebarBackground = _sidebarBg;
  static const Color sidebarSelected = _sidebarSelected;
  static const Color sidebarHover = _sidebarHover;
  static const Color sidebarForeground = Colors.white;
  static const Color sidebarForegroundMuted = Color(0xFF94A3B8);
}
