import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  // Simpan role user ke Firestore
  Future<void> saveUserRole(String uid, String email, String role) async {
    await users.doc(uid).set({'email': email, 'role': role});
  }

  // Ambil role user dari Firestore
  Future<String?> getUserRole(String uid) async {
    final doc = await users.doc(uid).get();
    if (doc.exists) {
      return doc['role'] as String?;
    }
    return null;
  }

  // Ambil semua data user (role, name, email, dll)
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await users.doc(uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }
}
