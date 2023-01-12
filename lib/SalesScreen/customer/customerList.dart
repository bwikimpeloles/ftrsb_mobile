import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/editcustomer.dart';

class CustomerList extends StatefulWidget {
  String channel;
  CustomerList({Key? key, required this.channel}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<int> lists = [];
  late String _channel = '';
  late Query _ref;
  //late CollectionReference customerstream;
  //late CollectionReference orderstream;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _channel = widget.channel;
    _ref = FirebaseFirestore.instance
        .collection('Customer')
        .where('channel', isEqualTo: _channel).orderBy('name');
  }

    String getChannel(String c) {
    if (c == 'shopee') {
      return 'Shopee';
    } else if (c == 'tiktok') {
      return 'TikTok';
    } else if (c == 'grabmart') {
      return 'GrabMart';
    } else if (c == 'whatsapp') {
      return 'WhatsApp';
    } else if (c == 'other') {
      return 'Other';
    } else if (c == 'website') {
      return 'Website';
    } else if (c == 'b2b_retail') {
      return 'B2B Retail';
    }else if (c == 'b2b_hypermarket') {
      return 'B2B Hypermarket';
    }else
      return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //bottomNavigationBar: CurvedNavBar(indexnum: 3,),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: CustomAppBar(bartitle: getChannel(_channel)),
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
                          .collection('Customer').where('channel', isEqualTo: _channel)
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
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snap.data!.docs.length,
                          itemBuilder: (context, index) {
                            final data = snap.data!.docs[index];
                            var doc_id = snap.data!.docs[index].reference.id;
                
                            return GestureDetector(
                                child:Card(
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
                                    trailing: Text(
                                      data['count'].toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                ),
                                onTap: (() {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditCustomerDetailsForm(
                                                customerKey: doc_id,
                                              )));
                                }));
                          },
                        );
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
