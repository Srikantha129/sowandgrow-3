import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/purchase.dart';

class PurchaseService {
  Future<List<Purchase>> fetchAllPurchases() async {
    final purchasesRef = FirebaseFirestore.instance.collection('purchase');
    final querySnapshot = await purchasesRef.get();

    try {
      final purchases =
          querySnapshot.docs.map((doc) => Purchase.fromMap(doc.data())).toList();
      return purchases;
    } catch (e) {
      print("Error fetching purchases: $e");
      return [];
    }
  }

  Future<void> savePurchase(Purchase purchase) async {
    final purchasesRef = FirebaseFirestore.instance.collection('purchase');
    try {
      await purchasesRef.doc().set(purchase.toMap());
      print("Purchase saved successfully!");
    } catch (e) {
      print("Error saving purchase: $e");
    }
  }

  Future<void> updatePurchaseStatus(String purchaseId, String newStatus) async {
    final purchaseRef = FirebaseFirestore.instance.collection('purchase');
    try {
      print(purchaseId);
      final querySnapshot = await purchaseRef.where('id', isEqualTo: purchaseId).get();
      if (querySnapshot.docs.isNotEmpty) {
        final purchaseDoc = querySnapshot.docs.first;
        final docId = purchaseDoc.id;
        await purchaseRef.doc(docId).update({'status': newStatus});
        print("Purchase status updated successfully!");
      } else {
        print("Purchase with ID '$purchaseId' not found.");
      }
    } catch (e) {
      print("Error updating purchase status: $e");
    }
  }

  Future<List<Purchase>> getPurchasesForCurrentMonth() async {
    final now = DateTime.now();
    final lastYear = now.year - 1;
    final firstDayOfMonth = DateTime(lastYear, now.month, 1);
    final lastDayOfMonth = DateTime(lastYear, now.month + 1, 0);
    final query = FirebaseFirestore.instance
        .collection('purchase')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth));
    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => Purchase.fromMap(doc.data())).toList();
  }
}
