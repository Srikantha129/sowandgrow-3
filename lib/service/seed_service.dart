import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/seed.dart';

class SeedService {
  Future<List<Seed>> fetchAllSeeds() async {
    final seedsRef = FirebaseFirestore.instance.collection('seed');
    final querySnapshot = await seedsRef.get();

    try {
      final seeds =
          querySnapshot.docs.map((doc) => Seed.fromMap(doc.data())).toList();
      return seeds;
    } catch (e) {
      print("Error fetching seeds: $e");
      return [];
    }
  }

  Future<void> saveSeed(Seed seed) async {
    final seedsRef = FirebaseFirestore.instance.collection('seed');
    try {
      await seedsRef.doc().set(seed.toMap());
      print("Seed saved successfully!");
    } catch (e) {
      print("Error saving seed: $e");
    }
  }

  Future<void> updateRemoveSeedQuantity(String seedId, int newQuantity) async {
    final seedsRef = FirebaseFirestore.instance.collection('seed');
    try {
      final querySnapshot = await seedsRef.where('id', isEqualTo: seedId).get();
      if (querySnapshot.docs.isNotEmpty) {
        final seedDoc = querySnapshot.docs.first;
        final docId = seedDoc.id;
        final stock = seedDoc.data()['stock'];
        print(stock);
        var updatedQuantity = stock - newQuantity;
        await seedsRef.doc(docId).update({'stock': updatedQuantity});
        print("Seed quantity updated successfully!");
      } else {
        print("Seed with name 'ames' not found.");
      }
    } catch (e) {
      print("Error updating seed quantity: $e");
    }
  }

  Future<void> updateAddSeedQuantity(String seedId, int newQuantity) async {
    final seedsRef = FirebaseFirestore.instance.collection('seed');
    try {
      final querySnapshot = await seedsRef.where('id', isEqualTo: seedId).get();
      if (querySnapshot.docs.isNotEmpty) {
        final seedDoc = querySnapshot.docs.first;
        final docId = seedDoc.id;
        final stock = seedDoc.data()['stock'];
        print(stock);
        var updatedQuantity = stock + newQuantity;
        await seedsRef.doc(docId).update({'stock': updatedQuantity});
        print("Seed quantity updated successfully!");
      } else {
        print("Seed not found.");
      }
    } catch (e) {
      print("Error updating seed quantity: $e");
    }
  }

  Future<void> updateSeedStatus(String seedId, String newStatus) async {
    final seedsRef = FirebaseFirestore.instance.collection('seed');
    try {
      print(seedId);
      final querySnapshot = await seedsRef.where('id', isEqualTo: seedId).get();
      if (querySnapshot.docs.isNotEmpty) {
        final seedDoc = querySnapshot.docs.first;
        final docId = seedDoc.id;
        await seedsRef.doc(docId).update({'status': newStatus});
        print("Seed status updated successfully!");
      } else {
        print("Seed with ID '$seedId' not found.");
      }
    } catch (e) {
      print("Error updating seed status: $e");
    }
  }

  Future<List<String?>> getSeedNamesFromIds(List<String> seedIds) async {
    final seedSnapshots = await Future.wait(
      seedIds.map((seedId) => FirebaseFirestore.instance
          .collection('seed')
          .where('id', isEqualTo: seedId)
          .get()),
    );

    final seedList = seedSnapshots.map((snapshot) => Seed.fromMap(snapshot as Map<String, dynamic>)).toList();
    return seedList.map((seed) => seed.name).toList();
  }

}
