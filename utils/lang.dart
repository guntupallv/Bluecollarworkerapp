// lib/utils/lang.dart
import 'package:flutter/material.dart';

String currentLang(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode.toLowerCase();
  // normalize aliases if needed
  if (code.startsWith('hi')) return 'hi';
  if (code.startsWith('te')) return 'te';
  return 'en';
}
