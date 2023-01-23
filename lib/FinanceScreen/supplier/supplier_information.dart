import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import '../sidebar_navigation.dart';
import 'add_supplier.dart';
import 'edit_supplier.dart';
import 'photo_page.dart';

class SupplierInformationFinance extends StatefulWidget {
  @override
  _SupplierInformationFinanceState createState() => _SupplierInformationFinanceState();
}

class _SupplierInformationFinanceState extends State<SupplierInformationFinance> {
  late Query _ref;
  CollectionReference reference =
  FirebaseFirestore.instance.collection('Suppliers');
  TextEditingController _searchController= TextEditingController();
  String search='';
  List<List<String>> listSupplier = [];
  String? filePath;
  List<List<dynamic>> _data = [];
  final Uri _url = Uri.parse('https://docs.google.com/spreadsheets/d/1vpQHAeo5We8P2ph9LI8nrHevRdSea7iYA362qXkYCPs/edit?usp=sharing');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseFirestore.instance.collection('Suppliers').orderBy('companyname');

  }


  generateCsv() async{
    String csvData = ListToCsvConverter().convert(listSupplier);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);

    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');

    final File file = await (File('${generalDownloadDir.path}/supplier_export_$formattedDate.csv').create());

    await file.writeAsString(csvData).then((value) => OpenFile.open('${generalDownloadDir.path}/supplier_export_$formattedDate.csv'));


  }

  queryValues() async {
    listSupplier.clear();
    listSupplier = [<String>['Company Name', 'Shipping Address', 'Phone Number', 'Email', 'PIC']];
    CollectionReference _documentRef=FirebaseFirestore.instance.collection("Suppliers");
    await _documentRef.get().then((ds){
      if(ds!=null){
        ds.docs.forEach((a){
          final dynamic supplier = a.data();
          listSupplier.add([supplier['companyname']??"", supplier['shippingaddress']??"", supplier['phonenumber']??"",supplier['email']??"", supplier['pic']?? '']);
        });
      } else{
        print('fail');

      }
    });
  }

  _pickFile() async {

    final result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['csv'],);

    // if no file is picked
    if (result == null) return;
    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    print(result.files.first.name);
    filePath = result.files.first.path!;

    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    //print(fields);

    setState(() {
      _data = fields;
    });
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  _importFile() async {

    bool notAllOkay=false;

    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    if (_data[1].length != 5) {
      showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: const Text("Import Suppliers Failed"),
              content: const Text('Wrong number of column inside CSV'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text("OK"),

                ),
              ],
            ),
      );
    } else {
      for (var i = 1; i < _data.length; i++) {
        if (_data[i][0] != null && _data[i][1] != null && _data[i][2] != null &&
            _data[i][3] != null && _data[i][4] != null
            && _data[i][0]
                .toString()
                .length >= 1 && _data[i][1]
            .toString()
            .length >= 1 && _data[i][2]
            .toString()
            .length >= 1 && isNumeric(_data[i][2].toString())) {
          //print('eh jadi');
          //print(_data[i][4]);
          //print(DateTime.parse(_data[i][4]));
        } else {
          notAllOkay = true;
          break;
          print('huhu tak jadi');
        }
        //print('(${i}) Name:${_data[i][0]},  Category:${_data[i][1]}, Amount:${_data[i][2]},  Supplier:${_data[i][3]},  Date:${_data[i][4]},  Reference No. (Bank/PO/Invoice/Receipt):${_data[i][5]}, Payment Type:${_data[i][6]}');

      }

      if (notAllOkay) {
        print("There is item not okay");
        showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: const Text("Import Suppliers Failed"),
                content: const Text(
                    "Rule:\n1. Company Name, Address and Phone Number is not empty\n2. Phone Number is a numeric\n3. Use the template given to avoid error"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),

                  ),
                ],
              ),
        );
      } else {
        print("All item okay");
        for (var i = 1; i < _data.length; i++) {
          String companyname = _data[i][0].toString();
          String shippingaddress = _data[i][1].toString();
          String phonenumber = _data[i][2].toString();
          String email = _data[i][3].toString();
          String pic = _data[i][4].toString();


          Map<String, String> supplier = {
            'companyname': companyname,
            'shippingaddress': shippingaddress,
            'phonenumber': phonenumber,
            'email': email,
            'pic': pic,
          };

          FirebaseFirestore.instance
              .collection("Suppliers")
              .doc()
              .set(supplier);
        }
      }
    }
  }



  _showDeleteDialog({required Map supplier}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${supplier['companyname']}'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () async {

                    await FirebaseStorage.instance.ref('poimages/${supplier['key']}').listAll().then((value) {
                      value.items.forEach((element) {
                        FirebaseStorage.instance.ref(element.fullPath).delete();
                      });});

                    await FirebaseFirestore.instance.collection('details').where('supplierkey', isEqualTo: supplier['key']).get()
                        .then((snapshot) async {
                      for(DocumentSnapshot ds in snapshot.docs) {
                        await ds.reference.delete();
                        print(ds.reference);
                      }
                    });
                    reference
                        .doc(supplier['key']).delete()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  Widget _buildSupplierItem({required Map supplier}) {
    return GestureDetector(

      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
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
                    Text('Company Name: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        supplier['companyname'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Address: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Flexible(
                      child: Text(
                        supplier['shippingaddress'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Phone No: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      supplier['phonenumber'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Email: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      supplier['email'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('PIC: ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800),),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      supplier['pic'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),

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
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => PhotoPage(supplierKey: supplier['key'],),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.teal,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text('PO',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditSupplier(
                                  supplierKey: supplier['key'],
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
                        _showDeleteDialog(supplier: supplier);
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
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text('Supplier Information'),
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Export CSV"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Import CSV"),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Template CSV"),
                  ),

                ];
              },
              onSelected:(value) async{
                 if(value == 0){
                  print("Popup menu CSV");
                  //await checkEmptyList();
                  await queryValues();

                  await generateCsv();
                  Fluttertoast.showToast(msg: 'Supplier list was exported');
                }
                else if(value == 1){
                  print("Import CSV");
                  //await checkEmptyList();
                  await _pickFile();
                  await _importFile();
                  Fluttertoast.showToast(msg: 'Supplier list was imported');
                }
                else if(value == 2){
                  print("Template CSV");
                  _launchUrl();
                  //launch('https://docs.google.com/spreadsheets/d/10CdZ0KloQg-EBysgH_IzyKq0YCyVy7LmzvXMVgBkLak/edit?usp=sharing');
                  Fluttertoast.showToast(msg: 'Go to template link');
                }
              }
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Note: Do use same company name to avoid error for dropdown in Expenses page.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 10,),
          SizedBox(
              height: 50,
              width: 250,
              child: TextField(
                onChanged: (text){
                  setState(() {
                    _ref = FirebaseFirestore.instance.collection('Suppliers').orderBy('companyname').startAt([text])
                        .endAt([text + '\uf8ff']);
                  });

                },
                controller: _searchController,
                cursorColor: Colors.teal,
                decoration: InputDecoration(
                    fillColor: Colors.white30,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.teal)
                    ),
                    hintText: 'Company Name',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 18
                    ),
                    prefixIcon: Icon(Icons.search)
                ),
              ),
            ),
          Flexible(
            child: SizedBox(
              child: FirestoreAnimatedList(
                query: _ref,
                itemBuilder: (BuildContext context, DocumentSnapshot? snapshot,
                    Animation<double> animation, int index) {
                  Map<String, dynamic> supplier = snapshot?.data() as Map<String, dynamic>;
                  print(snapshot.toString());
                  supplier?['key'] = snapshot?.id;
                  return _buildSupplierItem(supplier: supplier!);
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
              return AddSupplier();
            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}