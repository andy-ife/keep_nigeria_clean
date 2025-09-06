import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MapController extends ChangeNotifier {
  final db = FirebaseFirestore.instance;

  myfunc() async {
    DatabaseReference _bin1Ref = FirebaseDatabase.instance
        .ref()
        .child('SmartBin1')
        .child('readings');

    final snapshot = await _bin1Ref.get();
    if (snapshot.exists) print(snapshot.value.toString());
  }
}
