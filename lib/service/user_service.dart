import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UserService {
  Future<bool> checkUserExists(String username) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    try {
      final querySnapshot =
          await usersRef.where('username', isEqualTo: username).get();
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }

  Future<void> saveUser(User user) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    try {
      await usersRef.doc().set({
        'username': user.username,
        'password': user.password,
        'userrole': user.userrole,
        'farmingarea': user.farmingarea,
        'farmingtype': user.farmingtype,
        'status': user.status,
        'nic': user.nic,
        'isfarming': user.isfarming
      });
      print("User saved successfully!");
    } catch (e) {
      print("Error saving user: $e");
    }
  }

  Future<String?> loginCheck(String username, String password) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    try {
      final querySnapshot = await usersRef
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Login successful
        final userDoc = querySnapshot.docs.first;
        return userDoc.get('userrole');
      } else {
        // Login failed (invalid username or password)
        return null;
      }
    } catch (e) {
      print("Login check failed: $e");
      return null;
    }
  }

  Future<List<User>> fetchAllUsers() async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await usersRef.get();
    try {
      return querySnapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
    } catch (e) {
      print("Error fetching seeds: $e");
      return [];
    }
  }

  Future<void> updateUserStatus(String username, String newStatus) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    try {
      print(username);
      final querySnapshot =
          await usersRef.where('username', isEqualTo: username).get();
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final docId = userDoc.id;
        await usersRef.doc(docId).update({'status': newStatus});
        print("User status updated successfully!");
      } else {
        print("User with ID '$username' not found.");
      }
    } catch (e) {
      print("Error updating user status: $e");
    }
  }

  Future<List<User>> fetchAllUsersByStatus(String status) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final querySnapshot =
        await usersRef.where('status', isEqualTo: status).get();
    try {
      return querySnapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
    } catch (e) {
      print("Error fetching seeds: $e");
      return [];
    }
  }

  Future<User> getUser(String username) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    try {
      final querySnapshot =
          await usersRef.where('username', isEqualTo: username).get();
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        return User.fromMap(userData);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print("Error checking user existence: $e");
      rethrow;
    }
  }

  Future<void> updateUIsFarmingStatus(String username, String status) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    try {
      print(username);
      final querySnapshot =
      await usersRef.where('username', isEqualTo: username).get();
      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final docId = userDoc.id;
        await usersRef.doc(docId).update({'isfarming': status});
        print("User isfarming updated successfully!");
      } else {
        print("User with ID '$username' not found.");
      }
    } catch (e) {
      print("Error updating user isfarming: $e");
    }
  }

  Future<List<User>> fetchAllUsersWithFarming() async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await usersRef.get();
    try {
      return querySnapshot.docs
          .map((doc) => User.fromMap(doc.data()))
          .where((user) => user.getUserrole == 'Farmer' && user.getIsfarming == 'true')
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

}
