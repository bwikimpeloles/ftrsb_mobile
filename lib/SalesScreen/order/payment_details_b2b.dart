import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/order/customer_details.dart';
import 'package:ftrsb_mobile/model/paymentB2B_model.dart';
import 'package:intl/intl.dart';

class PaymentDetailsB2B extends StatefulWidget {
  const PaymentDetailsB2B({Key? key}) : super(key: key);

  @override
  State<PaymentDetailsB2B> createState() => _PaymentDetailsB2BState();
}

enum PaymentStatus { paid, unpaid }

PaymentStatus? _paymentStatus;

class _PaymentDetailsB2BState extends State<PaymentDetailsB2B> {
  late DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child('Customer');

  late PaymentB2B paymentModel = PaymentB2B();    

  final _formKey = GlobalKey<FormState>();
  //text field controller
  final amountTextCtrl = TextEditingController();
  final picCtrl = TextEditingController();
  final orderdateInput = TextEditingController();
  final collectdateInput = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ///amount field
    final amountField = TextFormField(
        autofocus: false,
        controller: amountTextCtrl,
        keyboardType: TextInputType.phone,
        validator: (value) {
          RegExp regex = RegExp(r'(\d+)');
          if (value!.isEmpty) {
            return ("This field cannot be empty!");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter valid amount!");
          }
          return null;
        },
        onSaved: (value) {
          amountTextCtrl.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.attach_money,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Amount (RM)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    ///order date field
    DateTime? orderDate;
    final orderdate = TextFormField(
      controller: orderdateInput,
      autofocus: false,
      readOnly: true,
      validator: (value) {
        RegExp regex = RegExp(r'(\d+)');
        if (value!.isEmpty) {
          return ("This field cannot be empty!");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter valid amount!");
        }
        return null;
      },
      onSaved: (value) {
        orderdateInput.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: Colors.green,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Order Date",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: () async {
        orderDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101));

        if (orderDate != null) {
          String? formattedDate = DateFormat('dd/MM/yyyy').format(orderDate!);
          setState(() {
            orderdateInput.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          return null;
        }
      },
    );


    ///order collection date field
    DateTime? collectDate;
    final collectdate = TextFormField(
      controller: collectdateInput,
      autofocus: false,
      readOnly: true,
      validator: (value) {
        RegExp regex = RegExp(r'(\d+)');
        if (value!.isEmpty) {
          return ("This field cannot be empty!");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter valid amount!");
        }
        return null;
      },
      onSaved: (value) {
        collectdateInput.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: Colors.green,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Order Collection Date",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: () async {
        collectDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101));

        if (orderDate != null) {
          String? formattedDate = DateFormat('dd/MM/yyyy').format(collectDate!);
          setState(() {
            collectdateInput.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          return null;
        }
      },
    );

    ///pic field
    final picField = TextFormField(
        autofocus: false,
        controller: picCtrl,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("This field cannot be empty!");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter valid name!");
          }
          return null;
        },
        onSaved: (value) {
          picCtrl.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.account_circle,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "PIC",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //radio button
    final paystatus = Column(
      children: [
        SizedBox(height: 15),
        const SizedBox(
          height: 20,
          width: 300,
          child: Text(
            'Payment Status',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Column(
          children: [
            RadioListTile<PaymentStatus>(
              activeColor: Colors.green,
              title: const Text("Paid"),
              value: PaymentStatus.paid,
              groupValue: _paymentStatus,
              onChanged: (PaymentStatus? value) {
                setState(() {
                  _paymentStatus = PaymentStatus.paid;
                });
              },
            ),
            RadioListTile<PaymentStatus>(
              activeColor: Colors.green,
              title: const Text("Unpaid"),
              value: PaymentStatus.unpaid,
              groupValue: _paymentStatus,
              onChanged: (PaymentStatus? value) {
                setState(() {
                  _paymentStatus = PaymentStatus.unpaid;
                });
              },
            ),
          ],
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      //drawer: NavigationDrawer(),
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const CustomerDetailsForm(),
                ))),
        title: const Text("Payment Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  amountField,
                  SizedBox(height: 20),
                  orderdate,
                  SizedBox(height: 20),
                  collectdate,
                  SizedBox(height: 20),
                  picField,
                  SizedBox(height: 20),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: paystatus),
                  SizedBox(height: 20),
                  Container(
                    child: SizedBox(
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.green,
                        child: MaterialButton(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            if (_paymentStatus == null) {
                              Fluttertoast.showToast(
                                  msg: "Please select a payment status");
                            } else if (_formKey.currentState!.validate() &&
                                _paymentStatus != null) {
                                  setState(() {
                                    paymentModel.amount = amountTextCtrl.text;
                                    paymentModel.orderDate = orderdateInput.toString();
                                    paymentModel.collectionDate = collectdateInput.text;
                                    paymentModel.pic = picCtrl.text;
                                    paymentModel.status = _paymentStatus.toString();
                                    
                                  });

                              /*
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const PaymentDetails(),
              ));
              */

                              /* Map<String?, String?> customer = {
                                'name': cust.name,
                                'phone': cust.phone,
                                'address': cust.address,
                                'email': cust.email,
                                'channel': cust.channel
                              };

                              dbRef.push().set(customer);*/
                            }
                          },
                          child: const Text(
                            'Next',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
