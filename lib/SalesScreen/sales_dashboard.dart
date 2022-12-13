import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';

class SalesDashboard extends StatefulWidget {
  const SalesDashboard({Key? key}) : super(key: key);

  @override
  State<SalesDashboard> createState() => _SalesDashboardState();
}

class _SalesDashboardState extends State<SalesDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavBar(indexnum: 0,),
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text("Sales Dashboard"),
        centerTitle: true,
        
      ),
      body: Center(
        child: SingleChildScrollView(
            child: SafeArea(
          child: Text('Sales Dashboard with the sales analysis will be displayed here'),
        )),
      ),
    );
  }
}
