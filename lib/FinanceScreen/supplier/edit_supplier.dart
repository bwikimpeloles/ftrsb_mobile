import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditSupplier extends StatefulWidget {
  String supplierKey;

  EditSupplier({required this.supplierKey});

  @override
  _EditSupplierState createState() => _EditSupplierState();
}

class _EditSupplierState extends State<EditSupplier> {
  late TextEditingController _companynameController, _phonenumberController, _shippingaddressController, _emailController, _picController;
  final _formKey = GlobalKey<FormState>();
  late DatabaseReference _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _companynameController = TextEditingController();
    _phonenumberController = TextEditingController();
    _shippingaddressController = TextEditingController();
    _emailController = TextEditingController();
    _picController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('Suppliers');
    getSupplierDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Supplier'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
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
                  controller: _companynameController,
                  decoration: InputDecoration(
                    label: Text('Company Name'),
                    hintText: 'Enter Company Name',
                    prefixIcon: Icon(
                      Icons.maps_home_work,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _phonenumberController,
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
                  decoration: InputDecoration(
                    label: Text('Phone Number'),
                    hintText: 'Enter Phone Number',
                    prefixIcon: Icon(
                      Icons.phone_iphone,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
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
                  controller: _shippingaddressController,
                  decoration: InputDecoration(
                    label: Text('Shipping Address'),
                    hintText: 'Enter Shipping Address',
                    prefixIcon: Icon(
                      Icons.map,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    label: Text('Email'),
                    hintText: 'Enter Email',
                    prefixIcon: Icon(
                      Icons.mail,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _picController,
                  decoration: InputDecoration(
                    label: Text('PIC'),
                    hintText: 'Enter PIC',
                    prefixIcon: Icon(
                      Icons.account_box,
                      size: 30,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),

                SizedBox(height: 25,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(style: TextButton.styleFrom(backgroundColor: Theme.of(context).accentColor,),
                    child: Text('Update Supplier',style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,

                  ),),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        saveSupplier();
                      }
                    },

                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  getSupplierDetail() async {
    DataSnapshot snapshot = (await _ref.child(widget.supplierKey).once()).snapshot;

    Map supplier = snapshot.value as Map;

    _companynameController.text = supplier['companyname'];

    _phonenumberController.text = supplier['phonenumber'];

    _shippingaddressController.text = supplier['shippingaddress'];

    _emailController.text = supplier['email'];

    _picController.text = supplier['pic'];

  }

  void saveSupplier() {
    String companyname = _companynameController.text;
    String phonenumber = _phonenumberController.text;
    String shippingaddress = _shippingaddressController.text;
    String email = _emailController.text;
    String pic = _picController.text;

    Map<String,String> supplier = {
      'companyname':companyname,
      'phonenumber': phonenumber,
      'shippingaddress':shippingaddress,
      'email': email,
      'pic':pic,
    };

    _ref.child(widget.supplierKey).update(supplier).then((value) {
      Navigator.pop(context);
    });
  }
}