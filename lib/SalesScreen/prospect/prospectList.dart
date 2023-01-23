import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/editcustomer.dart';
import 'package:ftrsb_mobile/SalesScreen/prospect/add_prospect.dart';
import 'package:intl/intl.dart';

class ProspectList extends StatefulWidget {
  String channel;
  ProspectList({Key? key, required this.channel}) : super(key: key);

  @override
  State<ProspectList> createState() => _ProspectListState();
}

class _ProspectListState extends State<ProspectList> {
  List<int> lists = [];
  late Query _ref;
  List<List<String>> listprospect = []; 
  //late CollectionReference customerstream;
  //late CollectionReference orderstream;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _ref = FirebaseFirestore.instance
        .collection('Prospect')
        .where('channel', isEqualTo: widget.channel).orderBy('name');
    listprospect = [<String>['Name', 'Phone', 'Email', 'Distribution Channel']];
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProspectDetailsForm(channel: widget.channel),
              ),
            );
            //generateCsv();
            //Fluttertoast.showToast(msg: 'Prospect list was exported');
          },
          label: Text('Add New Prospect'),
          icon: Icon(Icons.add),
        ),
        //bottomNavigationBar: CurvedNavBar(indexnum: 3,),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: CustomAppBar(bartitle: widget.channel),
          preferredSize: Size.fromHeight(65),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      _ref = FirebaseFirestore.instance
                          .collection('Prospect').where('channel', isEqualTo: widget.channel)
                          .orderBy('name')
                          .startAt([text]).endAt([text + '\uf8ff']);
                    });
                  },
                  controller: _searchController,
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                      fillColor: Colors.white30,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.teal)),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _ref.snapshots(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return Column(
                          children: [
                            Text("Total number of prospect: " + snap.data!.docs.length.toString(), style: TextStyle(color: Color.fromARGB(255, 55, 122, 57)),),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snap.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot doc= snap.data!.docs[index];
                                final data = snap.data!.docs[index];
                                var doc_id = snap.data!.docs[index].reference.id;
                                listprospect.add([doc.get('name'), doc.get('phone'), doc.get('email'),doc.get('channel')]);
                
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  elevation: 3,
                                  child: ListTile(
                                    dense: false,
                                    leading: const Icon(
                                      Icons.account_circle,
                                      color: Colors.green,
                                      size: 40,
                                    ),
                                    title: Text(data['name']),
                                    subtitle: Text(data['phone']),
                                    trailing: IconButton(icon: Icon(Icons.delete), color: Colors.red, onPressed: () {
                                      _showDeleteDialog(doc_id);
                                    },)
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else
                        return Center(
                          child: Text('No data found'),
                        );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
  generateCsv() async{
  String csvData = ListToCsvConverter().convert(listprospect);
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);

  Directory generalDownloadDir = Directory('/storage/emulated/0/Download');

  final File file = await (File('${generalDownloadDir.path}/prospectlist_export_$formattedDate.csv').create());

  await file.writeAsString(csvData);

  print(listprospect.toString());
}

 _showDeleteDialog(String? n) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure you want to delete this prospect?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Prospect').doc(n).delete().whenComplete(() =>
                        Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }
}


