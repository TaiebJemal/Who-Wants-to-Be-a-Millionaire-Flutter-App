import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final BuildContext context;

  const CustomBottomNavBar({Key? key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Color(0xFF004684),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.search, size: 30),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: Icon(Icons.work, size: 30),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/list-career-opportunities');
            },
          ),
          IconButton(
            icon: Icon(Icons.event, size: 30),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/list-events');
            },
          ),
          IconButton(
            icon: Icon(Icons.message, size: 30),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/messages');
            },
          ),
        ],
      ),
    );
  }
}