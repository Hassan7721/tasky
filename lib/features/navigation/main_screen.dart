import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:tasky/features/tasks/Completed_tasks_screen.dart';
import 'package:tasky/features/home/home_screen.dart';
import 'package:tasky/features/profile/profile_screen.dart';
import 'package:tasky/features/tasks/tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

final List<Widget> _screen = [
  HomeScreen(),
  TasksScreen(),
  CompletedTasksScreen(),
  ProfileScreen(),
];

int _currentIndex = 0;

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int? index) {
          setState(() {
            _currentIndex = index ?? 0;
          });
          print(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildSvgPicture("assets/images/home.svg", 0),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture("assets/images/todoT.svg", 1),
            label: "To Do",
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture("assets/images/compet.svg", 2),
            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture("assets/images/profile.svg", 3),
            label: "Profile",
          ),
        ],
      ),
      body: SafeArea(child: _screen[_currentIndex]),
    );
  }

  SvgPicture _buildSvgPicture(String path, int index) => SvgPicture.asset(
    path,
    colorFilter: ColorFilter.mode(
      _currentIndex == index
          ? const Color(0xFF15B86C)
          : const Color(0xFFC6C6C6),
      BlendMode.srcIn,
    ),
  );
}
