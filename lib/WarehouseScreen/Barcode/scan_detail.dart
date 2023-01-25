import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import 'package:provider/provider.dart';

import '../../model/user_model.dart';

class scan_detail extends StatefulWidget {
  final String name;
  final int quantity;

  const scan_detail({Key? key, required this.name, required this.quantity})
      : super(key: key);

  @override
  State<scan_detail> createState() => _scan_detailState();
}

class _scan_detailState extends State<scan_detail> {
  TextEditingController quantityController = TextEditingController();
  int? update;
  XFile? image;
  late CollectionReference _collectionRef;
  var storage = FirebaseStorage.instance;
  String imageUrl = '';
  bool loading = false;
  String dateUpdate = DateFormat.yMMMMEEEEd().format(DateTime.now());
  Future uploadFileToFirebase() async {
    var filename = DateTime.now().millisecondsSinceEpoch.toString();

    TaskSnapshot snapshot = await storage
        .ref("DeliveryOrder/$filename")
        .putData(await image!.readAsBytes());
    imageUrl = await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context);
    final db = DatabaseService(uid: user!.uid!);
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Scanned Product",
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
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Quantity',
                        hintText: 'Input Quantity',
                        prefixIcon: Icon(Ionicons.information_circle_outline),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    width: 220,
                    height: 220,
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
                              child: Text("Take DO Picture")),
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
                /*: Image.file(_image as File))*/
                /*   ElevatedButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      setState(() {
                        image = file;
                      });
                    },
                    child: Text("Take DO pic")),*/
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await uploadFileToFirebase();

                      await db.update(widget.name,
                          int.parse(quantityController.text), dateUpdate);
                      setState(() {
                        loading = false;
                      });
                    },
                    child: Text("Update Stock")),
              ]),
            );
          },
        );
      },
    );
  }
}
