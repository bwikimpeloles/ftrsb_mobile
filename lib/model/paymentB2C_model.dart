class PaymentB2C {
  String? paymentMethod;
  String? amount;
  String? paymentDate;
  String? bankName;
  String? paymentVerify;

  //constructor
  PaymentB2C(
      {this.paymentMethod,
      this.amount,
      this.paymentDate,
      this.bankName,
      this.paymentVerify});

  // receive data from server
  factory PaymentB2C.fromMap(map) {
    return PaymentB2C(
      paymentMethod: map["paymentMethod"],
      amount: map["amount"],
      paymentDate: map["paymentDate"],
      bankName: map["bankName"],
      paymentVerify: map["paymentVerify"],
    );
  }

  //send data to server
  Map<String, dynamic> toMap() {
    return {
      'paymentMethod': paymentMethod,
      'amount': amount,
      'paymentDate': paymentDate,
      'bankName': bankName,
      'paymentVerify': paymentVerify,
    };
  }
}
