import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/order/orderSummaryb2b.dart';
import 'package:ftrsb_mobile/SalesScreen/order/orderSummaryb2c.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';
import 'package:ftrsb_mobile/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

late ProductModel product = ProductModel();

String? _selectedValue = 'No product chosen';

var listOfValue = [
  'KUNYIT KISAR FROZEN 250g',
  'LENGKUAS KISAR FROZEN 250g',
  'HALIA KISAR FROZEN 250g',
  'CILI KERING KISAR FROZEN 250g',
  'CILI API KISAR FROZEN 250g'
];

class _ProductDetailsState extends State<ProductDetails> {

    //late DatabaseReference dbRef =
    //  FirebaseDatabase.instance.ref().child('ProductTemp');

  // form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final nameEditingController = TextEditingController();
  final skuEditingController = TextEditingController();
  final barcodeEditingController = TextEditingController();
  final quantityEditingController = TextEditingController();
  final docUrlEditingController = TextEditingController();

  int _count = 1;

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

  @override
  Widget build(BuildContext context) {
//dropdown product name
    final productName = Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          )),
      child: Column(
        children: [
          DropdownButtonFormField(
              items: listOfValue.map((e) {
                return DropdownMenuItem(
                  child: Text(e),
                  value: e,
                );
              }).toList(),
              onChanged: (String? val) {
                setState(() {
                  _selectedValue = val!;
                  if (_selectedValue == 'KUNYIT KISAR FROZEN 250g') {
                    skuEditingController.text = '20';
                    barcodeEditingController.text = '7634273';
                  } else if (_selectedValue == 'LENGKUAS KISAR FROZEN 250g') {
                    skuEditingController.text = '20';
                    barcodeEditingController.text = '935627';
                  } else if (_selectedValue == 'HALIA KISAR FROZEN 250g') {
                    skuEditingController.text = '21';
                    barcodeEditingController.text = '935459';
                  } else if (_selectedValue ==
                      'CILI KERING KISAR FROZEN 250g') {
                    skuEditingController.text = '22';
                    barcodeEditingController.text = '7645372';
                  } else if (_selectedValue == 'CILI API KISAR FROZEN 250g') {
                    skuEditingController.text = '22';
                    barcodeEditingController.text = '762513';
                  }
                });
              },
              icon: Icon(Icons.arrow_drop_down_circle_rounded,
                  color: Colors.green),
              dropdownColor: Colors.green.shade50,
              decoration: InputDecoration(
                labelText: 'Product Name',
                prefixIcon: Icon(
                  Icons.library_add,
                ),
              )),
        ],
      ),
    );

//select file button
    final selectFileButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        color: Colors.lightGreen,
        child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: 10,
            onPressed: (() {}),
            child: const Text(
              "Select File",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                //fontWeight: FontWeight.bold
              ),
            )));

    //select file button
    final takePhotoButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        color: Colors.lightGreen,
        child: MaterialButton(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            minWidth: 10,
            onPressed: (() {}),
            child: const Text(
              "Take Photo",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                //fontWeight: FontWeight.bold
              ),
            )));

    //submit button
    final submitButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.green,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (skuEditingController.text == '') {
              Fluttertoast.showToast(msg: 'Please choose a product!');
            } else {
              setState(() {
                product.name = _selectedValue;
                product.sku = skuEditingController.text;
                product.quantity = _count;
                product.barcode = barcodeEditingController.text;
              });

              Map<String?, String?> products = {
                'name': product.name,
                'sku': product.sku,
                'quantity': product.quantity.toString(),
                'barcode': product.barcode,
              };

              //dbRef.push().set(products);

              if (cust.channel == 'b2b_retail' ||
                  cust.channel == 'b2b_hypermarket') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderSummaryB2B(),
                ));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderSummaryB2C(),
                ));
              }
            }
          },
          child: const Text(
            "Next",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //sku field
    final skuField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: skuEditingController,
        //keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("This field cannot be empty!");
          }
          if (!regex.hasMatch(value)) {
            return ("Invalid Input!");
          }
          return null;
        },
        onSaved: (value) {
          skuEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.numbers,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Product SKU",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //barcode field
    final barcodeField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: barcodeEditingController,
        //keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("This field cannot be empty!");
          }
          if (!regex.hasMatch(value)) {
            return ("Invalid Input!");
          }
          return null;
        },
        onSaved: (value) {
          barcodeEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.abc,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Product Barcode",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //input quantity
    final quantityField = Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          )),
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
                heroTag: Text("btn1",),
                child: Icon(Icons.remove),
                onPressed: () {
                  decrementCount();
                },
              ),
              Text(
                '$_count',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              FloatingActionButton.small(
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
    );

    return Scaffold(
        bottomNavigationBar: CurvedNavBar(
          indexnum: 1,
        ),
        backgroundColor: Colors.white,
        drawer: NavigationDrawer(),
        appBar: PreferredSize(
          child: CustomAppBar(bartitle: 'Add Product Information'),
          preferredSize: Size.fromHeight(65),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('product').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                return Column(
                  children: [
                    productName,
                    SizedBox(
                      height: 20,
                    ),
                    skuField,
                    SizedBox(
                      height: 20,
                    ),
                    barcodeField,
                    SizedBox(
                      height: 20,
                    ),
                    quantityField,
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: Column(
                        children: [
                          SizedBox(
                              child: Text(
                            'Upload Sales Document',
                            style: TextStyle(color: Colors.grey),
                          )),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              selectFileButton,
                              takePhotoButton,
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    submitButton,
                  ],
                );
              }),
        ));
  }
}
