import 'package:flutter/material.dart';

class ItemModel {
  final String name;
  final double price;
  final String description;
  final List<dynamic> tags;
  final Widget actions;

  ItemModel({
    required this.name,
    required this.price,
    required this.description,
    required this.tags,
    required this.actions,
  });
}
