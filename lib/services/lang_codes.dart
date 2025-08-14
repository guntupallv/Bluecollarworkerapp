class LangCodes {
  // Map your app locales to ML Kit BCP-47 codes
  static String fromLocale(String localeCode) {
    switch (localeCode) {
      case 'hi': // Hindi
        return 'hi';
      case 'te': // Telugu
        return 'te';
      default: // English
        return 'en';
    }
  }
}
