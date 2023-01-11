import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/model/user_model.dart';
import 'package:ftrsb_mobile/screens/registration_screen.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  List<int> lists = [];
  late Query _ref;
  TextEditingController _searchController = TextEditingController();
  UserModel staff = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    _ref = FirebaseFirestore.instance
        .collection('users')
        .orderBy('role');   
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: (){
        Navigator.push(context,
    MaterialPageRoute(builder: (context) => const RegistrationScreen()),);
      }),
        //bottomNavigationBar: CurvedNavBar(indexnum: 3,),
        backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Staff"),
        centerTitle: true,
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
                              .collection('users')
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
                        
                            return Column(
                              children: [
                                Card(
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12,10,12,10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                            Text(data['name'],
                                                style: TextStyle(
                                                    fontSize: 16,
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
                                              'Email: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 36, 117, 59),
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            SizedBox(width: 3),
                                            Text(data['email'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors
                                                        .grey[600])),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(data['role'],
                                            style: TextStyle(fontStyle:
                                                    FontStyle.italic,
                                                fontSize: 16,
                                                color: Colors
                                                    .grey[600])),
                                        GestureDetector(
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            child: Text('Delete', style: TextStyle(color: Colors.red, fontSize: 16),),
                                          ),
                                          onTap: () {
                                            _showDeleteDialog(data['uid']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              SizedBox(height: 4,)],
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

   _showDeleteDialog(String docid) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete User?'),
            content: Text('Are you sure you want to delete this user? \nYou cannot undo this action'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('users').doc(docid).delete().whenComplete(() =>
                        Navigator.pop(context));
                        Fluttertoast.showToast(msg: 'User successfully deleted', gravity: ToastGravity.CENTER);
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }
}