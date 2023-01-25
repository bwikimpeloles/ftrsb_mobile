import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import 'customer_detail.dart';

class B2B extends StatefulWidget {
  const B2B({Key? key}) : super(key: key);

  @override
  State<B2B> createState() => _B2BState();
}

String formatTimestamp(Timestamp timestamp) {
  var format = new DateFormat.yMMMMEEEEd(); // <- use skeleton here
  return format.format(timestamp.toDate());
}

class _B2BState extends State<B2B> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('OrderB2B')
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
                                title: Text(data['custName'].toString()),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['custPhone']),
                                    Text(formatTimestamp(data['orderDate']))
                                  ],
                                ),
                                leading: Image.asset("assets/Packaging.png"),
                                trailing: Icon(
                                  Ionicons.cube_sharp,
                                  color: Color.fromARGB(255, 160, 202, 159),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerDetailsScreen(
                                                title:
                                                    data['custName'].toString(),
                                                desc: data['custPhone']
                                                    .toString(),
                                                adres: data['custAddress']
                                                    .toString(),
                                                alldata:
                                                    List.from(data['product']),
                                              )));
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
