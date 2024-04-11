import 'package:flutter/material.dart';
import 'package:flutterapp/screens/homescreen.dart';

import 'finishedtitlesscreen.dart';

class allscreen extends StatefulWidget {
  const allscreen({
    super.key});

  @override
  State<allscreen> createState() => _allscreenState();
}

class _allscreenState extends State<allscreen> {
  int _selectedIndex = 0;
  
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
      
      //Allows swiping between screens
      body: PageView(                  
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
        },
        children: [
          mainScreen(),
          finishedTitlesScreen(),
          
        ],
      ),

      //Bottom nav bar for the 2 screens
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[850],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Add a state variable to track the selected index
          });
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
        items: const [
          
          //First screen
          BottomNavigationBarItem(
            icon: Icon(Icons.source),
            label: 'Titles Due',
          ),

          //Second screen
          BottomNavigationBarItem(
            icon: Icon(Icons.file_download_done),
            label: 'Finished Titles',
          ),
        ],
      ),
      ),
    );
  }
}