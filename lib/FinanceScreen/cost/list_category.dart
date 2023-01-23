import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';

import 'add_category.dart';
import 'edit_category.dart';

class ListCategory extends StatefulWidget {
  @override
  _ListCategoryState createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory> {
  late Query _ref;
  CollectionReference reference =
  FirebaseFirestore.instance.collection('Category');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseFirestore.instance.collection('Category');

  }

  _showDeleteDialog({required Map category}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${category['category']}'),
            content: SizedBox(
              height: 110,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Are you sure you want to delete?\n',),
                    Text('Warning: Deleting will caused all items under this category to be deleted.', style: TextStyle(color: Colors.red),),


                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () async {

                    await FirebaseFirestore.instance.collection('Cost').where('category', isEqualTo: category['category']).get()
                        .then((snapshot) async {
                      for(DocumentSnapshot ds in snapshot.docs) {
                        await ds.reference.delete();
                        print(ds.reference);
                      }
                    });

                    reference
                        .doc(category['key']).delete()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  Widget _buildCategoryItem({required Map category}) {
    return GestureDetector(

      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(10),

          decoration: new BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              gradient: new LinearGradient(colors: [Colors.white70, Colors.white],
                  begin: Alignment.centerLeft, end: Alignment.centerRight, tileMode: TileMode.clamp)
          ),

          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Category: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        category['category'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditCategory(
                                  categoryKey: category['key'],
                                )));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Edit',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showDeleteDialog(category: category);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red[700],
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('Delete',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category List'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Note: Do not create category with same name as current cost items will be mixed together and error in dropdown inside Expenses page.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 10,),
          Flexible(
            child: SizedBox(
              child: FirestoreAnimatedList(
                query: _ref,
                itemBuilder: (BuildContext context, DocumentSnapshot? snapshot,
                    Animation<double> animation, int index) {
                  Map<String, dynamic> category = snapshot?.data() as Map<String, dynamic>;
                  print(snapshot.toString());
                  category?['key'] = snapshot?.id;
                  return _buildCategoryItem(category: category!);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return AddCategory();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}