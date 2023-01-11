import 'package:flutter/material.dart';
import 'package:ftrsb_mobile/model/package.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Package package;

  CustomerDetailsScreen(this.package);

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
                height: 100,
                width: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  package.status,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17.0, fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  package.description,
                  textAlign: TextAlign.center,
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
