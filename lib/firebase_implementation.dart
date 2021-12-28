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

  //TODO: implementation av firebase auth och firestore
  }




}