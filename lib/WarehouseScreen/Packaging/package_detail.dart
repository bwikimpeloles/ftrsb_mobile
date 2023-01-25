import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ionicons/ionicons.dart';

class PackageDetail extends StatefulWidget {
  final String name;
  final String telNo;
  final String address;
  final List alldata;
  final String imageUrl;
  final String packageDate;
  const PackageDetail(
      {Key? key,
      required this.name,
      required this.telNo,
      required this.address,
      required this.alldata,
      required this.imageUrl,
      required this.packageDate})
      : super(key: key);

  @override
  State<PackageDetail> createState() => _PackageDetailState();
}

class _PackageDetailState extends State<PackageDetail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "Package Detail",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextFormField(
                  initialValue: widget.name,
                  maxLines: null,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Ionicons.people_circle_outline),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextFormField(
                  initialValue: widget.alldata.toString(),
                  maxLines: null,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Product',
                      prefixIcon: Icon(Ionicons.cube_outline),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextFormField(
                  initialValue: widget.telNo.toString(),
                  maxLines: null,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'No Tel',
                      prefixIcon: Icon(Ionicons.call_outline),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextFormField(
                  initialValue: widget.address,
                  maxLines: null,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Ionicons.home_outline),
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Image.network(
                    widget.imageUrl,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  ))
            ]),
          ],
        ),
      ),
    );
  }
}
