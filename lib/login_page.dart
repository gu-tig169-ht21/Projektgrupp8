import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_first_app/firebase_implementation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: 'Password',
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  child: const Text('Log in'),
                  onPressed: () {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      try {
                        Provider.of<FirebaseAuthImplementation>(context,
                                listen: false)
                            .logIn(
                                email: emailController.text,
                                password: passwordController.text);
                        emailController.clear();
                        passwordController.clear();
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          //TODO: gör något vid fel
                        } else if (e.code == 'wrong-password') {
                          //TODO:gör något
                        }
                      } catch (e) {
                        //TODO:kasta generellt felmeddelande
                      }
                    } else {
                      //TODO: gör så att textfälten som ej är ifyllda blir markerade
                    }
                  },
                ),
                ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () {
                    _registerNewUserDialog();
                  },
                ),
              ],
            )
          ],
        ));
  }

  void _registerNewUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Register new user'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  labelText: 'Password',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('register & log In'),
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  try {
                    Provider.of<FirebaseAuthImplementation>(context,
                            listen: false)
                        .createNewUser(
                            email: emailController.text,
                            password: passwordController.text);

                    emailController.clear();
                    passwordController.clear();
                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      //TODO: gör något vid fel
                      print('weak');
                    } else if (e.code == 'email-already-in-use') {
                      //TODO:gör något
                      print('already in use');
                    }
                  } catch (e) {
                    //TODO:kasta generellt felmeddelande
                    print(e);
                  }
                } else {
                  //TODO: gör så att textfälten som ej är ifyllda blir markerade
                }
              },
            ),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
