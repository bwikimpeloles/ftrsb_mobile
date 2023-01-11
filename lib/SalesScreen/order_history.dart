import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';
import 'package:ftrsb_mobile/model/user_model.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<int> lists = [];
  late Query _ref;
  TextEditingController _searchController = TextEditingController();
  UserModel staff = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    _ref = FirebaseFirestore.instance
        .collection('OrderB2C')
        .orderBy('paymentDate', descending: true)
        .limit(100);
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
    } else
      return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //bottomNavigationBar: CurvedNavBar(indexnum: 3,),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: CustomAppBar(bartitle: 'Order History'),
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
                              .collection('OrderB2C')
                              .orderBy('orderID')
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
                          hintText: 'Search by Order ID',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                          prefixIcon: Icon(Icons.search)),
                    ),
                  ),SizedBox(
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
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(data['salesStaff'])
                                .get()
                                .then((value) {
                              this.staff = UserModel.fromMap(value.data());
                            });
                        
                            return Column(
                              children: [
                                Material(
                                  elevation: 4,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 14, 16, 14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Order ID: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Text(data['orderID'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Name: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Text(data['custName'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors
                                                          .grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Phone Number: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Text(data['custPhone'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors
                                                          .grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Address: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Text(data['custAddress'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors
                                                          .grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Payment Date: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                  DateFormat.yMEd()
                                                      .format((data[
                                                                  'paymentDate']
                                                              as Timestamp)
                                                          .toDate())
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors
                                                          .grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Payment Verification: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                  data['paymentVerify']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors
                                                          .grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Channel: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                  getChannel(
                                                      data['channel']),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors
                                                          .grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Submitted by ',
                                                style: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic,
                                                    fontSize: 15,
                                                    color:
                                                        Colors.grey[600]),
                                              ),
                                              Text("${staff.name}",
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 15,
                                                      color: Colors
                                                          .grey[600])),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 10,)],
                            );
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
