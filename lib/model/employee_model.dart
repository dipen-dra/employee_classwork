import 'package:flutter/widgets.dart';

class EmployeeModel {
  final String name;
  final String email;
  final String photo;
  final String phone;
  final String role;
  final bool isFavourite;
  Color? color;

  EmployeeModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.role,
    this.isFavourite = false,
    this.color,
  });
}