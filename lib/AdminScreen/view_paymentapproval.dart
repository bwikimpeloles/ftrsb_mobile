import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/AdminScreen/paymentapproval.dart';
import 'edit_paymentapproval.dart';

class ViewPaymentApproval extends StatefulWidget {
  String paymentKey;

  ViewPaymentApproval({required this.paymentKey});

  @override
  _ViewPaymentApprovalState createState() => _ViewPaymentApprovalState();
}

class _ViewPaymentApprovalState extends State<ViewPaymentApproval> {
  late TextEditingController _titleController, _accountholderController, _amountController, _effectivedateController, _ponumberController, _bankreferencenoController, _statusController,_banknameController,_categoryController,_paymenttypeController;

  late CollectionReference _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _accountholderController = TextEditingController();
    _amountController = TextEditingController();
    _effectivedateController = TextEditingController();
    _ponumberController = TextEditingController();
    _bankreferencenoController = TextEditingController();
    _statusController = TextEditingController();
    _banknameController = TextEditingController();
    _categoryController = TextEditingController();
    _paymenttypeController = TextEditingController();
    _ref = FirebaseFirestore.instance.collection('MakePayments');
    getPaymentDetail();
    setState(() {

    });
  }

  getPaymentDetail() async {
    DocumentSnapshot snapshot = (await _ref.doc(widget.paymentKey).get());
    Map payment = snapshot.data() as Map;

    _titleController.text = payment['title'];

    _accountholderController.text = payment['accountholder'];

    _amountController.text = payment['amount'];

    _effectivedateController.text = payment['effectivedate'];

    _ponumberController.text = payment['ponumber'];

    _bankreferencenoController.text = payment['bankreferenceno'];

    _statusController.text = payment['status'];

    _banknameController.text = payment['bankname'];

    _categoryController.text = payment['category'];

    _paymenttypeController.text = payment['paymenttype'];

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (_) => PaymentApprovalAdmin()), (route) => false);

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: (){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PaymentApprovalAdmin()));
            },
          ),
          title: Text('View Payment'),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  enabled: false,
                  controller: _titleController,
                  decoration: InputDecoration(
                    label: Text('Title'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  controller: _accountholderController,
                  decoration: InputDecoration(
                    label: Text('Account Holder/Recipient/Supplier'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  controller: _amountController,
                  decoration: InputDecoration(
                    label: Text('Amount (RM)'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  controller: _categoryController,
                  decoration: InputDecoration(
                    label: Text('Category'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  controller: _effectivedateController,
                  decoration: InputDecoration(
                    label: Text('Effective Date'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  controller: _ponumberController,
                  decoration: InputDecoration(
                    label: Text('Purchase Order No.'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  controller: _banknameController,
                  decoration: InputDecoration(
                    label: Text('Bank Name'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  controller: _paymenttypeController,
                  decoration: InputDecoration(
                    label: Text('Payment Type'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  controller: _bankreferencenoController,
                  decoration: InputDecoration(
                    label: Text('Bank Reference No.'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  enabled: false,
                  controller: _statusController,
                  decoration: InputDecoration(
                    label: Text('Status'),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),

                SizedBox(height: 25,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(style: TextButton.styleFrom(backgroundColor: Theme.of(context).accentColor,),child: Text('Edit',style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,

                  ),),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditPaymentApproval(
                                paymentKey: widget.paymentKey,
                              )));
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


}