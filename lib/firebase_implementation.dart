import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

class FirebaseImplementation extends ChangeNotifier{
  FirebaseImplementation(){
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
    FirebaseAuth auth = FirebaseAuth.instance;

  //TODO: implementation av firebase auth och firestore
  }
void stateChanges(){
  FirebaseAuth.instance.authStateChanges().listen((User? user){
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
  }

  void tokenChanges(){
  FirebaseAuth.instance
      .idTokenChanges()
      .listen((User? user) {
  if (user == null) {
  print('User is currently signed out!');
  } else {
  print('User is signed in!');
  }
  });
  }

  void userChanges(){
    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
}


void createNewUser({required String email, required String password}) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch (e){
      if(e.code == 'weak-password'){
        throw FirebaseAuthException (code: 'weak-password');
      }else if(e.code == 'email-already-in-use'){
        throw FirebaseAuthException(code: 'email-already-in-use');
      }
    }catch(e){
      throw Exception(e);
    }
    
}
//TODO: skicka verifikationsmejl till nya användare

void logIn({required String email, required String password}) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
        throw FirebaseAuthException (code: e.code);
      }else if(e.code == 'wrong-password'){
        throw FirebaseAuthException(code: e.code);
      }
    }catch(e){
      throw Exception(e);
    }
}

void signOut() async{
  await FirebaseAuth.instance.signOut();
}

void deleteUser() async{
    try{
      await FirebaseAuth.instance.currentUser!.delete();
    }on FirebaseAuthException catch (e){
      if(e.code == 'requires-recent-login'){
        throw Exception('The user must authenticate to be able to delete account');
      }
    }
}

void reauthenticateUser({required String email,required String password}) async{//TODO: lägg till try här med
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
  }



}