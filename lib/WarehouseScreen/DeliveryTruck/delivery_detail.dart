import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/model/package.dart';

class DeliveryDetailsScreen extends StatelessWidget {
  final Package package;

  DeliveryDetailsScreen(this.package);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(package.name),
        backgroundColor: Color.fromARGB(255, 160, 202, 159),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                package.imageUrl,
                height: 500,
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Text(
                  package.status.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.0, fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  package.description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
