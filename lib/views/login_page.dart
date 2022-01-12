import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/models/firebase/firebase_implementation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../game_engine/error_handling.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Stack(
        children: [
          _logInTitle(),
          _loginFieldsAndButton(context),
          _registerText(context),
        ],
      ),
    );
  }

  Widget _logInTitle() {
    //Titel för Login
    return const Padding(
      padding: EdgeInsets.only(left: 75, top: 30),
      child: Text(
        'Blackjack',
        style: TextStyle(fontSize: 60),
      ),
    );
  }

  Widget _loginFieldsAndButton(BuildContext context) {
    //textfält för email och lösenord samt login knapp
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 175,
          ),
          child: TextField(
            //textfält email
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.email),
              labelText: 'Email',
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 250, bottom: 0),
          child: TextField(
            //textfält lösenord
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(Icons.password),
              labelText: 'Password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 130,
            top: 355,
          ),
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 0.15,
            child: ElevatedButton(
              //login knapp
              child: const Text('Log in'),
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  //kollar om fälten ej är tomma och kallar sen på login metoden i FirebaseImplementation
                  try {
                    Provider.of<FirebaseAuthImplementation>(context,
                            listen: false)
                        .logIn(
                            context: context,
                            email: emailController.text,
                            password: passwordController.text);
                    emailController.clear();
                    passwordController.clear();
                  } on FirebaseAuthException catch (e) {
                    ErrorHandling().errorHandling(e, context);
                  }
                } else if (emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ErrorHandling().errorHandling(
                      'One or both of the textfields are empty', context);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _registerText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 130, right: 0, top: 600),
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'New user? ',
              style: TextStyle(color: Colors.black),
            ),
            // gör så att man kan klicka på texten
            TextSpan(
                text: 'Create account',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _registerNewUserDialog(context);
                  })
          ],
        ),
      ),
    );
  }

  void _registerNewUserDialog(context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      //dekoration för popup-menyn
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
            Center(
              child: ElevatedButton(
                child: const Text(
                  'Register & Log In',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  //kollar så att textfälten inte är tomma
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    try {
                      Provider.of<FirebaseAuthImplementation>(context,
                              listen: false)
                          .createNewUser(
                              context: context,
                              email: emailController.text,
                              password: passwordController.text);
                    } on FirebaseAuthException catch (e) {
                      ErrorHandling().errorHandling(e, context);
                    }

                    emailController.clear();
                    passwordController.clear();
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
