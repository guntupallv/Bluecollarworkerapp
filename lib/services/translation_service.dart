import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  /// Point this at any LibreTranslate-compatible endpoint you trust.
  /// You can make it configurable via Remote Config / .env if you want.
  static const String _endpoint = 'https://libretranslate.com/translate'; // replace if needed
  static const Duration _timeout = Duration(seconds: 8);

  /// Translate `text` from autodetect to `target` (e.g., 'en','hi','te').
  /// Returns null on failure so callers can gracefully skip.
  static Future<String?> translate({
    required String text,
    required String target,
  }) async {
    if (text.trim().isEmpty) return text;

    try {
      final resp = await http
          .post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'source': 'auto',
          'target': target,
          // 'api_key': 'OPTIONAL', // some instances require a key
          'format': 'text',
        }),
      )
          .timeout(_timeout);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final translated = data['translatedText']?.toString();
        return translated?.isNotEmpty == true ? translated : null;
      }
    } catch (_) {
      // swallow; we’ll just skip translation on error
    }
    return null;
  }

  /// Translate a few fields at once; returns a map of translations for languages.
  static Future<Map<String, dynamic>> translateJobFields({
    required String title,
    required String description,
    required String category,
    List<String> languages = const ['en', 'hi', 'te'], // add more if you support more
  }) async {
    final Map<String, dynamic> translations = {};

    for (final lang in languages) {
      final tTitle = await translate(text: title, target: lang);
      final tDesc  = await translate(text: description, target: lang);
      final tCat   = await translate(text: category, target: lang);

      translations[lang] = {
        'title': tTitle ?? title,
        'description': tDesc ?? description,
        'category': tCat ?? category,
      };
    }
    return translations;
  }
}
