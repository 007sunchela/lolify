import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_page1.dart';
import 'intro_page2.dart';
import 'intro_page3.dart';
import 'intro_page4.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final _pageController = PageController();
  bool isFirstLaunch = true;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  // проверка - первый запуск?
  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('first_launch') ?? true;

    if (!firstLaunch) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/memes');
      }
    } else {
      setState(() {
        isFirstLaunch = true;
      });
    }
  }

  // завершить показ заставки 
  Future<void> _completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_launch', false);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/memes');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirstLaunch) {
      return SizedBox.shrink();
    }
    return Scaffold(
      backgroundColor: Colors.deepPurple[500],
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                IntroPage1(),
                IntroPage2(),
                IntroPage3(),
                IntroPage4(),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: 4,
            effect: WormEffect(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentPage != 3)
                  ElevatedButton(
                    onPressed: () {
                      _pageController.jumpToPage(3);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[300],
                    ),
                    child: Text(
                      'Пропустить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 8.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (currentPage == 3)
                  ElevatedButton(
                    onPressed: _completeIntro,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[300],
                    ),
                    child: Text(
                      'Завершить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 8.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
