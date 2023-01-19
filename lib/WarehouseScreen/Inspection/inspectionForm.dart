import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Inspection/inspectionList.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Packaging/b2b.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Packaging/b2c.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/product_model.dart';

class inspectionForm extends StatefulWidget {
  const inspectionForm({Key? key}) : super(key: key);

  @override
  State<inspectionForm> createState() => _inspectionFormState();
}

late ProductModel product = ProductModel();
List<ProductModel> selectedProduct = [];

String? _selectedValue = '';

class _inspectionFormState extends State<inspectionForm> {
  final nameEditingController = TextEditingController();
  final skuEditingController = TextEditingController();
  final barcodeEditingController = TextEditingController();

  int _count = 1;
  String desc = "";
  String title = "";
  XFile? image;
  late CollectionReference _collectionRef;
  var storage = FirebaseStorage.instance;
  String imageUrl = '';
  bool loading = false;
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
        .ref("inspectedProduct/$filename")
        .putData(await image!.readAsBytes());
    imageUrl = await snapshot.ref.getDownloadURL();
  }

  getProductlist() {
    List<String> list = [];
    print(list.toString());
    for (int i = 0; i < selectedProduct.length; i++) {
      list.add(selectedProduct[i].name.toString() +
          ":" +
          selectedProduct[i].quantity.toString());
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: _collectionRef.snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            } else {
                              return DropdownButtonFormField(
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down_circle_rounded,
                                    color: Color.fromARGB(255, 160, 202, 159)),
                                dropdownColor: Colors.green.shade50,
                                decoration: InputDecoration(
                                  labelText: 'Product Name',
                                  prefixIcon: Icon(
                                    Icons.library_add,
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
                                      if (_selectedValue == snap.reference.id) {
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
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
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
                                            style: TextStyle(fontSize: 15.0)),
                                        subtitle: Text(
                                            'Qty: ' +
                                                selectedProduct[index]
                                                    .quantity
                                                    .toString(),
                                            style: TextStyle(fontSize: 13.0)),
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              selectedProduct.removeAt(index);
                                              skuEditingController.clear();
                                              barcodeEditingController.clear();
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
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                              child: Text(
                            'Product Quantity',
                            style: TextStyle(color: Colors.grey),
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Title",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          title = value;
                        },
                        maxLines: 2,
                        decoration: const InputDecoration.collapsed(
                            hintText: "Enter your description here"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Description",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          desc = value;
                        },
                        maxLines: 10,
                        decoration: const InputDecoration.collapsed(
                            hintText: "Enter your text here"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    XFile? file = await imagePicker.pickImage(
                                        source: ImageSource.camera);
                                    setState(() {
                                      image = file;
                                    });
                                    /* if (file == null) return;
                                    String uniqueFileName = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();

                                    Reference referenceRoot =
                                        FirebaseStorage.instance.ref();
                                    Reference referenceDirImages =
                                        referenceRoot.child('inspectedProduct');

                                    Reference referenceImageToUpload =
                                        referenceDirImages
                                            .child(uniqueFileName);

                                    try {
                                      await referenceImageToUpload
                                          .putFile(File(file!.path));
                                      imageUrl = await referenceImageToUpload
                                          .getDownloadURL();
                                    } catch (error) {}*/
                                  },
                                  child: Text("Take Picture")),
                            ],
                          ),
                        )),
                    loading
                        ? Center(
                            child: SpinKitPulse(
                              color: Color.fromARGB(255, 160, 202, 159),
                            ),
                          )
                        : Container(child: Text("Uploaded")),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          await uploadFileToFirebase();
                          setState(() {
                            loading = false;
                          });
                          Map<String, dynamic> inspected = {
                            'title': title,
                            'desc': desc,
                            'product': getProductlist(),
                            'inspectionDate': DateTime.now(),
                            'imageUrl': imageUrl,
                          };
                          FirebaseFirestore.instance
                              .collection('Inspection')
                              .doc()
                              .set(inspected);
                        },
                        child: const Text("Submit"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 160, 202, 159)),
                        )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
