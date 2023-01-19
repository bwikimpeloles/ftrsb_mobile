import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class inspectionDetail extends StatefulWidget {
  final String title;
  final String desc;
  final List alldata;
  final String imageUrl;
  const inspectionDetail(
      {Key? key,
      required this.title,
      required this.desc,
      required this.alldata,
      required this.imageUrl})
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
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ]),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(widget.desc),
                    const SizedBox(height: 30.0),
                    Text(widget.alldata.toString()),
                    Image.network(widget.imageUrl)
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
