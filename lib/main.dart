import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lolify/pages/favourite_page.dart';
import 'package:lolify/pages/generate_page.dart';
import 'package:lolify/pages/settings_page.dart';
import 'package:lolify/providers/memes_favourite_provider.dart';
import 'package:lolify/providers/meme_generate_provider.dart';
import 'package:lolify/providers/memes_search_provider.dart';
import 'package:lolify/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/meme_page.dart';
import 'intro/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadThemeFromPrefs(),
        ),
        ChangeNotifierProvider(create: (_) => MemesFavouriteProvider()),
        ChangeNotifierProvider(create: (_) => MemeGenerateProvider()),
        ChangeNotifierProvider(create: (_) => MemesSearchProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).getTheme,
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => const IntroPage(),
        '/memes': (context) => const MemePage(),
        '/generate': (context) => const GeneratePage(),
        '/favourite': (context) => const FavouritePage(),
        '/settings': (context) => const MySettingsPage(),
      },
    );
  }
}
