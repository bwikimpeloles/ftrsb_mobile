import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Customer List"),
          centerTitle: true,
        ),
        body: StreamBuilder(
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
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      dense: false,
                      leading: const Icon(
                        Icons.account_circle,
                        color: Colors.green,
                        size: 40,
                      ),
                      title: Text(data!['name']),
                      subtitle: Text(data['phone']),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
