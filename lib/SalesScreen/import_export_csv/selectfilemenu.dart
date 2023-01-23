import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class CSVMenu extends StatefulWidget {
  const CSVMenu({Key? key}) : super(key: key);

  @override
  State<CSVMenu> createState() => _CSVMenuState();
}

User? user = FirebaseAuth.instance.currentUser;

class _CSVMenuState extends State<CSVMenu> {
  String? filePath;
  List<List<dynamic>> _data = [];
  List<List<String>> listcust = [];
  List<List<String>> listprospect = [];
  List<List<String>> listorderb2c = [];
  List<List<String>> listorderb2b = [];

  String dateStr =
      DateFormat('yy-MM-dd').format(DateTime.now()).replaceAll('-', '');

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random.secure();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Timestamp _toTimeStamp(DateTime? date) {
    return Timestamp.fromMillisecondsSinceEpoch(date!.millisecondsSinceEpoch);
  }

  generateCsv(List<List<String>> list) async {
    String csvData = ListToCsvConverter().convert(list);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);

    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');

    final File file =
        await (File('${generalDownloadDir.path}/data_export_$formattedDate.csv')
            .create());

    await file.writeAsString(csvData).then((value) => OpenFile.open(
        '${generalDownloadDir.path}/data_export_$formattedDate.csv'));
  }

  _pickFile() async {
    _data = [];
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

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

  exportCustomerMonth() async {
    listcust.clear();
    listcust = [
      <String>[
        'Name',
        'Phone',
        'Email',
        'Shipping Address',
        'Distribution Channel'
      ]
    ];
    Query _documentRef = FirebaseFirestore.instance
        .collection("Customer")
        .where('dateSubmitted',
            isGreaterThanOrEqualTo:
                DateTime(DateTime.now().year, DateTime.now().month, 1))
        .where('dateSubmitted',
            isLessThan:
                DateTime(DateTime.now().year, DateTime.now().month, 32));
    await _documentRef.get().then((ds) {
      if (ds != null) {
        ds.docs.forEach((a) {
          final dynamic customer = a.data();
          listcust.add([
            customer['name'] ?? "",
            customer['phone'] ?? "",
            customer['email'] ?? "",
            customer['address'] ?? "",
            customer['channel'] ?? ''
          ]);
        });
      } else {
        print('fail');
      }
    });
  }

  exportProspectMonth() async {
    listprospect.clear();
    listprospect = [
      <String>['Name', 'Phone', 'Email', 'Distribution Channel']
    ];
    Query _documentRef = FirebaseFirestore.instance
        .collection("Prospect")
        .where('dateSubmitted',
            isGreaterThanOrEqualTo:
                DateTime(DateTime.now().year, DateTime.now().month, 1))
        .where('dateSubmitted',
            isLessThan:
                DateTime(DateTime.now().year, DateTime.now().month, 32));
    await _documentRef.get().then((ds) {
      if (ds != null) {
        ds.docs.forEach((a) {
          final dynamic prospect = a.data();
          listprospect.add([
            prospect['name'] ?? "",
            prospect['phone'] ?? "",
            prospect['email'] ?? "",
            prospect['channel'] ?? ''
          ]);
        });
      } else {
        print('fail');
      }
    });
  }

  exportProspectYear() async {
    listprospect.clear();
    listprospect = [
      <String>['Name', 'Phone', 'Email', 'Distribution Channel']
    ];
    Query _documentRef = FirebaseFirestore.instance
        .collection("Prospect")
        .where('dateSubmitted',
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year, 1, 1))
        .where('dateSubmitted',
            isLessThanOrEqualTo: DateTime(DateTime.now().year, 12, 31));
    await _documentRef.get().then((ds) {
      if (ds != null) {
        ds.docs.forEach((a) {
          final dynamic prospect = a.data();
          listprospect.add([
            prospect['name'] ?? "",
            prospect['phone'] ?? "",
            prospect['email'] ?? "",
            prospect['channel'] ?? ''
          ]);
        });
      } else {
        print('fail');
      }
    });
  }

  exportCustomerYear() async {
    listcust.clear();
    listcust = [
      <String>[
        'Name',
        'Phone',
        'Email',
        'Shipping Address',
        'Distribution Channel'
      ]
    ];
    Query _documentRef = FirebaseFirestore.instance
        .collection("Customer")
        .where('dateSubmitted',
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year, 1, 1))
        .where('dateSubmitted',
            isLessThanOrEqualTo: DateTime(DateTime.now().year, 12, 31));
    await _documentRef.get().then((ds) {
      if (ds != null) {
        ds.docs.forEach((a) {
          final dynamic customer = a.data();
          listcust.add([
            customer['name'] ?? "",
            customer['phone'] ?? "",
            customer['email'] ?? "",
            customer['address'] ?? "",
            customer['channel'] ?? ''
          ]);
        });
      } else {
        print('fail');
      }
    });
  }

  exportOrderB2CMonth() async {
    listorderb2c.clear();
    listorderb2c = [
      <String>[
        'Order ID',
        'Customer Name',
        'Phone Number',
        'Shipping Address',
        'Payment Date',
        'Payment Method',
        'Total Paid (RM)',
        'Product',
        'Distribution Channel'
      ]
    ];
    Query _documentRef = FirebaseFirestore.instance
        .collection("OrderB2C")
        .where('paymentDate',
            isGreaterThanOrEqualTo:
                DateTime(DateTime.now().year, DateTime.now().month, 1))
        .where('paymentDate',
            isLessThan:
                DateTime(DateTime.now().year, DateTime.now().month, 32));
    await _documentRef.get().then((ds) {
      if (ds != null) {
        ds.docs.forEach((a) {
          final dynamic orderb2c = a.data();
          listorderb2c.add([
            orderb2c['orderID'] ?? "",
            orderb2c['custName'] ?? "",
            orderb2c['custPhone'] ?? "",
            orderb2c['custAddress'] ?? '',
            orderb2c['paymentDate'].toDate().toString() ?? '',
            orderb2c['paymentMethod'] ?? '',
            orderb2c['amount'] ?? '',
            orderb2c['product'].toString().replaceAll(RegExp(r'[\[\]]'), ''),
            orderb2c['channel'] ?? '',
          ]);
        });
      } else {
        print('fail');
      }
    });
  }

  exportOrderB2CYear() async {
    listorderb2c.clear();
    listorderb2c = [
      <String>[
        'Order ID',
        'Customer Name',
        'Phone Number',
        'Shipping Address',
        'Payment Date',
        'Payment Method',
        'Total Paid (RM)',
        'Product',
        'Distribution Channel'
      ]
    ];
    Query _documentRef = FirebaseFirestore.instance
        .collection("OrderB2C")
        .where('paymentDate',
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year, 1, 1))
        .where('paymentDate',
            isLessThan: DateTime(DateTime.now().year, 12, 32));
    await _documentRef.get().then((ds) {
      if (ds != null) {
        ds.docs.forEach((a) {
          final dynamic orderb2c = a.data();
          listorderb2c.add([
            orderb2c['orderID'] ?? "",
            orderb2c['custName'] ?? "",
            orderb2c['custPhone'] ?? "",
            orderb2c['custAddress'] ?? '',
            orderb2c['paymentDate'].toDate().toString() ?? '',
            orderb2c['paymentMethod'] ?? '',
            orderb2c['amount'] ?? '',
            orderb2c['product'].toString().replaceAll(RegExp(r'[\[\]]'), ''),
            orderb2c['channel'] ?? '',
          ]);
        });
      } else {
        print('fail');
      }
    });
  }

  exportOrderB2BYear() async {
    listorderb2b.clear();
    listorderb2b = [
      <String>[
        'Order ID',
        'Company Name',
        'PIC',
        'Phone Number',
        'Shipping Address',
        'Order Date',
        'Order Collection Date',
        'Payment Status',
        'Purchase Type',
        'Total Paid (RM)',
        'Product',
        'Distribution Channel'
      ]
    ];
    Query _documentRef = FirebaseFirestore.instance
        .collection("OrderB2B")
        .where('orderDate',
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year, 1, 1))
        .where('orderDate', isLessThan: DateTime(DateTime.now().year, 12, 32));
    await _documentRef.get().then((ds) {
      if (ds != null) {
        ds.docs.forEach((a) {
          final dynamic orderb2b = a.data();
          listorderb2b.add([
            orderb2b['orderID'] ?? "",
            orderb2b['custName'] ?? "",
            orderb2b['pic'] ?? "",
            orderb2b['custPhone'] ?? "",
            orderb2b['custAddress'] ?? '',
            orderb2b['orderDate'].toDate().toString() ?? '',
            orderb2b['collectionDate'].toDate().toString() ?? '',
            orderb2b['paymentStatus'] ?? '',
            orderb2b['purchaseType'] ?? '',
            orderb2b['amount'] ?? '',
            orderb2b['product'].toString().replaceAll(RegExp(r'[\[\]]'), ''),
            orderb2b['channel'] ?? '',
          ]);
        });
      } else {
        print('fail');
      }
    });
  }

  exportOrderB2BMonth() async {
    listorderb2b.clear();
    listorderb2b = [
      <String>[
        'Order ID',
        'Company Name',
        'PIC',
        'Phone Number',
        'Shipping Address',
        'Order Date',
        'Order Collection Date',
        'Payment Status',
        'Purchase Type',
        'Total Paid (RM)',
        'Product',
        'Distribution Channel'
      ]
    ];
    Query _documentRef = FirebaseFirestore.instance
        .collection("OrderB2B")
        .where('orderDate',
            isGreaterThanOrEqualTo:
                DateTime(DateTime.now().year, DateTime.now().month, 1))
        .where('orderDate',
            isLessThan:
                DateTime(DateTime.now().year, DateTime.now().month, 32));
    await _documentRef.get().then((ds) {
      if (ds != null) {
        ds.docs.forEach((a) {
          final dynamic orderb2b = a.data();
          listorderb2b.add([
            orderb2b['orderID'] ?? "",
            orderb2b['custName'] ?? "",
            orderb2b['pic'] ?? "",
            orderb2b['custPhone'] ?? "",
            orderb2b['custAddress'] ?? '',
            orderb2b['orderDate'].toDate().toString() ?? '',
            orderb2b['collectionDate'].toDate().toString() ?? '',
            orderb2b['paymentStatus'] ?? '',
            orderb2b['purchaseType'] ?? '',
            orderb2b['amount'] ?? '',
            orderb2b['product'].toString().replaceAll(RegExp(r'[\[\]]'), ''),
            orderb2b['channel'] ?? '',
          ]);
        });
      } else {
        print('fail');
      }
    });
  }

  _importOrderB2C() async {
    bool notAllOkay = false;

    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    if (_data[0].length != 8) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Import Failed"),
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
        /*
        _data[i][0] = customer name *
        _data[i][1] = phone number *
        _data[i][2] = shipping address *
        _data[i][3] = payment date *
        _data[i][4] = payment method
        _data[i][5] = total paid *
        _data[i][6] = product *
        _data[i][7] = channel *
         */
        if (_data[i][0] != null &&
            _data[i][1] != null &&
            _data[i][2] != null &&
            _data[i][3] != null &&
            _data[i][4] != null &&
            _data[i][5] != null &&
            _data[i][6] != null &&
            _data[i][7] != null &&
            _data[i][0].toString().length >= 1 &&
            _data[i][1].toString().length >= 1 &&
            _data[i][2].toString().length >= 1 &&
            _data[i][6].toString().length >= 1 &&
            _data[i][7].toString().length >= 1 &&
            isNumeric(_data[i][5].toString()) &&
            _data[i][3].toString().length == 10 &&
            isNumeric(_data[i][3][0]) &&
            isNumeric(_data[i][3][1]) &&
            _data[i][3][2] == '/' &&
            isNumeric(_data[i][3][3]) &&
            isNumeric(_data[i][3][4]) &&
            _data[i][3][5] == '/' &&
            isNumeric(_data[i][3][6]) &&
            isNumeric(_data[i][3][7]) &&
            isNumeric(_data[i][3][8]) &&
            isNumeric(_data[i][3][9])) {
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
          builder: (ctx) => AlertDialog(
            title: const Text("Import Failed"),
            content:
                const Text("Please recheck the data arrangement and format"),
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
        /*
        _data[i][0] = customer name *
        _data[i][1] = phone number *
        _data[i][2] = shipping address *
        _data[i][3] = payment date *
        _data[i][4] = payment method
        _data[i][5] = total paid *
        _data[i][6] = product *
        _data[i][7] = channel *
         */
      } else {
        print("All item okay");

        for (var i = 0; i < _data.length; i++) {
          String customername = _data[i][0].toString();
          print(_data[i][0].toString());
          String phonenumber = _data[i][1].toString();
          String shippingaddress = _data[i][2].toString();
          String paymentMethod = _data[i][4].toString();
          String total = _data[i][5].toString();
          List productlist = _data[i][6].toString().split(';');
          String channel = _data[i][7].toString();
          Timestamp date =
              _toTimeStamp(DateFormat('dd/MM/yyyy').parse(_data[i][3]));

          String orderid = dateStr + getRandomString(14);

          print(productlist.toString());

          Map<String, dynamic> orderb2c = {
            'custName': customername,
            'custPhone': phonenumber,
            'custAddress': shippingaddress,
            'paymentMethod': paymentMethod,
            'orderID': orderid,
            'amount': total,
            'paymentDate': date,
            'paymentVerify': 'Auto-Verified',
            'salesStaff': user?.uid,
            'product': productlist,
            'channel': channel,
            'action': 'Approved',
          };

          FirebaseFirestore.instance
              .collection("OrderB2C")
              .doc(orderid)
              .set(orderb2c);

          print('saved to firebase');
        }
      }
    }
  }

  _importOrderB2B() async {
    bool notAllOkay = false;

    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    if (_data[0].length != 11) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Import Failed"),
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
        /*
        _data[i][0] = customer name *
        _data[i][1] = cust phone number *
        _data[i][2] = shipping address *
        _data[i][3] = order date *
        _data[i][4] = collection date *
        _data[i][5] = payment status *
        _data[i][6] = purchase type *
        _data[i][7] = amount *
        _data[i][8] = pic *
        _data[i][9] = product *
        _data[i][10] = channel *

         */
        if (_data[i][0] != null &&
            _data[i][1] != null &&
            _data[i][2] != null &&
            _data[i][3] != null &&
            _data[i][4] != null &&
            _data[i][5] != null &&
            _data[i][6] != null &&
            _data[i][7] != null &&
            _data[i][8] != null &&
            _data[i][9] != null &&
            _data[i][10] != null &&
            _data[i][0].toString().length >= 1 &&
            _data[i][1].toString().length >= 1 &&
            _data[i][2].toString().length >= 1 &&
            _data[i][3].toString().length >= 1 &&
            _data[i][4].toString().length >= 1 &&
            _data[i][5].toString().length >= 1 &&
            _data[i][6].toString().length >= 1 &&
            _data[i][7].toString().length >= 1 &&
            _data[i][8].toString().length >= 1 &&
            _data[i][4].toString().length >= 1 &&
            isNumeric(_data[i][7].toString()) &&
            _data[i][3].toString().length == 10 &&
            isNumeric(_data[i][3][0]) &&
            isNumeric(_data[i][3][1]) &&
            _data[i][3][2] == '/' &&
            isNumeric(_data[i][3][3]) &&
            isNumeric(_data[i][3][4]) &&
            _data[i][3][5] == '/' &&
            isNumeric(_data[i][3][6]) &&
            isNumeric(_data[i][3][7]) &&
            isNumeric(_data[i][3][8]) &&
            isNumeric(_data[i][3][9]) &&
            _data[i][4].toString().length == 10 &&
            isNumeric(_data[i][4][0]) &&
            isNumeric(_data[i][4][1]) &&
            _data[i][4][2] == '/' &&
            isNumeric(_data[i][4][3]) &&
            isNumeric(_data[i][4][4]) &&
            _data[i][4][5] == '/' &&
            isNumeric(_data[i][4][6]) &&
            isNumeric(_data[i][4][7]) &&
            isNumeric(_data[i][4][8]) &&
            isNumeric(_data[i][4][9])) {
        } else {
          notAllOkay = true;
          break;
        }
      }

      if (notAllOkay) {
        print("There is item not okay");
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Import Failed"),
            content:
                const Text("Please recheck the data arrangement and format"),
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
        /*
        _data[i][0] = customer name *
        _data[i][1] = cust phone number *
        _data[i][2] = shipping address *
        _data[i][3] = order date *
        _data[i][4] = collection date *
        _data[i][5] = payment status *
        _data[i][6] = purchase type *
        _data[i][7] = amount *
        _data[i][8] = pic *
        _data[i][9] = product *
        _data[i][10] = channel *
         */
      } else {
        print("All item okay");

        for (var i = 0; i < _data.length; i++) {
          String customername = _data[i][0].toString();
          String phonenumber = _data[i][1].toString();
          String shippingaddress = _data[i][2].toString();
          String paymentStatus = _data[i][5].toString();
          String purchaseType = _data[i][6].toString();
          String total = _data[i][7].toString();
          String pic = _data[i][8].toString();
          List productlist = _data[i][9].toString().split(';');
          String channel = _data[i][10].toString();
          Timestamp orderdate =
              _toTimeStamp(DateFormat('dd/MM/yyyy').parse(_data[i][3]));
          Timestamp collectiondate =
              _toTimeStamp(DateFormat('dd/MM/yyyy').parse(_data[i][4]));

          String orderid = dateStr + getRandomString(14);

          //print(productlist.toString());

          Map<String, dynamic> orderb2b = {
            'custName': customername,
            'custPhone': phonenumber,
            'custAddress': shippingaddress,
            'paymentStatus': paymentStatus,
            'orderID': orderid,
            'pic': pic,
            'amount': total,
            'purchaseType': purchaseType,
            'orderDate': orderdate,
            'collectionDate': collectiondate,
            'paymentVerify': 'Auto-Verified',
            'salesStaff': user?.uid,
            'product': productlist,
            'channel': channel,
            'action': 'Approved',
          };

          FirebaseFirestore.instance
              .collection("OrderB2B")
              .doc(orderid)
              .set(orderb2b);

          print('saved to firebase');
        }
      }
    }
  }

  _importCustomer() async {
    bool notAllOkay = false;

    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    if (_data[0].length != 5) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Import Failed"),
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
        /*
        _data[i][0] = customer name *
        _data[i][1] = phone number *
        _data[i][2] = email
        _data[i][3] = address *
        _data[i][4] = channel *

         */
        if (_data[i][0] != null &&
            _data[i][1] != null &&
            _data[i][2] != null &&
            _data[i][3] != null &&
            _data[i][4] != null &&
            _data[i][0].toString().length >= 1 &&
            _data[i][1].toString().length >= 1 &&
            _data[i][3].toString().length >= 1 &&
            _data[i][4].toString().length >= 1) {
        } else {
          notAllOkay = true;
          break;
        }
      }

      if (notAllOkay) {
        print("There is item not okay");
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Import Failed"),
            content:
                const Text("Please recheck the data arrangement and format"),
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
        /*
        _data[i][0] = customer name *
        _data[i][1] = phone number *
        _data[i][2] = email
        _data[i][3] = address *
        _data[i][4] = channel *

         */
      } else {
        print("All item okay");

        for (var i = 0; i < _data.length; i++) {
          String name = _data[i][0].toString();
          String phone = _data[i][1].toString();
          String email = _data[i][2].toString();
          String address = _data[i][3].toString();
          String channel = _data[i][4].toString();

          Timestamp date = _toTimeStamp(DateTime.now());

          Map<String, dynamic> customer = {
            'name': name,
            'phone': phone,
            'email': email ?? ' ',
            'address': address,
            'dateSubmitted': date,
            'salesStaff': user?.uid,
            'channel': channel,
          };

          FirebaseFirestore.instance.collection("Customer").doc().set(customer);

          print('saved to firebase');
        }
      }
    }
  }

  _importProspect() async {
    bool notAllOkay = false;

    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    if (_data[0].length != 4) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Import Failed"),
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
        /*
        _data[i][0] = customer name *
        _data[i][1] = phone number *
        _data[i][2] = email
        _data[i][3] = channel *

         */
        if (_data[i][0] != null &&
            _data[i][1] != null &&
            _data[i][2] != null &&
            _data[i][3] != null &&
            _data[i][0].toString().length >= 1 &&
            _data[i][1].toString().length >= 1 &&
            _data[i][3].toString().length >= 1) {
        } else {
          notAllOkay = true;
          break;
        }
      }

      if (notAllOkay) {
        print("There is item not okay");
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Import Failed"),
            content:
                const Text("Please recheck the data arrangement and format"),
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
        /*
        _data[i][0] = customer name *
        _data[i][1] = phone number *
        _data[i][2] = email
        _data[i][3] = channel *

         */
      } else {
        print("All item okay");

        for (var i = 0; i < _data.length; i++) {
          String name = _data[i][0].toString();
          String phone = _data[i][1].toString();
          String email = _data[i][2].toString();
          String channel = _data[i][3].toString();

          Timestamp date = _toTimeStamp(DateTime.now());

          Map<String, dynamic> prospect = {
            'name': name,
            'phone': phone,
            'email': email ?? ' ',
            'dateSubmitted': date,
            'salesStaff': user?.uid,
            'channel': channel,
          };

          FirebaseFirestore.instance.collection("Prospect").doc().set(prospect);

          print('saved to firebase');
        }
      }
    }
  }

  final buttonstyle = ElevatedButton.styleFrom(
      fixedSize: const Size(300, 50),
      backgroundColor: Color.fromARGB(255, 33, 164, 75));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavigationDrawer(),
      appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Import/Export CSV'),
        preferredSize: Size.fromHeight(65),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: buttonstyle,
              child: Text('Import Customer Information'),
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Please do not put any title for the columns.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Please make sure the data is arranged in this order and format:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '1. Customer Name\n2. Phone Number\n3. Email\n4. Shipping Address\n5. Distribution Channel\n'),
                            Center(
                                child: ElevatedButton(
                              child: Text("Choose File"),
                              onPressed: () async {
                                await _pickFile();
                                _importCustomer();
                                Fluttertoast.showToast(
                                    msg: 'Customer list was imported');
                                Navigator.pop(context);
                              },
                            )),
                          ],
                        ),
                      );
                    });
              },
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              style: buttonstyle,
              child: Text('Export Customer Information'),
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                                child: ElevatedButton(
                              child: Text("This Month"),
                              onPressed: () async {
                                await exportCustomerMonth();
                                await generateCsv(listcust);
                                Fluttertoast.showToast(
                                    msg: 'Customer list was exported');
                                Navigator.pop(context);
                              },
                            )),
                            Center(
                                child: ElevatedButton(
                              child: Text("This Year"),
                              onPressed: () async {
                                await exportCustomerYear();
                                await generateCsv(listcust);
                                Fluttertoast.showToast(
                                    msg: 'Customer list was exported');
                                Navigator.pop(context);
                              },
                            )),
                          ],
                        ),
                      );
                    });
              },
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              style: buttonstyle,
              child: Text('Import Prospect Information'),
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Please do not put any title for the columns.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Please make sure the data is arranged in this order and format:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '1. Customer Name\n2. Phone Number\n3. Email\n4. Distribution Channel\n'),
                            Center(
                                child: ElevatedButton(
                              child: Text("Choose File"),
                              onPressed: () async {
                                await _pickFile();
                                _importProspect();
                                Fluttertoast.showToast(
                                    msg: 'Prospect list was imported');
                                Navigator.pop(context);
                              },
                            )),
                          ],
                        ),
                      );
                    });
              },
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              style: buttonstyle,
              child: Text('Export Prospect Information'),
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                                child: ElevatedButton(
                              child: Text("This Month"),
                              onPressed: () async {
                                await exportProspectMonth();
                                await generateCsv(listprospect);
                                Fluttertoast.showToast(
                                    msg: 'Prospect list was exported');
                                Navigator.pop(context);
                              },
                            )),
                            Center(
                                child: ElevatedButton(
                              child: Text("This Year"),
                              onPressed: () async {
                                await exportProspectYear();
                                await generateCsv(listprospect);
                                Fluttertoast.showToast(
                                    msg: 'Prospect list was exported');
                                Navigator.pop(context);
                              },
                            )),
                          ],
                        ),
                      );
                    });
              },
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              style: buttonstyle,
              child: Text('Import Order B2C'),
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Please do not put any title for the columns.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Please make sure the data is arranged in this order and format:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '1. Customer Name\n2. Phone Number\n3. Shipping address\n4. Payment date (dd/MM/yyyy)\n5. Payment method (Cash/Bank transfer/etc)\n6. Total Paid (without RM)\n7. Product (name:quantity, name:quantity) \n8. Distribution Channel\n'),
                            Center(
                                child: ElevatedButton(
                              child: Text("Choose File"),
                              onPressed: () async {
                                await _pickFile();
                                await _importOrderB2C();
                                Fluttertoast.showToast(
                                    msg: 'Order list was imported');
                                Navigator.pop(context);
                              },
                            )),
                          ],
                        ),
                      );
                    });
              },
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              style: buttonstyle,
              child: Text('Export Order B2C'),
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                                child: ElevatedButton(
                              child: Text("This Month"),
                              onPressed: () async {
                                await exportOrderB2CMonth();
                                await generateCsv(listorderb2c);
                                Fluttertoast.showToast(
                                    msg: 'Order list was exported');
                                Navigator.pop(context);
                              },
                            )),
                            Center(
                                child: ElevatedButton(
                              child: Text("This Year"),
                              onPressed: () async {
                                await exportOrderB2CYear();
                                await generateCsv(listorderb2c);
                                Fluttertoast.showToast(
                                    msg: 'Order list was exported');
                                Navigator.pop(context);
                              },
                            )),
                          ],
                        ),
                      );
                    });
              },
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              style: buttonstyle,
              child: Text('Import Order B2B'),
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Please do not put any title for the columns.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Please make sure the data is arranged in this order and format:\n',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '1. Customer Name\n2. Phone Number\n3. Shipping address\n4. Order Date (dd/MM/yyyy)\n5. Order Collection Date (dd/MM/yyyy)\n6. Payment status (paid/unpaid)\n7. Purchase Type (COD/Outright/Consignment)\n8. Total Paid (without RM)\n 9. PIC\n10. Product (name:quantity, name:quantity)\n11. Distribution Channel\n'),
                            Center(
                                child: ElevatedButton(
                              child: Text("Choose File"),
                              onPressed: () async {
                                await _pickFile();
                                await _importOrderB2B();
                                Fluttertoast.showToast(
                                    msg: 'Order list was imported');
                                Navigator.pop(context);
                              },
                            )),
                          ],
                        ),
                      );
                    });
              },
            ),
            SizedBox(height: 15,),
            ElevatedButton(
              style: buttonstyle,
              child: Text('Export Order B2B'),
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                                child: ElevatedButton(
                              child: Text("This Month"),
                              onPressed: () async {
                                await exportOrderB2BMonth();
                                await generateCsv(listorderb2b);
                                Fluttertoast.showToast(
                                    msg: 'Order list was exported');
                                Navigator.pop(context);
                              },
                            )),
                            Center(
                                child: ElevatedButton(
                              child: Text("This Year"),
                              onPressed: () async {
                                await exportOrderB2BYear();
                                await generateCsv(listorderb2b);
                                Fluttertoast.showToast(
                                    msg: 'Order list was exported');
                                Navigator.pop(context);
                              },
                            )),
                          ],
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
