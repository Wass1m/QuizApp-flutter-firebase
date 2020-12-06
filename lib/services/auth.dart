import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User getUser() => _auth.currentUser;

  Stream<User> get user => _auth.authStateChanges();

  Future signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      updateUserData(user);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User> signInWithGoogle() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> updateUserData(User user) {
    DocumentReference reportRef = _db.collection('reports').doc(user.uid);
    return reportRef.set({'uid': user.uid, 'lastActivity': DateTime.now()},
        SetOptions(merge: true));
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
