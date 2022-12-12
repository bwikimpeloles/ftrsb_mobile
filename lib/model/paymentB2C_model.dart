class PaymentB2C {
  String? paymentMethod;
  String? amount;
  String? paymentDate;
  String? bankName;

  //constructor
  PaymentB2C({this.paymentMethod, this.amount, this.paymentDate, this.bankName, });

  // we need to create map
  PaymentB2C.fromJson(Map<String, dynamic> json) {
    paymentMethod = json["paymentMethod"];
    amount = json["amount"];
    paymentDate = json["paymentDate"];
    bankName = json["bankName"];
    }

  Map<String, dynamic> toJson() {
    // object - data
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentMethod'] = this.paymentMethod;
    data['amount'] = this.amount;
    data['paymentDate'] = this.paymentDate;
    data['bankName'] = this.bankName;
    
    return data;

  }
}