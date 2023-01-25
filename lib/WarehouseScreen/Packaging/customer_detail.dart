import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/model/package.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../model/product_model.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String title;
  final String desc;
  final String adres;
  final List alldata;
  const CustomerDetailsScreen(
      {Key? key,
      required this.desc,
      required this.title,
      required this.adres,
      required this.alldata})
      : super(key: key);

  @override
  _CustomerDetailsScreen createState() => _CustomerDetailsScreen();
}

late ProductModel product = ProductModel();
List<ProductModel> selectedProduct = [];

String? _selectedValue = '';
String status = "Yes";

class _CustomerDetailsScreen extends State<CustomerDetailsScreen> {
  final nameEditingController = TextEditingController();
  final skuEditingController = TextEditingController();
  final barcodeEditingController = TextEditingController();

  int _count = 1;
  String desc = "";
  String title = "";
  XFile? image;
  late CollectionReference _collectionRef;
  String imageurl = '';
  bool loading = false;
  var storage = FirebaseStorage.instance;
  void incrementCount() {
    setState(() {
      _count++;
    });
  }

  void decrementCount() {
    setState(() {
      _count--;
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _collectionRef = FirebaseFirestore.instance.collection('Product');
    setState(() {
      selectedProduct = [];
    });
  }

  Future uploadFileToFirebase() async {
    var filename = DateTime.now().millisecondsSinceEpoch.toString();

    TaskSnapshot snapshot = await storage
        .ref("packageProduct/$filename")
        .putData(await image!.readAsBytes());
    imageurl = await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Customer Package Detail",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            initialValue: widget.title,
                            maxLines: null,
                            readOnly: true,
                            decoration: InputDecoration(
                                labelText: 'Name',
                                prefixIcon:
                                    Icon(Ionicons.people_circle_outline),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            initialValue: widget.desc,
                            readOnly: true,
                            maxLines: null,
                            decoration: InputDecoration(
                                labelText: 'No Tel',
                                prefixIcon: Icon(Ionicons.call_outline),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            maxLines: null,
                            initialValue: widget.adres.toString(),
                            readOnly: true,
                            decoration: InputDecoration(
                                labelText: 'Address',
                                prefixIcon: Icon(Ionicons.home_outline),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            maxLines: null,
                            initialValue: widget.alldata.toString(),
                            readOnly: true,
                            decoration: InputDecoration(
                                labelText: 'Product',
                                prefixIcon: Icon(Ionicons.cube_outline),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: _collectionRef.snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return DropdownButtonFormField(
                                    isExpanded: true,
                                    icon: Icon(
                                        Icons.arrow_drop_down_circle_rounded,
                                        color:
                                            Color.fromARGB(255, 160, 202, 159)),
                                    dropdownColor: Colors.green.shade50,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Product Name',
                                      prefixIcon: Icon(
                                        Icons.library_add_outlined,
                                      ),
                                    ),
                                    itemHeight: kMinInteractiveDimension,
                                    items: snapshot.data!.docs
                                        .map(
                                          (map) => DropdownMenuItem(
                                            child: Text(
                                              map.id,
                                              overflow: TextOverflow.fade,
                                            ),
                                            value: map.id,
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (String? val) {
                                      for (int i = 0;
                                          i < snapshot.data!.docs.length;
                                          i++) {
                                        DocumentSnapshot snap =
                                            snapshot.data!.docs[i];
                                        setState(() {
                                          _selectedValue = val!;
                                          if (_selectedValue ==
                                              snap.reference.id) {
                                            skuEditingController.text =
                                                snap.get('sku');
                                            barcodeEditingController.text =
                                                snap.get('barcode');
                                          }
                                        });
                                      }
                                    },
                                  );
                                }
                              }),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  child: Text(
                                'Selected Product:',
                                style: TextStyle(color: Colors.grey),
                              )),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: selectedProduct.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ListTile(
                                            title: Text(
                                                selectedProduct[index]
                                                    .name
                                                    .toString(),
                                                style:
                                                    TextStyle(fontSize: 15.0)),
                                            subtitle: Text(
                                                'Qty: ' +
                                                    selectedProduct[index]
                                                        .quantity
                                                        .toString(),
                                                style:
                                                    TextStyle(fontSize: 13.0)),
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedProduct
                                                      .removeAt(index);
                                                  skuEditingController.clear();
                                                  barcodeEditingController
                                                      .clear();
                                                  _count = 1;
                                                  _selectedValue = null;
                                                });
                                              },
                                            ))),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  child: Text(
                                'Product Quantity',
                                style: TextStyle(color: Colors.grey),
                              )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FloatingActionButton.small(
                                    backgroundColor:
                                        Color.fromARGB(255, 160, 202, 159),
                                    heroTag: Text(
                                      "btn1",
                                    ),
                                    child: Icon(Icons.remove),
                                    onPressed: () {
                                      decrementCount();
                                    },
                                  ),
                                  Text(
                                    '$_count',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  FloatingActionButton.small(
                                    backgroundColor:
                                        Color.fromARGB(255, 160, 202, 159),
                                    heroTag: Text("btn2"),
                                    child: Icon(Icons.add),
                                    onPressed: () {
                                      incrementCount();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(

                            //minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              Map<String, dynamic> prodmap = {
                                'name': _selectedValue,
                                'SKU': skuEditingController.text,
                                'barcode': barcodeEditingController.text,
                                'quantity': _count,
                              };
                              product = ProductModel.fromMap(prodmap);
                              setState(() {
                                if (_count <= 0) {
                                  Fluttertoast.showToast(
                                    msg: "Please check your product quantity",
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                } else if (skuEditingController.text == '') {
                                  Fluttertoast.showToast(
                                    msg: "Please choose a product",
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                } else {
                                  selectedProduct.add(product);
                                  skuEditingController.clear();
                                  barcodeEditingController.clear();
                                  _count = 1;
                                  _selectedValue = null;
                                }
                              });
                              //print(_selectedProduct.length);
                            },
                            child: const Text(
                              "Add To List",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 160, 202, 159)),
                            )),
                        Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: image == null
                                          ? Center(
                                              child: Text('No Image'),
                                            )
                                          : Image.file(
                                              File(image!.path),
                                              fit: BoxFit.fill,
                                            )),
                                  /*: Image.file(_image as File))*/
                                  ElevatedButton(
                                      onPressed: () async {
                                        ImagePicker imagePicker = ImagePicker();
                                        XFile? file =
                                            await imagePicker.pickImage(
                                                source: ImageSource.camera);
                                        setState(() {
                                          image = file;
                                        });
                                      },
                                      child: Text("Take Picture"),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color.fromARGB(
                                                    255, 160, 202, 159)),
                                      )),
                                ],
                              ),
                            )),
                        loading
                            ? Center(
                                child: SpinKitPulse(
                                  color: Color.fromARGB(255, 160, 202, 159),
                                ),
                              )
                            : Container(),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              await uploadFileToFirebase();
                              setState(() {
                                loading = false;
                              });
                              Map<String, dynamic> package = {
                                'name': widget.title,
                                'telNo': widget.desc,
                                'address': widget.adres,
                                'product': widget.alldata,
                                'imageUrl': imageurl,
                                'packageDate': DateFormat.yMMMMEEEEd()
                                    .format(DateTime.now())
                              };

                              FirebaseFirestore.instance
                                  .collection('Package')
                                  .doc()
                                  .set(package);
                            },
                            child: const Text("Packaging"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 160, 202, 159)),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}
