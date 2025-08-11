import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // Login dengan Email & Password
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil data lengkap user dari Firestore
      final userData = await _userService.getUserData(credential.user!.uid);
      print("User Data: $userData"); // Bisa dipakai untuk debugging

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login gagal");
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Ambil user saat ini
  User? get currentUser => _auth.currentUser;
}
