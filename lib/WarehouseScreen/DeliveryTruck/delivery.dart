import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/model/package.dart';
import 'package:ftrsb_mobile/WarehouseScreen/DeliveryTruck/delivery_detail.dart';

class DeliveryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return ListView.builder(
                itemCount: packageList.length,
                itemBuilder: (context, index) {
                  Package package = packageList[index];
                  return Card(
                    child: ListTile(
                      title: Text(package.name),
                      subtitle: Text(package.status),
                      leading: Image.asset("assets/Truck.png"),
                      trailing: Icon(Icons.arrow_forward_rounded),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DeliveryDetailsScreen(package)));
                      },
                    ),
                  );
                });
          },
        );
      },
    );
  }
}
