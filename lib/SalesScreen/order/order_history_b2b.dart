import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:intl/intl.dart';

class OrderHistoryB2B extends StatefulWidget {
  const OrderHistoryB2B({Key? key}) : super(key: key);

  @override
  State<OrderHistoryB2B> createState() => _OrderHistoryB2BState();
}

class _OrderHistoryB2BState extends State<OrderHistoryB2B> {
  List<int> lists = [];
  late Query _ref;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _ref = FirebaseFirestore.instance
        .collection('OrderB2B')
        .orderBy('orderDate', descending: true)
        .limit(100);
  }

  String getChannel(String c) {
    if (c == 'b2b_retail') {
      return 'B2B Retail';
    } else if (c == 'b2b_hypermarket') {
      return 'B2B Hypermarket';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavBar(
          indexnum: 1,
        ),
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
                          .collection('OrderB2B')
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
                            DocumentSnapshot data = snap.data!.docs[index];
                            return Column(
                              children: [
                                Material(
                                  elevation: 4,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                                      color: Colors.grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Company Name: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Expanded(
                                                child: Text(data['custName'],
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 3,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Colors.grey[600])),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'PIC: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Expanded(
                                                child: Text(data['pic'],
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 3,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Colors.grey[600])),
                                              ),
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
                                                      color: Colors.grey[600])),
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
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 3),
                                              Expanded(
                                                child: Text(data['custAddress'],
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 3,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Colors.grey[600])),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Order Date: ',
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
                                                      .format((data['orderDate']
                                                              as Timestamp)
                                                          .toDate())
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Order Collection Date: ',
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
                                                      .format(
                                                          (data['collectionDate']
                                                                  as Timestamp)
                                                              .toDate())
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Payment Status: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                  data['paymentStatus']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Channel: ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 36, 117, 59),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 3),
                                              Text(getChannel(data['channel']),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[600])),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(data['salesStaff'])
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  DocumentSnapshot? sn =
                                                      snapshot.data;

                                                  return Row(
                                                    children: [
                                                      Text(
                                                        'Submitted by ',
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 15,
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            sn!['name']
                                                                .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            maxLines: 2,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 15,
                                                                color:
                                                                    Colors.grey[
                                                                        600])),
                                                      ),
                                                    ],
                                                  );
                                                } else
                                                  return CircularProgressIndicator();
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          },
                        );
                      } else
                        return Center(
                          child: LinearProgressIndicator(),
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
