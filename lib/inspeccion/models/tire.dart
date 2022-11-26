import 'package:flutter/material.dart';

class Tire {
  final int uid;
  final serie;
  String brand;
  final String model;
  final String design;
  final int position;
  final int recomendedPressure;
  final int? vehicle;
  final int? idEjes;

  Tire(
      {Key? key,
      required this.uid,
      required this.serie,
      required this.brand,
      required this.model,
      required this.design,
      required this.position,
      required this.recomendedPressure,
      this.vehicle,
      required this.idEjes});
}
