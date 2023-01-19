import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'customer_detail.dart';

class B2C extends StatefulWidget {
  const B2C({Key? key}) : super(key: key);

  @override
  State<B2C> createState() => _B2CState();
}

class _B2CState extends State<B2C> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('OrderB2C')
                      .where('action', isEqualTo: 'Approved')
                      .where('paymentVerify', isEqualTo: 'Received')
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
                                    Text(data['custAddress'])
                                  ],
                                ),
                                leading: Image.asset("assets/Packaging.png"),
                                trailing: Icon(Icons.arrow_forward_rounded),
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
