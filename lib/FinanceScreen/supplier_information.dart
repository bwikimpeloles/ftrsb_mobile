import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'sidebar_navigation.dart';
import 'supplier/add_supplier.dart';
import 'supplier/edit_supplier.dart';

class SupplierInformationFinance extends StatefulWidget {
  @override
  _SupplierInformationFinanceState createState() => _SupplierInformationFinanceState();
}

class _SupplierInformationFinanceState extends State<SupplierInformationFinance> {
  late Query _ref;
  DatabaseReference reference =
  FirebaseDatabase.instance.reference().child('Suppliers');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('Suppliers')
        .orderByChild('companyname');
  }

  Widget _buildSupplierItem({required Map supplier}) {
    return GestureDetector(

      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        height: 200,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 0.5, color: Colors.lightGreen.shade500),
              bottom: BorderSide(width: 0.5, color: Colors.lightGreen.shade500),
            )),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.maps_home_work,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  supplier['companyname'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.phone_iphone,
                  color: Theme.of(context).accentColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  supplier['phonenumber'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
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
                Icon(
                  Icons.map,
                  color: Theme.of(context).accentColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  supplier['shippingaddress'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
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
                Icon(
                  Icons.mail,
                  color: Theme.of(context).accentColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  supplier['email'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
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
                Icon(
                  Icons.account_box,
                  color: Theme.of(context).accentColor,
                  size: 20,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  supplier['pic'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 15),

              ],
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
                SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
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
                  onPressed: () {
                    reference
                        .child(supplier['key'])
                        .remove()
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
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map supplier = snapshot.value as Map;
            supplier['key'] = snapshot.key;
            return _buildSupplierItem(supplier: supplier);
          },
        ),
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