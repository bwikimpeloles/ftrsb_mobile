import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Packaging/b2b.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Packaging/packaged.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Barcode/barcode_scanner.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Packaging/customer_detail.dart';
import 'package:ftrsb_mobile/model/package.dart';

import 'b2c.dart';

class PackageScreenWarehouse extends StatefulWidget {
  const PackageScreenWarehouse({Key? key}) : super(key: key);

  @override
  _PackageScreenWarehouseState createState() => _PackageScreenWarehouseState();
}

enum Menu { b2b, b2c, packaged }

class _PackageScreenWarehouseState extends State<PackageScreenWarehouse> {
  Menu selectedpage = Menu.b2b;

  final PageController _pageController = PageController();

  bool _ispress = false;

  changePage(Menu page, Map<String, dynamic> data) {
    setState(() {
      if (page == Menu.b2b) {
        selectedpage = page;
        _pageController.jumpToPage(0);
      } else if (page == Menu.b2c) {
        selectedpage = page;
        _pageController.jumpToPage(1);
      } else {
        selectedpage = page;
        _pageController.jumpToPage(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(3),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                height: 50.0,
                width: 80,
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                      color: selectedpage == Menu.b2b
                          ? Color.fromARGB(255, 160, 202, 159)
                          : Colors.white,
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(20)),
                    ),
                    child: Center(
                        child: Text(
                      "B2B",
                      style: TextStyle(
                          fontSize: 16,
                          color: selectedpage == Menu.b2b
                              ? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.bold),
                    ))),
              ),
              onTap: () {
                setState(() {
                  selectedpage = Menu.b2b;
                  _pageController.jumpToPage(0);
                  _ispress = !_ispress;
                });
              },
            ),
            GestureDetector(
              child: Container(
                height: 50.0,
                width: 80,
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                      color: selectedpage == Menu.b2c
                          ? Color.fromARGB(255, 160, 202, 159)
                          : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "B2C",
                        style: TextStyle(
                            color: selectedpage == Menu.b2c
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              onTap: () {
                setState(() {
                  selectedpage = Menu.b2c;
                  _pageController.jumpToPage(1);
                  _ispress = !_ispress;
                });
              },
            ),
            GestureDetector(
              child: Container(
                height: 50.0,
                width: 80,
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                        color: selectedpage == Menu.packaged
                            ? Color.fromARGB(255, 160, 202, 159)
                            : Colors.white,
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(20))),
                    child: Center(
                      child: Text(
                        "Packaged",
                        style: TextStyle(
                            color: selectedpage == Menu.packaged
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              onTap: () {
                setState(() {
                  selectedpage = Menu.packaged;
                  _pageController.jumpToPage(2);
                  _ispress = !_ispress;
                });
              },
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 500,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [B2B(), B2C(), packaged()],
          ),
        ),
      ],
    );
  }
}
