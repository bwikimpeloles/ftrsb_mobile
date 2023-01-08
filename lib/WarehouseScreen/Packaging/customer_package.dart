import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Barcode/barcode_scanner.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Packaging/customer_detail.dart';
import 'package:ftrsb_mobile/model/package.dart';

class PackageScreenWarehouse extends StatefulWidget {
  const PackageScreenWarehouse({Key? key}) : super(key: key);

  @override
  _PackageScreenWarehouseState createState() => _PackageScreenWarehouseState();
}

class _PackageScreenWarehouseState extends State<PackageScreenWarehouse> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return ListView.builder(
                itemCount: packageList.length,
                itemBuilder: (context, index) {
                  Package package = packageList[index];
                  return Card(
                    child: ListTile(
                      title: Text(package.name),
                      subtitle: Text(package.status),
                      leading: Image.asset("assets/Packaging.png"),
                      trailing: Icon(Icons.arrow_forward_rounded),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CustomerDetailsScreen(package)));
                      },
                    ),
                  );
                });
          },
        );
      },
    );
  }
}
