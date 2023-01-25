import 'dart:developer';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Inspection/inspectionList.dart';
import 'package:ftrsb_mobile/WarehouseScreen/home_warehouse.dart';
import 'package:ftrsb_mobile/model/package.dart';
import 'package:ftrsb_mobile/model/user_model.dart';
import 'package:provider/provider.dart';
import 'Inventory/inventory.dart';

import 'Packaging/customer_package.dart';
import '../screens/login_screen.dart';
import 'Barcode/barcode_scanner.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class WarehouseNav extends StatefulWidget {
  const WarehouseNav({Key? key}) : super(key: key);

  @override
  State<WarehouseNav> createState() => _WarehouseNavState();
}

class _WarehouseNavState extends State<WarehouseNav> {
  User? user = FirebaseAuth.instance.currentUser;
  final PageController _pageController = PageController(initialPage: 0);
  int currentPageIndex = 0;

  changePage(int index) {
    setState(() {
      currentPageIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context);
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            "assets/logo.png",
            fit: BoxFit.contain,
            height: 45,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.logout_outlined),
            ),
          ],
          backgroundColor: Color.fromARGB(255, 160, 202, 159),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: [
            HomeScreenWarehouse(changePage: changePage),
            InventoryScreenWarehouse(),
            BarcodeScanner(),
            PackageScreenWarehouse(),
            inspectionList(),
          ],
        ),
        bottomNavigationBar: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          child: NavigationBar(
            height: 60,
            backgroundColor: Color.fromARGB(255, 160, 202, 159),
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
                _pageController.jumpToPage(index);
              });
            },
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Ionicons.home_outline),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Ionicons.cube_outline),
                label: 'Inventory',
              ),
              NavigationDestination(
                icon: Icon(Ionicons.camera_outline),
                label: 'Scan',
              ),
              NavigationDestination(
                icon: Icon(Ionicons.people_outline),
                label: 'Packaging',
              ),
              NavigationDestination(
                icon: Icon(Ionicons.clipboard_outline),
                label: 'Inspection',
              ),
            ],
          ),
        ));
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
