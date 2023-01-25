import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ftrsb_mobile/SalesScreen/customAppBar.dart';
import 'package:ftrsb_mobile/SalesScreen/customer/distrChannelList.dart';
import 'package:ftrsb_mobile/SalesScreen/sidebar_navigation.dart';

class EditCustomerDetailsForm extends StatefulWidget {
  String customerKey;
  String channel;
  EditCustomerDetailsForm({required this.customerKey, required this.channel});

  @override
  State<EditCustomerDetailsForm> createState() => _EditCustomerDetailsFormState();
}


class _EditCustomerDetailsFormState extends State<EditCustomerDetailsForm> {
// form key
  final _formKey = GlobalKey<FormState>();
// editing Controller
  final nameEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final addressEditingController = TextEditingController();
  final emailEditingController = TextEditingController();

  late String? _channel;

  @override
  void initState() {
    getCustomerDetail();
    _channel = widget.channel;
  }

  @override
  Widget build(BuildContext context) {
    //name field
    final nameField = TextFormField(
        autofocus: false,
        controller: nameEditingController,
        //keyboardType: TextInputType.name,
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
          hintText: "Email Address",
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
                    labelText: 'New Distribution Channel',
                  ),
                  itemHeight: kMinInteractiveDimension,
                  items: snapshot.data!.docs
                      .map(
                        (map) => DropdownMenuItem(
                          child: Text(
                            map.id,
                            overflow: TextOverflow.fade,
                          ),
                          value: map.id,
                        ),
                      )
                      .toList(),
                  onChanged: (String? val) {
                    setState(() {
                      _channel = val!;
                    });
                  },
                ),
              );
            }
          }),
    );

  
    //update button
    final updateButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.green,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          //minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (_channel == null){
              Fluttertoast.showToast(msg: 'Choose a distribution channel!');
            } else if (_formKey.currentState!.validate() && _channel != null) {
              saveCustomer();

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DistrChannelList(),
              ));
            }
          },
          child: const Text(
            "Update",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //delete button
    final deleteButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.red,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          //minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
           _showDeleteDialog();
          },
          child: const Text(
            "Delete",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      //bottomNavigationBar: CurvedNavBar(indexnum: 3),
      drawer: NavigationDrawer(),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: CustomAppBar(bartitle: 'Edit Customer Information'),
        preferredSize: Size.fromHeight(65),
      ),
      body: SingleChildScrollView(
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
                  channel,
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      updateButton,
                      deleteButton,
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

    getCustomerDetail() async {

    DocumentSnapshot snapfirestore = await FirebaseFirestore.instance
    .collection('Customer')
    .doc(widget.customerKey)
    .get();

    Map customerfromfirestore = snapfirestore.data() as Map;

    nameEditingController.text = customerfromfirestore['name'];
    phoneEditingController.text = customerfromfirestore['phone'];
    addressEditingController.text = customerfromfirestore['address'];
    emailEditingController.text = customerfromfirestore['email'];
   // _channel = customerfromfirestore['channel'];

   // setState(() {
   //   _channel = customerfromfirestore['channel'];
   // });
    
  }

    _showDeleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure you want to delete this customer?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Customer').doc(widget.customerKey).delete().whenComplete(() =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DistrChannelList())));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  void saveCustomer() {
    String name = nameEditingController.text;
    String phone = phoneEditingController.text;
    String address = addressEditingController.text;
    String email = emailEditingController.text;
    String channel =
        _channel.toString().substring(_channel.toString().indexOf('.') + 1);

    Map<String, String> customer = {
      'name': name,
      'phone': phone,
      'address': address,
      'email': email,
      'channel': channel
    };
    FirebaseFirestore.instance
        .collection('Customer')
        .doc(widget.customerKey)
        .update(customer)
        .then((value) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => DistrChannelList()));
    });
  }
}
