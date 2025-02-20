import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/crop.dart';

class CropService {
  final cropsRef = FirebaseFirestore.instance.collection('crops');

  Future<void> createCrop(Crop crop) async {
    try {
      final docRef = await cropsRef.add(crop.toMap());
      print("Crop saved successfully with ID: ${docRef.id}");
    } catch (e) {
      print("Error saving crop: $e");
    }
  }

  Future<List<Crop>> getCrops() async {
    final querySnapshot = await cropsRef.get();
    try {
      final crops =
          querySnapshot.docs.map((doc) => Crop.fromMap(doc.data())).toList();
      return crops;
    } catch (e) {
      print("Error fetching crops: $e");
      return []; // Return empty list on error
    }
  }

  Future<Crop?> getCropById(String id) async {
    final docRef = cropsRef.doc(id);
    final docSnapshot = await docRef.get();
    try {
      if (docSnapshot.exists) {
        final crop = Crop.fromMap(docSnapshot.data() as Map<String, dynamic>);
        return crop;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching crop by ID: $e");
      return null;
    }
  }

  Future<void> updateCrop(Crop crop) async {
    final docRef = cropsRef.doc(crop.id!);
    try {
      await docRef.update(crop.toMap());
      print("Crop updated successfully!");
    } catch (e) {
      print("Error updating crop: $e");
    }
  }

  Future<void> deleteCrop(String id) async {
    final docRef = cropsRef.doc(id);
    try {
      await docRef.delete();
      print("Crop deleted successfully!");
    } catch (e) {
      print("Error deleting crop: $e");
    }
  }
}

// import 'package:sowandgrow/helper/MySqlHelper.dart';
//
// import '../models/crop.dart';
// import 'firebase_helper.dart';
//
// class CropService {
//   final List<Crop> _crops = [];
//
//   Future<void> createCrop(Crop crop) async {
//     _crops.add(crop);
//     final conn = await FirebaseHelper().getConnection();
//     try {
//       var result = await conn.query(
//           ' insert into crop (name, farmingtype) values (?, ?)',
//           [(crop.name), (crop.farmingtype)]);
//       print("Crop saved successfully :  $result ");
//       await conn.close();
//     } catch (e) {
//       print("Save failed :  $e ");
//     }
//   }
//
//   Future<List<Crop>> getCrops() async {
//     final conn = await MySqlHelper().getConnection();
//     try {
//       final result = await conn.query('SELECT * FROM crop');
//
//       final crops = <Crop>[]; // Create an empty list of type List<Crop>
//       for (var row in result) {
//         crops.add(Crop(
//           id: row['id']?.toString() as String,
//           name: row['name'] as String,
//           farmingtype: row['farmingtype'] as String,
//         ));
//       }
//
//       await conn.close();
//       return crops;
//     } catch (e) {
//       print("Error fetching crops: $e");
//     } finally {
//       await conn.close();
//     }
//     return List.empty();
//   }
//
//   Future<Crop?> getCropById(String id) async {
//     final conn = await MySqlHelper().getConnection();
//     try {
//       var result = await conn.query('SELECT * FROM crop WHERE id = ?', [id]);
//       if (result.isEmpty) {
//         return null;
//       }
//       final cropData = result.first;
//       final crop = Crop(
//         name: cropData['name'] as String,
//         farmingtype: cropData['farmingType'] as String,
//         id: cropData['id'] as String?,
//       );
//       return crop;
//     } catch (e) {
//       print("Error fetching crop by ID: $e");
//       return null;
//     } finally {
//       await conn.close();
//     }
//   }
//
//   Future<void> updateCrop(Crop crop) async {
//     final conn = await MySqlHelper().getConnection();
//     try {
//       await conn.query(
//         'UPDATE crop SET name = ?, farmingtype = ? WHERE id = ?',
//         [crop.name, crop.farmingtype, crop.id],
//       );
//     } catch (e) {
//       print("Error updating crop: $e");
//     } finally {
//       await conn.close();
//     }
//   }
//
//   Future<void> deleteCrop(String id) async {
//     final conn = await MySqlHelper().getConnection();
//     try {
//       await conn.query('DELETE FROM crop WHERE id = ?', [id]);
//     } catch (e) {
//       print("Error deleting crop: $e");
//     } finally {
//       await conn.close();
//     }
//   }
// }
