import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/FinanceScreen/cost/add_cost.dart';
import 'package:ftrsb_mobile/FinanceScreen/cost/edit_cost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ftrsb_mobile/FinanceScreen/cost/list_category.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';

class ListCostFinance extends StatefulWidget {
  @override
  _ListCostFinanceState createState() => _ListCostFinanceState();
}

class _ListCostFinanceState extends State<ListCostFinance> {
  late Query _ref;
  CollectionReference reference =
  FirebaseFirestore.instance.collection('Cost');
  var selectedCategory;
  List<List<String>> listCost = [];
  String? filePath;
  List<List<dynamic>> _data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseFirestore.instance.collection('Cost')
        .orderBy('name');

  }

  generateCsv() async{
    String csvData = ListToCsvConverter().convert(listCost);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);

    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');

    final File file = await (File('${generalDownloadDir.path}/expenses_export_$formattedDate.csv').create());

    await file.writeAsString(csvData).then((value) => OpenFile.open('${generalDownloadDir.path}/expenses_export_$formattedDate.csv'));

    print(listCost.toString());
  }

  queryValues() async {
    listCost.clear();
    listCost = [<String>['Name', 'Category', 'Amount', 'Supplier', 'Date', 'Reference No. (Bank/PO/Invoice/Receipt)', 'Payment Type']];
    CollectionReference _documentRef=FirebaseFirestore.instance.collection("Cost");
    await _documentRef.get().then((ds){
      if(ds!=null){
        ds.docs.forEach((a){
          final dynamic cost = a.data();
          listCost.add([cost['name']??"", cost['category']??"", cost['amount']??"",cost['supplier']??"",DateFormat('dd/MM/yyyy').format((cost['date'] as Timestamp).toDate())??"", cost['referenceno']?? '', cost['paymenttype'] ?? '']);
        });
      } else{
        print('fail');

      }
    });
  }

  // void _pickFile() async {
  //
  //   final result = await FilePicker.platform.pickFiles(allowMultiple: false);
  //
  //   // if no file is picked
  //   if (result == null) return;
  //   // we will log the name, size and path of the
  //   // first picked file (if multiple are selected)
  //   print(result.files.first.name);
  //   filePath = result.files.first.path!;
  //
  //   final input = File(filePath!).openRead();
  //   final fields = await input
  //       .transform(utf8.decoder)
  //       .transform(const CsvToListConverter())
  //       .toList();
  //   print(fields);
  //
  //   setState(() {
  //     _data = fields;
  //   });
  // }


  _showDeleteDialog({required Map cost}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${cost['name']??""}'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Cost').doc(cost['key']).delete().whenComplete(() => Navigator.pop(context));;
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  Widget _buildCostItem({required Map cost}) {
    //listCost.add([cost['name'], cost['category'], cost['amount'],cost['supplier']??"-",DateFormat('dd/MM/yyyy').format((cost['date'] as Timestamp).toDate()), cost['referenceno'], cost['paymenttype'] ?? '-']);
    //'Name', 'Category', 'Amount', 'Supplier', 'Date', 'Reference No. (Bank/PO/Invoice/Receipt)', 'Payment Type'
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(10),

          decoration: new BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              gradient: new LinearGradient(colors: [Colors.white70, Colors.white],
                  begin: Alignment.centerLeft, end: Alignment.centerRight, tileMode: TileMode.clamp)
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Expenses Name: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        cost['name']??"",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Category: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      cost['category']??"",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Amount: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        cost['amount']??"",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Supplier: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        cost['supplier']??"-",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Date: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                          (cost['date']!=null)?DateFormat('dd/MM/yyyy').format((cost['date'] as Timestamp).toDate()):"",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Payment Type: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        cost['paymenttype'] ?? '-',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Reference No.: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        cost['referenceno']??"",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditCost(costKey: cost['key'],)));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Edit',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showDeleteDialog(cost: cost);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red[700],
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Delete',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses Information'),
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Manage Category"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Export CSV"),
                  ),
                  // PopupMenuItem<int>(
                  //   value: 2,
                  //   child: Text("Import CSV"),
                  // ),

                ];
              },
              onSelected:(value) async{
                if(value == 0){
                  print("Popup menu");
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) {
                      return ListCategory();
                    }),
                  ).then((value) => setState(() {}));

                } else if(value == 1){
                  print("Popup menu CSV");
                  //await checkEmptyList();
                  await queryValues();

                  await generateCsv();
                  Fluttertoast.showToast(msg: 'Expenses list was exported');
                }
                // else if(value == 2){
                //   print("Import CSV");
                //   //await checkEmptyList();
                //   _pickFile();
                //   Fluttertoast.showToast(msg: 'Expenses list was imported');
                // }
              }
          ),
          ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          SizedBox(
            height: 40,
            width: 200,
            child: TextField(
              onChanged: (text){
                setState(() {
                  _ref = FirebaseFirestore.instance.collection('Cost').where('category', isEqualTo: selectedCategory).orderBy('name').startAt([text])
                      .endAt([text + '\uf8ff']);
                });

              },
              cursorColor: Colors.teal,
              decoration: InputDecoration(
                  fillColor: Colors.white30,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.teal)
                  ),
                  hintText: 'Name',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 18
                  ),
                  prefixIcon: Icon(Icons.search)
              ),
            ),
          ),
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Category").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Text("Loading.....");
                else {
                  List<DropdownMenuItem> categoryItems = [];
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    DocumentSnapshot snap = snapshot.data!.docs[i];
                    categoryItems.add(
                      DropdownMenuItem(
                        child: Text(
                          snap['category'],
                        ),
                        value: "${snap['category']}",
                      ),
                    );
                  }
                  return SizedBox(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: DropdownButtonFormField<dynamic>(
                            validator: (value) => value == null ? "Category" : null,
                            items: categoryItems,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onChanged: (categoryValue) {
                              setState(() {
                                selectedCategory = categoryValue;
                                _ref = FirebaseFirestore.instance.collection('Cost').where('category', isEqualTo: selectedCategory).orderBy('name');
                              });
                            },
                            value: selectedCategory,
                            hint: new Text(
                              "Category",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
          Flexible(
            child: SizedBox(
              height: double.infinity,
              child: FirestoreAnimatedList(
                query: _ref,
                itemBuilder: (BuildContext context, DocumentSnapshot? snapshot,
                    Animation<double> animation, int index) {
                  Map<String, dynamic> cost = snapshot?.data() as Map<String, dynamic>;
                  //listCost.add([cost['name'], cost['category'], cost['amount'],cost['supplier']??"-",DateFormat('dd/MM/yyyy').format((cost['date'] as Timestamp).toDate()), cost['referenceno'], cost['paymenttype'] ?? '-']);
                  cost['key'] = snapshot?.id;
                  return _buildCostItem(cost: cost);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return AddCost();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }


}