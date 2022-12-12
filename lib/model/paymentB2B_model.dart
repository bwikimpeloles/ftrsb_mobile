class PaymentB2B {
  String? amount;
  String? orderDate;
  String? collectionDate;
  String? pic;
  String? status;

  //constructor
  PaymentB2B({this.orderDate, this.amount, this.collectionDate, this.pic, this.status});

  // we need to create map
  PaymentB2B.fromJson(Map<String, dynamic> json) {
    orderDate = json["orderDate"];
    amount = json["amount"];
    collectionDate = json["collectionDate"];
    pic = json["pic"];
    status = json["status"];
    }

  Map<String, dynamic> toJson() {
    // object - data
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDate'] = this.orderDate;
    data['amount'] = this.amount;
    data['collectionDate'] = this.collectionDate;
    data['pic'] = this.pic;
    data['status'] = this.status;
    
    return data;

  }
}