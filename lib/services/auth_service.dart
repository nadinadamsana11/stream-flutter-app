import 'package:firebase_auth/firebase_auth.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signUpWithEmail(String email, String password, String username) async {
    try {
      // 1. Create Auth User
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      
      if (user != null) {
        // 2. Update Display Name
        await user.updateDisplayName(username);
        // 3. Create Firestore Doc
        await _dbService.createUserDoc(user.uid, email, username);
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Note: For Google Sign In on mobile, you need the 'google_sign_in' package.
  // This is a placeholder for the logic found in your auth.js
  Future<void> signInWithGoogle() async {
    // Implementation depends on platform (Web vs Mobile)
    // On Flutter Web, signInWithPopup is handled automatically by firebase_auth
    // On Mobile, you need GoogleSignIn().signIn() flow.
    throw UnimplementedError("Add google_sign_in package for mobile support");
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}