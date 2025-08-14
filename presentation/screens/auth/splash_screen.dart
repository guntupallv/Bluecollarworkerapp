import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Show dialog only after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLanguageDialog();
    });
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption("English", const Locale('en')),
            _languageOption("हिन्दी", const Locale('hi')),
            _languageOption("తెలుగు", const Locale('te')),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String name, Locale locale) {
    return ListTile(
      title: Text(name),
      onTap: () async {
        Navigator.of(context).pop(); // Close the dialog

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_locale', locale.languageCode);

        if (mounted) {
          // ✅ Use GoRouter to navigate after dialog
          GoRouter.of(context).pushReplacement('/session');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
