import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/FinanceScreen/supplier_information.dart';
import 'add_photo.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/firebase_api.dart';
import '/model/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'database.dart';
import 'view.dart';

class PhotoPage extends StatefulWidget {
  String supplierKey;

  PhotoPage({required this.supplierKey});

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late Future<List<FirebaseFile>> futureFiles;
  late Database db;
  List docs = [];


  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('doimages/${widget.supplierKey}');
  }


  initialise(String url) async {
    db = Database();
    await db.initiliase();
    await db.read2(url).then((value) => {
      setState(() {
        docs = value;
      })
    });
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { // this is the block you need
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SupplierInformationFinance()), (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Delivery Order Images'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => AddPhoto(supplierKey: widget.supplierKey,),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
        ),
        body: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Some error occurred!'));
                } else {
                  final files = snapshot.data!;

                  return Container(
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 30,
                              ),
                              child: GridView.builder(
                                itemCount: files.length,
                                itemBuilder: (context, index) {
                                  final file = files[index];
                                  return buildFile(context, file);
                                },
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) {
    return GestureDetector(
      child: GridTile(
        child: ClipRRect(
          child: Image.network(
            file.url,
            width: 92,
            height: 92,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)),
        ),
      ),
      onTap: () async {
        await initialise(file.url);

        await Navigator.push(
            context,
            MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) {
                  return Scaffold(
                    body: GestureDetector(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Hero(
                          tag: 'imageHero',
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                              ),
                              Image.network(
                                file.url,
                                height: 500,
                              ),
                              Text('Tap to minimize.'),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    "Do you want to delete this image?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      )),
                                                  TextButton(
                                                      onPressed: () async {
                                                        await firebase_storage
                                                            .FirebaseStorage
                                                            .instance
                                                            .refFromURL(
                                                            file.url)
                                                            .delete();

                                                        await FirebaseFirestore.instance.collection('imageURLs').where('url', isEqualTo: file.url).get()
                                                          .then((snapshot) async {
                                                        for(DocumentSnapshot ds in snapshot.docs) {
                                                        await ds.reference.delete();
                                                        print(ds.reference);
                                                        }
                                                        });

                                                        await FirebaseFirestore.instance.collection('details').where('url', isEqualTo: file.url).get()
                                                            .then((snapshot) async {
                                                          for(DocumentSnapshot ds in snapshot.docs) {
                                                            await ds.reference.delete();
                                                            print(ds.reference);
                                                          }
                                                        });
                                                        Navigator.pushReplacement(
                                                          context,
                                                          PageRouteBuilder(
                                                            pageBuilder: (context, animation1, animation2) => PhotoPage(supplierKey: widget.supplierKey,),
                                                            transitionDuration: Duration.zero,
                                                            reverseTransitionDuration: Duration.zero,
                                                          ),
                                                        );
                                                      },
                                                      child: Text("Yes"))
                                                ],
                                              );
                                            });
                                      }),
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(20.0),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      margin: EdgeInsets.all(10),
                                      child: ListTile(
                                        onTap: () {
                                            Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1, animation2) => View(
                                                detail: docs[index],
                                                db: db,
                                                key: null,
                                                supplierKey: widget.supplierKey,
                                              ),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration: Duration.zero,
                                            ),
                                          )
                                              .then((value) => {
                                            if (value != null)
                                              {initialise(file.url)}
                                          });
                                        },
                                        contentPadding: EdgeInsets.only(
                                            right: 30, left: 36),
                                        title: Text(docs[index]['description']),
                                        subtitle: Wrap(
                                          spacing: 12,
                                          children: <Widget>[
                                            Text("Date: " +
                                                docs[index]['datentime']),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                }));
      },
    );
  }
}