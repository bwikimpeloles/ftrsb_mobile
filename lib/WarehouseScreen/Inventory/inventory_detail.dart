import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';
import '../../services/database.dart';

class InventoryDetailScreen extends StatefulWidget {
  final String name;
  final String quantity;
  const InventoryDetailScreen({
    Key? key,
    required this.name,
    required this.quantity,
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
                  child: TextFormField(
                    initialValue: widget.name,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                ),
                SizedBox(height: 10),
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
                  child: TextFormField(
                    controller: quantityController,
                    onChanged: (value) {
                      quantityController.text = value;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Quantity'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (quantityController.text == null) {
                        Fluttertoast.showToast(
                            msg: 'Choose a distribution channel!',
                            gravity: ToastGravity.CENTER,
                            fontSize: 16);
                      }
                      FirebaseFirestore.instance
                          .collection("Product")
                          .doc(widget.name)
                          .update({
                        "quantity": int.parse(quantityController.text),
                      });
                    },
                    child: Text("Update Stock"))
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
