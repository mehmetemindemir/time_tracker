import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({@required this.uid});

  final String uid;
}

abstract class AuthBase {
  Future<User> currentUser();
  Future<User> signInWithAnonymously();
  Future<void> signOut();
  Stream<User> get onAurhStateChanged;
  Future<User> signWithGoogle();
  Future<User> signWithEmail(String email,String password);
  Future<User> creatWithEmail(String email,String password);
}

class Auth implements AuthBase{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFireBase(FirebaseUser user) {
    if (null == user) {
      return null;
    }
    return User(uid: user.uid);
  }
  Stream<User> get onAurhStateChanged{
    return _firebaseAuth.onAuthStateChanged.map(_userFromFireBase);
  }
  Future<User> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFireBase(user);
  }
  Future<User> signWithEmail(String email,String password)async{
    AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFireBase(user.user);
  }
  Future<User> creatWithEmail(String email,String password)async{
    AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFireBase(user.user);
  }
  Future<User> signInWithAnonymously() async {
    AuthResult user = await _firebaseAuth.signInAnonymously();
    return _userFromFireBase(user.user);
  }
Future<User> signWithGoogle() async{
    GoogleSignIn googleSignIn=GoogleSignIn();
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if(null!=googleUser){
      GoogleSignInAuthentication googleAuth =  await googleUser.authentication;
      if(null!=googleAuth.accessToken && null!=googleAuth.idToken){
        AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
        FirebaseUser user = authResult.user;
        return _userFromFireBase(user);
      }else{
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }

    }else{
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

}
  Future<void> signOut() async {
    final googleSignIn=GoogleSignIn();
    await googleSignIn.signOut();
    return await _firebaseAuth.signOut();
  }
}
