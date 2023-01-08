import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/model/product_model.dart';
import 'package:ftrsb_mobile/model/user_model.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';

class ManualInput extends StatefulWidget {
  const ManualInput({Key? key}) : super(key: key);

  @override
  State<ManualInput> createState() => _ManualInputState();
}

class _ManualInputState extends State<ManualInput> {
  String name = "";
  String category = "";
  String sku = "";
  String barcode = "";
  String quantity = "";

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context);
    final db = DatabaseService(uid: user!.uid!);
    return Scaffold(
        appBar: AppBar(
          title: Text('ss'),
          backgroundColor: Color.fromARGB(255, 160, 202, 159),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              //product
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Product Name",
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
                      name = value;
                    },
                    maxLines: 2,
                    decoration: const InputDecoration.collapsed(
                        hintText: "Product name here"),
                  ),
                ),
                const SizedBox(height: 20),
                //category
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Category",
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
                      category = value;
                    },
                    maxLines: 2,
                    decoration: const InputDecoration.collapsed(
                        hintText: "Product Category"),
                  ),
                ),
                const SizedBox(height: 20),
                //SKU
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Product SKU",
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
                      sku = value;
                    },
                    maxLines: 2,
                    decoration: const InputDecoration.collapsed(
                        hintText: "Product SKU"),
                  ),
                ),
                const SizedBox(height: 20),
                //Barcode
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Barcode",
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
                      barcode = value;
                    },
                    maxLines: 2,
                    decoration: const InputDecoration.collapsed(
                        hintText: "Product Barcode"),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Quantity",
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
                      quantity = value;
                    },
                    maxLines: 2,
                    decoration: const InputDecoration.collapsed(
                        hintText: "Product Quantity"),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      await db.scanProduct(ProductModel(
                          name: name,
                          category: category,
                          sku: sku,
                          barcode: barcode,
                          quantity: int.parse(quantity)));
                    },
                    child: const Text("Submit"))
              ],
            ),
          ),
        ));
  }
}
