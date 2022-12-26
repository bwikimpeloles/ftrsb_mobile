import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/bottom_nav_bar.dart';
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

enum DistrChannel {
  shopee,
  whatsapp,
  website,
  b2b_retail,
  b2b_hypermarket,
  grabmart,
  other
}

DistrChannel? _channel;

late CustomerModel cust = CustomerModel();

class _CustomerDetailsFormState extends State<CustomerDetailsForm> {
// form key
  final _formKey = GlobalKey<FormState>();
// editing Controller
  final nameEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final addressEditingController = TextEditingController();
  final emailEditingController = TextEditingController();

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
            return ("Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
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
          hintText: "Name",
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
            return ("Phone number cannot be empty!");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter valid phone number!");
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
            return ("Shipping address cannot be empty!");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter valid shipping address!");
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
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
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
          hintText: "Email Address",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    ///radio button
    //String? distrChannel;
    final channel = Column(
      children: <Widget>[
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("Shopee"),
          value: DistrChannel.shopee,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("WhatsApp"),
          value: DistrChannel.whatsapp,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("Website"),
          value: DistrChannel.website,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("B2B Retail"),
          value: DistrChannel.b2b_retail,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("B2B Hypermarket"),
          value: DistrChannel.b2b_hypermarket,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("GrabMart"),
          value: DistrChannel.grabmart,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
        RadioListTile<DistrChannel>(
          activeColor: Colors.green,
          title: const Text("Other"),
          value: DistrChannel.other,
          groupValue: _channel,
          onChanged: (DistrChannel? value) {
            setState(() {
              _channel = value;
            });
          },
        ),
      ],
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
              Fluttertoast.showToast(msg: 'Choose a distribution channel!');
            }

            else if (_formKey.currentState!.validate() && _channel != null ) {
              setState(() {
                cust.name = nameEditingController.text;
                cust.phone = phoneEditingController.text;
                cust.address = addressEditingController.text;
                cust.email = emailEditingController.text;
                cust.channel = _channel
                    .toString()
                    .substring(_channel.toString().indexOf('.') + 1);

              });

              if (_channel
                          .toString()
                          .substring(_channel.toString().indexOf('.') + 1) ==
                      'b2b_retail' ||
                  _channel
                          .toString()
                          .substring(_channel.toString().indexOf('.') + 1) ==
                      'b2b_hypermarket') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PaymentDetailsB2B(),
                ));
              } 
              else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PaymentDetails(),
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
      bottomNavigationBar: CurvedNavBar(indexnum: 1),
      drawer: NavigationDrawer(),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Add Customer Information'),
        preferredSize: Size.fromHeight(65),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
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
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                          )),
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          SizedBox(
                            height: 20,
                            width: 300,
                            child: Text(
                              'Distribution Channel',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          channel,
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    submitButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
