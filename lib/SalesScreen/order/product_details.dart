import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/SalesScreen/order/orderSummaryb2b.dart';
import 'package:ftrsb_mobile/SalesScreen/order/orderSummaryb2c.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';
import 'package:ftrsb_mobile/model/customer_model.dart';
import 'package:ftrsb_mobile/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

late ProductModel product = ProductModel();
List<ProductModel> selectedProduct = [];

String? _selectedValue = 'HALIA KISAR FROZEN 250g';

class _ProductDetailsState extends State<ProductDetails> {
  final nameEditingController = TextEditingController();
  final skuEditingController = TextEditingController();
  final barcodeEditingController = TextEditingController();

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

  late CollectionReference _collectionRef;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _collectionRef = FirebaseFirestore.instance.collection('product');
    setState(() {
      selectedProduct = [];
    });
  }

  @override
  Widget build(BuildContext context) {
//dropdown product name
    final productName = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          )),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _collectionRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  return DropdownButtonFormField(
                    icon: Icon(Icons.arrow_drop_down_circle_rounded,
                        color: Colors.green),
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
                            child: Text(map.id),
                            value: map.id,
                          ),
                        )
                        .toList(),
                    onChanged: (String? val) {
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data!.docs[i];
                        setState(() {
                          _selectedValue = val!;
                          if (_selectedValue == snap.get('name')) {
                            skuEditingController.text = snap.get('SKU');
                            barcodeEditingController.text = snap.get('barcode');
                          }
                        });
                      }
                    },
                  );
                }
              }),
        ],
      ),
    );

    //add button
    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.lightGreen,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
              } else if(skuEditingController.text == ''){
                Fluttertoast.showToast(
                  msg: "Please choose a product",
                  gravity: ToastGravity.CENTER,
                  fontSize: 16.0,
                );
              } else{
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
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //preview list
    final previewProductList = Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          )),
      child: Column(
        children: [
          SizedBox(child: Text('Selected Product:',style: TextStyle(color: Colors.grey),)),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: selectedProduct.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                        title: Text(selectedProduct[index].name.toString(),
                            style: TextStyle(fontSize: 15.0)),
                        subtitle: Text(
                            'Qty: ' +
                                selectedProduct[index].quantity.toString(),
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
                        ))
                    ),
              );
            },
          ),
        ],
      ),
    );

    //submit button
    final submitButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.green,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          //minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (selectedProduct.isEmpty) {
              Fluttertoast.showToast(
                msg: 'Please choose a product!',
                gravity: ToastGravity.CENTER,
                fontSize: 16.0,
              );
            } else {
              setState(() {
                selectedProduct = selectedProduct;
              });

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
        //bottomNavigationBar: CurvedNavBar(indexnum: 1,),
        backgroundColor: Colors.white,
        drawer: NavigationDrawer(),
        appBar: PreferredSize(
          child: CustomAppBar(bartitle: 'Add Product Information'),
          preferredSize: Size.fromHeight(65),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
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
                  previewProductList,
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      addButton,
                      submitButton,
                    ],
                  ),
                ],
              )),
        ));
  }
}
