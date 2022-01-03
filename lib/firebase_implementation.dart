import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class FirebaseImplementation extends ChangeNotifier {
  FirebaseImplementation() {
    init();
  }

  bool usrLoggedIn = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> init() async {
    auth = FirebaseAuth.instance;
     //TODO: implementation av firebase auth och firestore
  }

  String? getUserEmail(){
    return auth.currentUser?.email;
  }

  bool isUserLoggedIn() {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        usrLoggedIn = false;
        notifyListeners();
      } else {
        usrLoggedIn = true;
        notifyListeners();
      }
    });
    return usrLoggedIn;
  }

  void tokenChanges() {
    auth.idTokenChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  void userChanges() {
    auth.userChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  void createNewUser({required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
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
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
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
    await auth.signOut();
  }

  void deleteUser() async {
    try {
      await auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception(
            'The user must authenticate to be able to delete account');
      }
    }
  }

  void changeUserPassword(String password, String newPassword) async{
    String? email = auth.currentUser?.email;

    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email!, password: password);

      auth.currentUser?.updatePassword(newPassword).then((_){
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
    await auth.currentUser!.reauthenticateWithCredential(credential);
  }
}
