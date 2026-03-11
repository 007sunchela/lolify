import 'package:flutter/material.dart';
import 'package:lolify/providers/theme_provider.dart';
import 'package:lolify/themes/light_theme.dart';
import 'package:lolify/widgets/navbar_bottom.dart';
import 'package:provider/provider.dart';

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  State<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  int _selectedIndex = 3;

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) {
        return Scaffold(
          backgroundColor: theme.getTheme.colorScheme.surface,
          body: Center(
            child: SizedBox(
              width: 300,
              height: 150,
              child: Card(
                elevation: 5,
                color: theme.getTheme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Темный режим:',
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.getTheme.colorScheme.onSurface,
                        ),
                      ),
                      Switch(
                        value: theme.getTheme == lightMode ? false : true,
                        onChanged: (bool newValue) {
                          theme.toggleTheme();
                        },
                        activeThumbColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: Colors.grey[300],
                        activeTrackColor: Colors.green[300],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: NavBottom(
            onTabChange: _onTabChanged,
            currentIndex: _selectedIndex,
          ),
        );
      },
    );
  }
}
