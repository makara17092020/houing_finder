import 'package:flutter/foundation.dart' show kIsWeb;
// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class AuthService {
  static const String baseUrl = 'https://propertyrentalapi.onrender.com';

  static bool isLoggedIn = false;
  static String? token;

  static void saveToken(String newToken) {
    token = newToken;
    isLoggedIn = true;

    if (kIsWeb) {
      html.document.cookie =
          'accessToken=$newToken; path=/; max-age=604800; SameSite=None; Secure=false';
    }
  }

  static String? getToken() {
    if (token != null) return token;

    if (kIsWeb) {
      final cookies = html.document.cookie ?? '';

      for (var c in cookies.split(';')) {
        final trimmed = c.trim();
        if (trimmed.startsWith('accessToken=')) {
          token = trimmed.substring('accessToken='.length);
          isLoggedIn = true;
          return token;
        }
      }
    }
    return null;
  }

  static void clearToken() {
    token = null;
    isLoggedIn = false;
    if (kIsWeb) {
      html.document.cookie =
          'accessToken=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
    }
  }
}
