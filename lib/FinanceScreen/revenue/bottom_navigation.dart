import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'revenue.dart';
import 'revenue2.dart';

class FinanceCurvedNavBar extends StatelessWidget {

  int indexnum = 0;

  FinanceCurvedNavBar({required this.indexnum});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,   //Color.fromARGB(255, 147, 245, 198),
      color: Colors.black54,
      //animationCurve: Curves.bounceInOut,
      height: 55,
      index: indexnum,
      items:[
        Text('B2C', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        Text('B2B', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => RevenueFinance(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
        else {
          Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Revenue2Finance(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        }
      },
    );
  }
}