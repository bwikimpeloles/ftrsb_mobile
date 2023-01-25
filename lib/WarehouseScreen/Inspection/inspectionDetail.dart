import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ionicons/ionicons.dart';

class inspectionDetail extends StatefulWidget {
  final String title;
  final String desc;
  final List alldata;
  final String imageUrl;
  final String inspectedDate;
  const inspectionDetail(
      {Key? key,
      required this.title,
      required this.desc,
      required this.alldata,
      required this.imageUrl,
      required this.inspectedDate})
      : super(key: key);

  @override
  State<inspectionDetail> createState() => _inspectionDetailState();
}

class _inspectionDetailState extends State<inspectionDetail> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1.0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.title,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextFormField(
                        initialValue: widget.desc,
                        readOnly: true,
                        maxLines: null,
                        decoration: InputDecoration(
                            labelText: 'Product Description',
                            prefixIcon: Icon(Ionicons.clipboard_outline),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextFormField(
                        initialValue: widget.alldata.toString(),
                        readOnly: true,
                        maxLines: null,
                        decoration: InputDecoration(
                            labelText: 'Product',
                            prefixIcon: Icon(Ionicons.cube_outline),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: TextFormField(
                        initialValue: widget.inspectedDate,
                        readOnly: true,
                        maxLines: null,
                        decoration: InputDecoration(
                            labelText: 'Date Inspected',
                            prefixIcon: Icon(Ionicons.cube_outline),
                            border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Image.network(
                          widget.imageUrl,
                          height: 150,
                          width: 150,
                        )),
                    ElevatedButton(onPressed: () {}, child: Text('Back'))
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
