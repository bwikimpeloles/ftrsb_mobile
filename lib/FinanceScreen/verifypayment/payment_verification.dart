import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/user_model.dart';
import '../sidebar_navigation.dart';

class PaymentVerificationFinance extends StatefulWidget {
  @override
  _PaymentVerificationFinanceState createState() => _PaymentVerificationFinanceState();
}

class _PaymentVerificationFinanceState extends State<PaymentVerificationFinance> {
  late Query _ref;
  CollectionReference reference =
  FirebaseFirestore.instance.collection('OrderB2C');
  List<String> filter = ["Unverified","Approved","Rejected"];
  String? selectedValue="Unverified";
  String search='';
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseFirestore.instance.collection('OrderB2C').where('paymentVerify', isEqualTo: "-");

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });

  }

  _showActionDialog({required Map verify}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Verify ${verify['custName']}'),
            content: Text('Select Action:'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.grey),)),
              TextButton(
                  onPressed: () async {
                    await reference
                        .doc(verify['key']).update({
                      'action' : 'Rejected',
                      'paymentVerify' :  loggedInUser.name.toString(),
                    }).whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Reject', style: TextStyle(color: Colors.red),)),
              TextButton(
                  onPressed: () async {
                    await reference
                        .doc(verify['key']).update({
                      'action' : 'Approved',
                      'paymentVerify' : loggedInUser.name.toString(),
                    }).whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Approve', style: TextStyle(color: Colors.green),)),
            ],
          );
        });
  }

  Widget _buildVerifyItem({required Map verify}) {
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
              children: [
                Row(
                  children: [
                    Text('Customer Name: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        verify['custName'],
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
                    Text('Amount: RM',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['amount'],
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
                    Text('Payment Date: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        DateFormat('dd/MM/yyyy').format((verify['paymentDate']as Timestamp).toDate()).toString(),
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
                    Text('Payment Method: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['paymentMethod'],
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
                    Text('Bank Name: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['bankName'],
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
                    Text('Verified by: ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['paymentVerify'],
                      style: TextStyle(
                        color: Colors.blue,
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
                    Text('Order Status: ',
                      style: TextStyle(
                        color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      verify['action'] ?? "-",
                      style: TextStyle(
                          color: Colors.red,
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showActionDialog(verify: verify);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_note,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Action',
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
    if (selectedValue == "Approved") {
      _ref = FirebaseFirestore.instance.collection('OrderB2C').where('channel', isEqualTo: "whatsapp").where('action', isEqualTo: "Approved").orderBy("custName").startAt([search])
          .endAt([search + '\uf8ff']);
      print(selectedValue);
    } else if (selectedValue == "Rejected") {
      _ref = FirebaseFirestore.instance.collection('OrderB2C').where('channel', isEqualTo: "whatsapp").where('action', isEqualTo: "Rejected").orderBy("custName").startAt([search])
          .endAt([search + '\uf8ff']);
      print(selectedValue);
    }
    else{
      _ref = FirebaseFirestore.instance.collection('OrderB2C').where('paymentVerify', isEqualTo: "-").orderBy("custName").startAt([search])
          .endAt([search + '\uf8ff']);
      print(selectedValue);
    }
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text('B2C Order Verification'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10,),
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Center Row contents horizontally,
        crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
        children: [
          Flexible(
            child: SizedBox(
              height: 50,
              width: 200,
              child: TextField(
                onChanged: (text){
                  setState(() {
                    search=text;
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
                    hintText: 'Customer Name',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                    ),
                    prefixIcon: Icon(Icons.search)
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Text("Filter: ", style: TextStyle(fontWeight: FontWeight.bold, height: 0, fontSize: 16),),
              DropdownButton(
                value: selectedValue,
                items: filter.map((item) => DropdownMenuItem<String>(value: item,child: Text(item))).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    selectedValue = newValue!;
                  });
                },

              ),
            ],
          ),
        ],
      ),
          Flexible(
            child: FirestoreAnimatedList(
              query: _ref,
              itemBuilder: (BuildContext context, DocumentSnapshot? snapshot,
                  Animation<double> animation, int index) {
                Map<String, dynamic> verify = snapshot?.data() as Map<String, dynamic>;
                verify['key'] = snapshot?.id;
                return _buildVerifyItem(verify: verify);
              },
            ),
          )],
      ),

    );
  }

}