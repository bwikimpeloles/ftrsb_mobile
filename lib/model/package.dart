import 'package:flutter/material.dart';

class Package {
  String name;
  String description;
  String imageUrl;
  String status;

  Package(
      {required this.name,
      required this.description,
      required this.imageUrl,
      required this.status});
}

List<Package> packageList = [
  Package(
      name: 'Ammar',
      description: 'Two iSerunding daginng',
      status: 'Not Yet Package',
      imageUrl:
          'https://cdn.store-assets.com/s/888158/i/39648906.png?width=480'),
  Package(
      name: 'Zaqwan',
      description: 'Two Halia Kisa 250g',
      status: 'Not Yet Package',
      imageUrl:
          'https://cdn.store-assets.com/s/888158/i/39648906.png?width=480'),
];
