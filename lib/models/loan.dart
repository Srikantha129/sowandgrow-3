import 'package:cloud_firestore/cloud_firestore.dart';

class Loan {
  final String id; // Unique identifier for the loan
  final String purchaseId; // ID of the associated purchase
  final int amount;
  final int periodInMonths; // 3, 6, or 12
  final int lastPaidMonth;
  final String status; // "Pending", "Approved", "Rejected", etc.
  final Timestamp startDate;
  final String farmerName;
  final String supplierName;

  Loan({
    required this.id,
    required this.purchaseId,
    required this.amount,
    required this.periodInMonths,
    required this.lastPaidMonth,
    required this.status,
    required this.startDate,
    required this.farmerName,
    required this.supplierName,
  });

  // Getters for individual properties
  String get getId => id;
  String get getPurchaseId => purchaseId;
  int get getAmount => amount;
  int get getPeriodInMonths => periodInMonths;
  int get getLastPaidMonth => lastPaidMonth;
  String get getStatus => status;
  Timestamp get getStartDate => startDate;
  String get getFarmerName => farmerName;
  String get getSupplierName => supplierName;

  // Converts Loan object to a Map suitable for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchaseId': purchaseId,
      'amount': amount,
      'periodInMonths': periodInMonths,
      'lastPaidMonth': lastPaidMonth,
      'status': status,
      'startDate': startDate,
      'farmerName': farmerName,
      'supplierName': supplierName,
    };
  }

  // Creates a Loan object from a Firestore document (Map)
  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['id'] as String,
      purchaseId: map['purchaseId'] as String,
      amount: map['amount'] as int,
      periodInMonths: map['periodInMonths'] as int,
      lastPaidMonth: map['lastPaidMonth'] as int,
      status: map['status'] as String,
      startDate: map['startDate'] as Timestamp,
      farmerName: map['farmerName'] as String,
      supplierName: map['supplierName'] as String,
    );
  }
}