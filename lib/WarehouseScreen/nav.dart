import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ftrsb_mobile/WarehouseScreen/home_warehouse.dart';
import 'package:ftrsb_mobile/model/package.dart';
import 'package:ftrsb_mobile/model/user_model.dart';
import 'package:provider/provider.dart';
import 'Inventory/inventory.dart';
import 'package:ftrsb_mobile/WarehouseScreen/DeliveryTruck/delivery.dart';
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

  Future<UserModel?> getUserModel() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    return UserModel.fromMap(snapshot.data());
  }

  changePage(int index) {
    setState(() {
      currentPageIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: FutureProvider<UserModel?>.value(
            value: getUserModel(),
            initialData: null,
            builder: (context, child) {
              UserModel? user = Provider.of<UserModel?>(context);

              if (user == null) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: SpinKitPulse(
                    color: Color.fromARGB(255, 160, 202, 159),
                  ),
                );
              }

              return PageView(
                controller: _pageController,
                children: [
                  HomeScreenWarehouse(changePage: changePage),
                  InventoryScreenWarehouse(),
                  BarcodeScanner(),
                  PackageScreenWarehouse(),
                  DeliveryListScreen(),
                ],
              );
            }),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: Material(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
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
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.add_box_rounded),
                    label: 'Inventory',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.camera),
                    label: 'Scan',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.people),
                    label: 'Packaging',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.fire_truck),
                    label: 'Delivery',
                  ),
                ],
              ),
            )));
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
