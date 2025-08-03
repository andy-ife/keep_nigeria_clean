import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BinDataController extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
}
