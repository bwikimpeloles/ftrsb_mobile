import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/SalesScreen/channel/add_channel.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';

class ListChannel extends StatefulWidget {
  const ListChannel({Key? key}) : super(key: key);

  @override
  State<ListChannel> createState() => _ListChannelState();
}

class _ListChannelState extends State<ListChannel> {
  late Query _ref;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _ref = FirebaseFirestore.instance.collection('Channel').orderBy('channel');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddChannel()))),
        backgroundColor: Colors.white,
        drawer: NavigationDrawer(),
        appBar: PreferredSize(
          child: CustomAppBar(bartitle: 'Channel'),
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
                          .collection('Channel')
                          .orderBy('channel')
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

                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 5),
                              elevation: 3,
                              child: ListTile(
                                dense: false,
                                title: Text(data['channel']),
                                subtitle: Text(data['type']),
                                trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: () {  
                                  _showDeleteDialog(data['channel']);   
                                },),
                              ),
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

  _showDeleteDialog(String? n) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure you want to delete this channel?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Channel').doc(n).delete().whenComplete(() =>
                        Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

}
