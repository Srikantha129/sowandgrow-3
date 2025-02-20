import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/loan.dart';

class LoanService {
  Future<List<Loan>> fetchAllLoans() async {
    final loansRef = FirebaseFirestore.instance.collection('loan');
    final querySnapshot = await loansRef.get();

    try {
      final loans =
          querySnapshot.docs.map((doc) => Loan.fromMap(doc.data())).toList();
      return loans;
    } catch (e) {
      print("Error fetching loans: $e");
      return [];
    }
  }

  Future<void> saveLoan(Loan loan) async {
    final loansRef = FirebaseFirestore.instance.collection('loan');
    try {
      await loansRef.doc().set(loan.toMap());
      print("Loan saved successfully!");
    } catch (e) {
      print("Error saving loan: $e");
    }
  }

  Future<void> updateLoanStatus(String loanId, String newStatus) async {
    final loanRef = FirebaseFirestore.instance.collection('loan');
    try {
      print(loanId);
      final querySnapshot = await loanRef.where('id', isEqualTo: loanId).get();
      if (querySnapshot.docs.isNotEmpty) {
        final loanDoc = querySnapshot.docs.first;
        final docId = loanDoc.id;
        await loanRef.doc(docId).update({'status': newStatus});
        print("Loan status updated successfully!");
      } else {
        print("Loan with ID '$loanId' not found.");
      }
    } catch (e) {
      print("Error updating loan status: $e");
    }
  }

  // Future<List<String?>> getSeedNamesFromIds(List<String> seedIds) async {
  //   final seedSnapshots = await Future.wait(
  //     seedIds.map((seedId) => FirebaseFirestore.instance
  //         .collection('seed')
  //         .where('id', isEqualTo: seedId)
  //         .get()),
  //   );
  //
  //   final seedList = seedSnapshots.map((snapshot) => Seed.fromMap(snapshot as Map<String, dynamic>)).toList();
  //   return seedList.map((seed) => seed.name).toList();
  // }
  Future<List<Loan>> getLoansForByFarmerName(String farmerName) async {
    final query = FirebaseFirestore.instance
        .collection('loan')
        .where('farmerName', isEqualTo: farmerName);
    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => Loan.fromMap(doc.data())).toList();
  }

  Future<List<Loan>> getLoansForBySupplierName(String supplierName) async {
    final query = FirebaseFirestore.instance
        .collection('loan')
        .where('supplierName', isEqualTo: supplierName);
    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => Loan.fromMap(doc.data())).toList();
  }

  Future<void> payInstallment(String loanId) async {
    final loanRef = FirebaseFirestore.instance.collection('loan');
    try {
      final querySnapshot = await loanRef.where('id', isEqualTo: loanId).get();
      if (querySnapshot.docs.isNotEmpty) {
        final loanDoc = querySnapshot.docs.first;
        final docId = loanDoc.id;

        // Get the existing loan data
        final loanData = loanDoc.data();
        final currentStatus = loanData['status'];
        final int lastPaidMonth = loanData['lastPaidMonth'] ?? 0;
        print(lastPaidMonth);
        // Validate loan status
        // if (currentStatus != 'Approved') {
        //   print('Loan must be approved to mark installment as paid.');
        //   return;
        // }

        // Increment paid month
        final newLastPaidMonth = lastPaidMonth + 1;

        // Update loan status based on new paid month
        String newStatus;
        final int periodInMonths = loanData['periodInMonths'];
        if (newLastPaidMonth == periodInMonths) {
          newStatus = 'Completed';
        } else {
          newStatus = 'Partially Paid';
        }

        // Update the loan document
        await loanRef.doc(docId).update({
          'status': newStatus,
          'lastPaidMonth': newLastPaidMonth,
        });
        print("Loan status updated successfully!");
      } else {
        print("Loan with ID '$loanId' not found.");
      }
    } catch (e) {
      print("Error updating loan status: $e");
    }
  }

}
