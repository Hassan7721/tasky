import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/service/preferences_manager.dart';
import 'package:tasky/core/theme/dark_theme.dart';
import 'package:tasky/core/theme/light_theme.dart';
import 'package:tasky/core/theme/theme_controller.dart';
//import 'package:tasky/home_screen.dart';
import 'package:tasky/screen/main_screen.dart';
import 'package:tasky/screen/welcome_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // pref.clear();// لو عايز ارجع لنقطة الصفر we change this line
  // PreferencesManager().clear();
   
  await PreferencesManager().init();
  ThemeController().init();

  String? username = PreferencesManager().getString("username");
  //  final pref = await SharedPreferences.getInstance();
  //  String? username = pref.getString("username");

  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.username});
  final String? username;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, ThemeMode themeMode, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tasky a',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: username == null ? WelcomeScreen() : MainScreen(),
        );
      },
    );
  }
  
}
