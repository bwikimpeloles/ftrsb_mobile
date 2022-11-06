import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddSupplier extends StatefulWidget {
  @override
  _AddSupplierState createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  late TextEditingController _companynameController, _phonenumberController, _shippingaddressController, _emailController, _picController;


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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier Details'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _companynameController,
              decoration: InputDecoration(
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
              decoration: InputDecoration(
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
              controller: _shippingaddressController,
              decoration: InputDecoration(
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
              controller: _emailController,
              decoration: InputDecoration(
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
              controller: _picController,
              decoration: InputDecoration(
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
                child: Text('Save',style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,

              ),),
                onPressed: (){
                  saveSupplier();
                },
              ),
            )

          ],
        ),
      ),
    );
  }
  void saveSupplier(){

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

    _ref.push().set(supplier).then((value) {
      Navigator.pop(context);
    });


  }
}