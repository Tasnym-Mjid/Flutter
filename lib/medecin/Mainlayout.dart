import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'MedecinProfileScreen.dart';
import 'MedecinScreen.dart';

class MainLayoutt extends StatefulWidget {
  const MainLayoutt({Key? key}) : super(key: key);

  @override
  State<MainLayoutt> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayoutt> {
  //variable declaration
  int _pageIndex = 0;

  final List<Widget> _pages = [
    MedecinScreen(),
    MedecinProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.blue,
        color: Colors.blue,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white,semanticLabel: 'home',),
          Icon(Icons.account_circle_outlined, size: 26, color: Colors.white,semanticLabel: 'Profile',),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
      body: _pages[_pageIndex],
    );
  }
}