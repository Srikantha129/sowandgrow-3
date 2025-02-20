dependencies:
  firebase_core: ^2.0.7
  cloud_firestore: ^4.2.3
  
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

==========================================================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

==========================================================================================

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

==========================================================================================

final collectionRef = _firestore.collection('users');

==========================================================================================

final docRef = _firestore.collection('users').doc('userId');

==========================================================================================

await collectionRef.add({
  'name': 'John Doe',
  'age': 30,
});

==========================================================================================

// Get all documents in a collection
final querySnapshot = await collectionRef.get();
final documents = querySnapshot.docs.map((doc) => doc.data()).toList();

// Get a specific document
final docSnapshot = await docRef.get();
if (docSnapshot.exists) {
  final data = docSnapshot.data();
} else {
  print('Document not found');
}

==========================================================================================

await docRef.update({
  'age': 31, // Update age field
});

==========================================================================================

await docRef.delete();
