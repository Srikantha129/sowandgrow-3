import 'package:cloud_firestore/cloud_firestore.dart';

class Purchase {
  final String id;
  final String seedname;
  final String farmername;
  final String suppliername;
  final String seedId;
  final int qty;
  final String status;
  final double total;
  final Timestamp date;

  Purchase({
    required this.id,
    required this.seedname,
    required this.farmername,
    required this.suppliername,
    required this.seedId,
    required this.qty,
    required this.status,
    required this.total,
    required this.date,
  });

  // Getters for individual properties
  String get getId => id;
  String get getSeedname => seedname;
  String get getFarmername => farmername;
  String get getSuppliername => suppliername;
  String get getSeedId => seedId;
  int get getQty => qty;
  String get getStatus => status;
  double get getTotal => total;
  Timestamp get getDate => date;

  // Converts Purchase object to a Map suitable for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seedname': seedname,
      'farmername': farmername,
      'seedId': seedId,
      'qty': qty,
      'status': status,
      'total': total,
      'date': date,
      'suppliername': suppliername,
    };
  }

  // Creates a Purchase object from a Firestore document (Map)
  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'] as String,
      seedname: map['seedname'] as String,
      farmername: map['farmername'] as String,
      seedId: map['seedId'] as String,
      qty: map['qty'] as int,
      status: map['status'] as String,
      total: map['total'] as double,
      date: map['date'] as Timestamp,
      suppliername: map['suppliername'] as String,
    );
  }
}