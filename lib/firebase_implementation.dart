import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class FirebaseAuthImplementation extends ChangeNotifier {
  FirebaseAuthImplementation() {
    init();
  }
  Future<void> init() async {
    _auth = FirebaseAuth.instance;
  }

  bool _usrLoggedIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;


  String? getUserEmail(){
    return _auth.currentUser?.email;
  }

  bool isUserLoggedIn() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _usrLoggedIn = false;
        notifyListeners();
      } else {
        _usrLoggedIn = true;
        notifyListeners();
      }
    });
    return _usrLoggedIn;
  }

  void createNewUser({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw FirebaseAuthException(code: 'weak-password');
      } else if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(code: 'email-already-in-use');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
//TODO: skicka verifikationsmejl till nya användare

  void logIn({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(code: e.code);
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(code: e.code);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void signOut() async {
    await _auth.signOut();
  }

  void deleteUser(String password) async {
    String? email = _auth.currentUser?.email;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email!, password: password);

      _auth.currentUser!.delete().then((_){
        print('user deleted');//TODO: felutskrift
      }).catchError((error){
        print('Deletion not completed: ' + error.toString());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception(
            'The user must authenticate to be able to delete account');
      }
    }
  }

  void changeUserPassword(String password, String newPassword) async{
    String? email = _auth.currentUser?.email;

    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email!, password: password);

      _auth.currentUser?.updatePassword(newPassword).then((_){
        print('succesully changes password');
      }).catchError((error){
        print('password cant be changed: ' + error.toString());
      });
    }
    on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
        throw FirebaseAuthException(code: 'user-not-found');
      }else if (e.code == 'wrong-password'){
        throw FirebaseAuthException(code: 'wrong-password');
      }
    }
  }

  void reauthenticateUser(
      {required String email, required String password}) async {
    //TODO: lägg till try här med
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }
}
class FirestoreImplementation extends ChangeNotifier{
  FirestoreImplementation(){
    init();
  }

  Future<void> init() async {
    database = FirebaseFirestore.instance;
    //TODO: implementation av firestore
  }

  FirebaseFirestore database = FirebaseFirestore.instance;
  CollectionReference statistics = database.collection('Statistics');
}

