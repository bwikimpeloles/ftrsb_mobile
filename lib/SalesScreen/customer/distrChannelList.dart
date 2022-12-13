import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/customerList.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';

class DistrChannelList extends StatefulWidget {
  const DistrChannelList({Key? key}) : super(key: key);

  @override
  State<DistrChannelList> createState() => _DistrChannelListState();
}

class _DistrChannelListState extends State<DistrChannelList> {
  @override
  Widget build(BuildContext context) {
    final List<String> channel = <String>[
      'Shopee',
      'WhatsApp',
      'Website',
      'B2B Retail',
      'B2B Hypermarket',
      'GrabMart',
      'Others'
    ];
    final List<Color> color = [Color.fromARGB(255, 204, 125, 7), Colors.green, Colors.lightGreen, Color.fromARGB(255, 59, 138, 177), Color.fromARGB(255, 182, 201, 12), Color.fromARGB(255, 74, 177, 127), Color.fromARGB(255, 161, 92, 173)];

    return Scaffold(
      bottomNavigationBar: CurvedNavBar(indexnum: 3,),
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      appBar: PreferredSize(
          child: AppBar( 
            title: Text('Manage Customer Details'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 103, 206, 113),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(65)),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(25),
              itemCount: channel.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerList(channel: channel[index]),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                      color: color[index],
                      //color: Colors.lightGreen[colorCodes[index]],
                    ),
                    height: 60,
                    child: Center(
                        child: Text(
                      '${channel[index]}',
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          )
        ],
      ),
    );
  }
}
