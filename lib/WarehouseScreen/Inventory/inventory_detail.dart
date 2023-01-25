import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';
import '../../services/database.dart';

class InventoryDetailScreen extends StatefulWidget {
  final String name;
  final String quantity;
  final String imageUrl;
  final String lastUpdate;
  const InventoryDetailScreen({
    Key? key,
    required this.name,
    required this.quantity,
    required this.imageUrl,
    required this.lastUpdate,
  }) : super(key: key);

  @override
  State<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends State<InventoryDetailScreen> {
  TextEditingController quantityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Color.fromARGB(255, 160, 202, 159),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Product Detail",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Image.network(
                      widget.imageUrl,
                      height: 200,
                      width: 200,
                    )),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: TextFormField(
                    initialValue: widget.name,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Product Name',
                        prefixIcon: Icon(Ionicons.cube_outline),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: TextFormField(
                    initialValue: widget.lastUpdate,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Last Stock Delivery',
                        prefixIcon: Icon(Ionicons.calendar_number_outline),
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
                    controller: quantityController,
                    onChanged: (value) {
                      quantityController.text = value;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Input Quantity',
                        labelText: 'Quantity',
                        prefixIcon: Icon(Ionicons.information_circle_outline),
                        border: InputBorder.none),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (quantityController.text == null) {
                        Fluttertoast.showToast(
                            msg: 'Input Correct Amount',
                            gravity: ToastGravity.CENTER,
                            fontSize: 16);
                      }
                      FirebaseFirestore.instance
                          .collection("Product")
                          .doc(widget.name)
                          .update({
                        "quantity": (quantityController.text),
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 160, 202, 159)),
                    ),
                    child: Text("Update Stock"))
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
