import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/order/payment_details_b2b.dart';
import 'package:ftrsb_mobile/SalesScreen/order/payment_details_b2c.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';
import 'package:ftrsb_mobile/model/customer_model.dart';

class CustomerDetailsForm extends StatefulWidget {
  const CustomerDetailsForm({Key? key}) : super(key: key);

  @override
  State<CustomerDetailsForm> createState() => _CustomerDetailsFormState();
}

late CustomerModel cust = CustomerModel();
late String? _channel;
late String? _channeltype;
late String? _verify;

class _CustomerDetailsFormState extends State<CustomerDetailsForm> {
// form key
  final _formKey = GlobalKey<FormState>();
// editing Controller
  final nameEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final addressEditingController = TextEditingController();
  final emailEditingController = TextEditingController();

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //name field
    final nameField = TextFormField(
        autofocus: false,
        controller: nameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("*required");
          }
          if (!regex.hasMatch(value)) {
            return ("Please enter valid name (Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          nameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.account_circle,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Customer/Company Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //phone field
    final phoneField = TextFormField(
        autofocus: false,
        controller: phoneEditingController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          RegExp regex = RegExp(r'(\d+)');
          if (value!.isEmpty) {
            return ("*required");
          }
          if (!regex.hasMatch(value)) {
            return ("Invalid phone number");
          }
          return null;
        },
        onSaved: (value) {
          phoneEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.phone,
            color: Colors.green,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //address field
    final addressField = TextFormField(
        autofocus: false,
        controller: addressEditingController,
        keyboardType: TextInputType.streetAddress,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("*required");
          }
          if (!regex.hasMatch(value)) {
            return ("Invalid shipping address");
          }
          return null;
        },
        onSaved: (value) {
          addressEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.home_filled,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Shipping Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value!) && value.isNotEmpty) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.mail,
            color: Colors.green,
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email Address   (optional)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    ///dropdown
    final channel = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          )),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Channel').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            } else {
              return DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down_circle_rounded,
                      color: Colors.green),
                  dropdownColor: Colors.green.shade50,
                  decoration: InputDecoration(
                    labelText: 'Distribution Channel',
                   // prefixIcon: Icon(
                   //   Icons.library_add,
                   // ),
                  ),
                  itemHeight: kMinInteractiveDimension,
                  items: snapshot.data!.docs
                      .map(
                        (map) => DropdownMenuItem(  
                          child: Text(map.id, overflow: TextOverflow.fade,),
                          value: map.id,
                        ),
                      )
                      .toList(),
                  onChanged: (String? val) {
                    for (int i = 0; i < snapshot.data!.docs.length; i++) {
                      DocumentSnapshot snap = snapshot.data!.docs[i];
                      setState(() {
                        _channel = val!;
                        if (_channel == snap.reference.id) {
                          _channeltype = snap.get('type');
                          _verify = snap.get('needVerification');
                        }
                      });
                    }
                  },
                ),
              );
            }
          }),
    );


  
    //submit button
    final submitButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.green,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (_channel == null){
              Fluttertoast.showToast(msg: 'Please choose a distribution channel', gravity: ToastGravity.CENTER, fontSize: 16);
            }

            else if (_formKey.currentState!.validate() && _channel != null ) {
              setState(() {
                cust.name = nameEditingController.text;
                cust.phone = phoneEditingController.text;
                cust.address = addressEditingController.text;
                cust.email = emailEditingController.text;
                cust.channel = _channel;

              });

              if (_channeltype == 'B2B') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentDetailsB2B(channeltype: _channeltype,),
                ));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentDetails(verify: _verify, channeltype: _channeltype,),
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

    return Scaffold(
      //bottomNavigationBar: CurvedNavBar(indexnum: 1),
      drawer: NavigationDrawer(),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Add Customer Information'),
        preferredSize: Size.fromHeight(65),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  nameField,
                  SizedBox(height: 20),
                  phoneField,
                  SizedBox(height: 20),
                  emailField,
                  SizedBox(height: 20),
                  addressField,
                  SizedBox(height: 20),
                  channel,
                  SizedBox(height: 20),
                  submitButton,
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
