import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/add_prospect.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/distrChannelList.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/sales_home.dart';

class CurvedNavBar extends StatelessWidget {

  int indexnum = 0;

  CurvedNavBar({required this.indexnum});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,   //Color.fromARGB(255, 147, 245, 198),
      color: Color.fromARGB(255, 103, 206, 113), 
      animationDuration: Duration(milliseconds: 300),
      //animationCurve: Curves.bounceInOut,

      height: 55,
      index: indexnum,
      items:[
        Icon(Icons.home, size: 25, color: Colors.white,),
        //Icon(Icons.dashboard, size: 20, color: Colors.white,),
        Icon(Icons.assignment_outlined, size: 25, color: Colors.white,),
        Icon(Icons.person_add_rounded, size: 25, color: Colors.white,),
        Icon(Icons.source_rounded, size: 25, color: Colors.white,),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScreenSales()));
        }
        else if (index == 1) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CustomerDetailsForm()));
        }
        else if (index == 2) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProspectDetailsForm()));
        }
        else {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const DistrChannelList()));
        }
      },
    );
  }
}