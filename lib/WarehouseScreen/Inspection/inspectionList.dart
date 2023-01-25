// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Inspection/inspectionDetail.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Inspection/inspectionForm.dart';
import 'package:ftrsb_mobile/model/product_model.dart';
import 'package:ftrsb_mobile/model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';

class inspectionList extends StatefulWidget {
  const inspectionList({Key? key}) : super(key: key);

  @override
  State<inspectionList> createState() => _inspectionListState();
}

// ignore: camel_case_types
class _inspectionListState extends State<inspectionList> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Inspection')
                  .snapshots(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.centerLeft,
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Product Inspection Report",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  primary: Color.fromARGB(255, 160, 202, 159),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const inspectionForm(),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data = docs[index].data();
                          return Card(
                            margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                            child: ListTile(
                              title: Text(
                                data['desc'],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              subtitle: Text(
                                List.from(data['product']).toString(),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 114, 113, 113)),
                              ),
                              trailing: Icon(Ionicons.clipboard_outline,
                                  color: Color.fromARGB(255, 160, 202, 159)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => inspectionDetail(
                                        title: data['title'],
                                        desc: data['desc'],
                                        inspectedDate: (data['inspectionDate']),
                                        alldata: List.from(data['product']),
                                        imageUrl: data['imageUrl']),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          },
        );
      },
    );
  }
}
