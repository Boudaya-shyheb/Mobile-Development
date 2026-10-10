import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _authOverride = auth,
      _firestoreOverride = firestore;

  final FirebaseAuth? _authOverride;
  final FirebaseFirestore? _firestoreOverride;
  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<UserCredential> signUp({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User creation failed.',
      );
    }

    try {
      await user.updateDisplayName(fullName.trim());

      await _firestore.collection('users').doc(user.uid).set({
        'fullName': fullName.trim(),
        'phone': phone.trim(),
        'email': user.email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } catch (_) {
      // Keep Authentication and Firestore in sync if profile creation fails.
      await user.delete();
      rethrow;
    }
    return credential;
  }

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> signOut() => _auth.signOut();

  Future<Map<String, dynamic>?> getProfile(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();
    return snapshot.data();
  }
}

String authErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'invalid-email' => 'Please enter a valid email address.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'The email or password is incorrect.',
      'email-already-in-use' => 'An account already exists for this email.',
      'weak-password' => 'Choose a stronger password (at least 8 characters).',
      'network-request-failed' =>
        'Connection problem. Check your internet and try again.',
      'too-many-requests' => 'Too many attempts. Please try again later.',
      'operation-not-allowed' =>
        'Email and password sign-in is not enabled in Firebase.',
      _ => 'We could not complete your request. Please try again.',
    };
  }
  if (error is FirebaseException && error.plugin == 'cloud_firestore') {
    return 'Your account could not be saved. Please check your connection and try again.';
  }
  return 'Firebase is not configured yet. Connect this app to your Firebase project and try again.';
}
