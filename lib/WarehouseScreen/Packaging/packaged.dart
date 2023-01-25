import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Packaging/package_detail.dart';
import 'package:ionicons/ionicons.dart';

import 'customer_detail.dart';

class packaged extends StatefulWidget {
  const packaged({Key? key}) : super(key: key);

  @override
  State<packaged> createState() => _packagedState();
}

class _packagedState extends State<packaged> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('Package')
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error = ${snapshot.error}');

                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data();
                            return Card(
                              child: ListTile(
                                title: Text(data['name'].toString()),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['telNo']),
                                    Text(data['packageDate'])
                                  ],
                                ),
                                leading:
                                    Image.asset("assets/PackagingDone.png"),
                                trailing: Icon(
                                  Ionicons.information_circle_outline,
                                  color: Color.fromARGB(255, 160, 202, 159),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PackageDetail(
                                              name: data['name'].toString(),
                                              telNo: data['telNo'].toString(),
                                              address:
                                                  data['address'].toString(),
                                              alldata:
                                                  List.from(data['product']),
                                              imageUrl: data['imageUrl'],
                                              packageDate:
                                                  data['packageDate'])));
                                },
                              ),
                            );
                          });
                    }
                    ;
                    return Center(child: CircularProgressIndicator());
                  });
            });
      },
    );
  }
}
