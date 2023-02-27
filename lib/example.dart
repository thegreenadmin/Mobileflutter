import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _selectedTab = 0;
  final _pageOptions = [
    Text('Item 1'),
    Text('Item 2'),
    Text('Item 3'),
    Text('Item 4'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xffFF5555),
      ),
      home: Scaffold(
        body: _pageOptions[_selectedTab],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 2.0,
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 2.0,
          shape: CircularNotchedRectangle(),
          child: SizedBox(
            height: 80,
            child: Theme(
              data: Theme.of(context).copyWith(
                  // sets the background color of the `BottomNavigationBar`
                  canvasColor: Color(0xff1B213B),

                  // sets the active color of the `BottomNavigationBar` if `Brightness` is light
                  primaryColor: Color(0xffFF5555),
                  textTheme: Theme.of(context)
                      .textTheme
                      .copyWith(caption: new TextStyle(color: Colors.white))),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedTab,
                onTap: (int index) {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                fixedColor: Color(0xffFF5555),
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.tv), label: ""),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.card_membership), label: ""),
                  BottomNavigationBarItem(icon: Icon(Icons.share), label: ""),
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
