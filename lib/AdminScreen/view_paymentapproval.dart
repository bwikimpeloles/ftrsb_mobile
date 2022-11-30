import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/FinanceScreen/make_payment.dart';

import 'edit_paymentapproval.dart';

class ViewPaymentApproval extends StatefulWidget {
  String paymentKey;

  ViewPaymentApproval({required this.paymentKey});

  @override
  _ViewPaymentApprovalState createState() => _ViewPaymentApprovalState();
}

class _ViewPaymentApprovalState extends State<ViewPaymentApproval> {
  late TextEditingController _titleController, _accountholderController, _amountController, _effectivedateController, _ponumberController, _bankreferencenoController, _statusController;

  late DatabaseReference _ref;
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
    _ref = FirebaseDatabase.instance.reference().child('MakePayments');
    getPaymentDetail();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (_) => MakePaymentFinance()), (route) => false);

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
                      builder: (_) => MakePaymentFinance()));
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
                    label: Text('Account Holder (Recipient)'),
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

  getPaymentDetail() async {
    DataSnapshot snapshot = (await _ref.child(widget.paymentKey).once()).snapshot;

    Map payment = snapshot.value as Map;

    _titleController.text = payment['title'];

    _accountholderController.text = payment['accountholder'];

    _amountController.text = payment['amount'];

    _effectivedateController.text = payment['effectivedate'];

    _ponumberController.text = payment['ponumber'];

    _bankreferencenoController.text = payment['bankreferenceno'];

    _statusController.text = payment['status'];

  }
}