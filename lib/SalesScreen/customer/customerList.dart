import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';

class CustomerList extends StatefulWidget {
  String channel;
  CustomerList({Key? key, required this.channel}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  @override
  Widget build(BuildContext context) {
    if (widget.channel == 'Shopee') {
      setState(() {
        widget.channel = 'shopee';
      });
    }
    if (widget.channel == 'WhatsApp') {
      setState(() {
        widget.channel = 'whatsapp';
      });
    }
    if (widget.channel == 'Website') {
      setState(() {
        widget.channel = 'website';
      });
    }
    if (widget.channel == 'B2B Retail') {
      setState(() {
        widget.channel = 'b2b_retail';
      });
    }
    if (widget.channel == 'B2B Hypermarket') {
      setState(() {
        widget.channel = 'b2b_hypermarket';
      });
    }
    if (widget.channel == 'B2B Hypermarket') {
      setState(() {
        widget.channel = 'b2b_hypermarket';
      });
    }
    if (widget.channel == 'GrabMart') {
      setState(() {
        widget.channel = 'grabmart';
      });
    }
    if (widget.channel == 'Other') {
      setState(() {
        widget.channel = 'other';
      });
    }

    return Scaffold(
      bottomNavigationBar: CurvedNavBar(indexnum: 3,),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Customer List'),
        preferredSize: Size.fromHeight(65),
      ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('customer')
                .where("channel",
                    isEqualTo: widget.channel)
                .snapshots(),
                
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final data = streamSnapshot.data?.docs[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 3,
                      child: ListTile(
                        dense: false,
                        leading: const Icon(
                          Icons.account_circle,
                          color: Colors.green,
                          size: 40,
                        ),
                        title: Text(data!['name']),
                        subtitle: Text(data['phone']),
                        trailing: Text('5', style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }
}
