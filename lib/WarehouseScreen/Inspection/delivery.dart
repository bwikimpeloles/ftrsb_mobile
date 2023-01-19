import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/model/package.dart';
import 'package:ftrsb_mobile/WarehouseScreen/Inspection/delivery_detail.dart';

class DeliveryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Container();
          },
        );
      },
    );
  }
}
