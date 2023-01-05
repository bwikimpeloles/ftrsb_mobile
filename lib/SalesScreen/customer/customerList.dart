import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/distrChannelList.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/editcustomer.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';

class CustomerList extends StatefulWidget {
  String channel;
  CustomerList({Key? key, required this.channel}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<int> lists = [];
  late String _channel;
  late CollectionReference customerstream = FirebaseFirestore.instance.collection('Customer');
  late CollectionReference orderstream = FirebaseFirestore.instance.collection('OrderB2C');



  @override
  Widget build(BuildContext context) {
    if (widget.channel == 'Shopee') {
      setState(() {
        _channel = 'shopee';
      });
    }
    if (widget.channel == 'WhatsApp') {
      setState(() {
        _channel = 'whatsapp';
      });
    }
    if (widget.channel == 'Website') {
      setState(() {
        _channel = 'website';
      });
    }
    if (widget.channel == 'B2B Retail') {
      setState(() {
        _channel = 'b2b_retail';
      });
    }
    if (widget.channel == 'B2B Hypermarket') {
      setState(() {
        _channel = 'b2b_hypermarket';
      });
    }
    if (widget.channel == 'B2B Hypermarket') {
      setState(() {
        _channel = 'b2b_hypermarket';
      });
    }
    if (widget.channel == 'GrabMart') {
      setState(() {
        _channel = 'grabmart';
      });
    }
    if (widget.channel == 'Other') {
      setState(() {
        _channel = 'other';
      });
    }
    if (widget.channel == 'TikTok') {
      setState(() {
        _channel = 'tiktok';
      });
    }

    late int counter = 0;

    Future<int> getOrderCount(String phone) async {
      var docs = await FirebaseFirestore.instance
          .collection('OrderB2C')
          .where('custPhone', isEqualTo: phone)
          .get();
      int count = docs.size;
      return count;
    }

    return Scaffold(
        //bottomNavigationBar: CurvedNavBar(indexnum: 3,),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: CustomAppBar(bartitle: widget.channel + ' Customer List'),
          preferredSize: Size.fromHeight(65),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: customerstream.where('channel', isEqualTo: _channel).snapshots(),
            builder: (context, snap)  {
              if (snap.hasData)  {
                return ListView.builder(
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (context, index) {
                    final data = snap.data!.docs[index];
                    var doc_id = snap.data!.docs[index].reference.id;
                    //int _count = await getOrderCount(data['phone']);
                   // print(_count);

                    return GestureDetector(
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
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
                            trailing: Text('2',
                              //counter.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                        onTap: (() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditCustomerDetailsForm(
                                  customerKey: doc_id,)));
                        }));
                  },
                );
              }
              return const Center(
                child: SizedBox(child: Text('No data found')),
              );
            },
          ),
        ));
  }
}
