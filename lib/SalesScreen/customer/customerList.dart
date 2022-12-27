import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/distrChannelList.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/editcustomer.dart';

class CustomerList extends StatefulWidget {
  String channel;
  CustomerList({Key? key, required this.channel}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<int> lists = [];
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
    if (widget.channel == 'TikTok') {
      setState(() {
        widget.channel = 'tiktok';
      });
    }

    return Scaffold(
        bottomNavigationBar: CurvedNavBar(
          indexnum: 3,
        ),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: CustomAppBar(bartitle: 'Customer List'),
          preferredSize: Size.fromHeight(65),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
            stream: FirebaseDatabase.instance
                // ignore: deprecated_member_use
                .reference()
                .child('Customer')
                .orderByChild('channel')
                .equalTo(widget.channel)
                .onValue,
            builder: (context, AsyncSnapshot snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                Map customer = snap.data.snapshot.value;
                List item = [];
                customer.forEach(
                    (index, data) => item.add({"key": index, ...data}));
                return ListView.builder(
                  itemCount: item.length,
                  itemBuilder: (context, index) {
                    final data = item[index];

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
                          title: Text(data!['name']),
                          subtitle: Text(data!['phone']),
                          trailing: Text(
                            '5',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                        
                      ),
                      onTap: (() {
                        Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditCustomerDetailsForm(customerKey: data['key'])));
                      }
                    ));
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
