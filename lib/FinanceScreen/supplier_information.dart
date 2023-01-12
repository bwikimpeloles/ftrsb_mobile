import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';

import 'sidebar_navigation.dart';
import 'supplier/add_supplier.dart';
import 'supplier/edit_supplier.dart';
import 'supplier/photo_page.dart';

class SupplierInformationFinance extends StatefulWidget {
  @override
  _SupplierInformationFinanceState createState() => _SupplierInformationFinanceState();
}

class _SupplierInformationFinanceState extends State<SupplierInformationFinance> {
  late Query _ref;
  CollectionReference reference =
  FirebaseFirestore.instance.collection('Suppliers');
  TextEditingController _searchController= TextEditingController();
  String search='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseFirestore.instance.collection('Suppliers').orderBy('companyname');

  }


  Widget _buildSupplierItem({required Map supplier}) {
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
                    Text('Company Name: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        supplier['companyname'],
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
                    Text('Phone No: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      supplier['phonenumber'],
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
                    Text('Address: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        supplier['shippingaddress'],
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
                    Text('Email: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      supplier['email'],
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
                    Text('PIC: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      supplier['pic'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => PhotoPage(supplierKey: supplier['key'],),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.teal,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('DO',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditSupplier(
                                  supplierKey: supplier['key'],
                                )));
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
                        _showDeleteDialog(supplier: supplier);
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

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDeleteDialog({required Map supplier}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${supplier['companyname']}'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () async {

          await FirebaseStorage.instance.ref('doimages/${supplier['key']}').listAll().then((value) {
          value.items.forEach((element) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
          });});

          await FirebaseFirestore.instance.collection('details').where('supplierkey', isEqualTo: supplier['key']).get()
              .then((snapshot) async {
            for(DocumentSnapshot ds in snapshot.docs) {
              await ds.reference.delete();
              print(ds.reference);
            }
          });
                    reference
                        .doc(supplier['key']).delete()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text('Supplier Information'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                onChanged: (text){
                  setState(() {
                    _ref = FirebaseFirestore.instance.collection('Suppliers').orderBy('companyname').startAt([text])
                        .endAt([text + '\uf8ff']);
                  });

                },
                controller: _searchController,
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                    fillColor: Colors.white30,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.teal)
                    ),
                    hintText: 'Search Company Name',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 18
                    ),
                    prefixIcon: Icon(Icons.search)
                ),
              ),
            ),
          Flexible(
            child: SizedBox(
              child: FirestoreAnimatedList(
                query: _ref,
                itemBuilder: (BuildContext context, DocumentSnapshot? snapshot,
                    Animation<double> animation, int index) {
                  Map<String, dynamic> supplier = snapshot?.data() as Map<String, dynamic>;
                  print(snapshot.toString());
                  supplier?['key'] = snapshot?.id;
                  return _buildSupplierItem(supplier: supplier!);
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
              return AddSupplier();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }


}