import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/firebase_implementation.dart';
import 'package:provider/provider.dart';
import 'blackjack.dart';

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? email = 'email';
    try {
      email = Provider.of<FirebaseAuthImplementation>(context, listen: true)
          .getUserEmail();
    } on Exception catch (e) {
      BlackJack.errorHandling(e, context);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('User profile'),
      ),
      body: Column(
        children: [
          _profilePicture(),
          Text(
            'Email: $email',
            style: const TextStyle(fontSize: 20),
          ),
          logOut(context),
          changePassword(context),
          deleteUser(context),
        ],
      ),
    );
  }

  Widget _profilePicture() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          shape: BoxShape.circle,
          image: const DecorationImage(
            fit: BoxFit.fill,
            //TODO: BYta profilbild!!!!!!!!
            image: AssetImage('assets/profilepicture.png'),
          ),
        ),
      ),
    );
  }

  Widget logOut(BuildContext context) {
    return ListTile(
      title: const Text('Log out'),
      subtitle: const Text('Logs you out of your account'),
      onTap: () {
        try {
          Provider.of<FirebaseAuthImplementation>(context, listen: false)
              .signOut();
        } on Exception catch (e) {
          BlackJack.errorHandling(e, context);
        }
        Navigator.pop(context);
      },
    );
  }

  Widget changePassword(BuildContext context) {
    TextEditingController oldPassword = TextEditingController(),
        newPassword = TextEditingController(),
        verifyNewPassword = TextEditingController();
    return ListTile(
      title: const Text('Change password'),
      subtitle: const Text('Changes your password'),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Change your password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 60,
                    child: TextField(
                      obscureText: true,
                      controller: oldPassword,
                      decoration: const InputDecoration(
                        labelText: 'Old Password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: TextField(
                      obscureText: true,
                      controller: newPassword,
                      decoration: const InputDecoration(
                        labelText: 'New password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: TextField(
                      obscureText: true,
                      controller: verifyNewPassword,
                      decoration: const InputDecoration(
                          labelText: 'Verify new password'),
                    ),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    child: const Text(
                      'Change password',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      if (newPassword.text == verifyNewPassword.text) {
                        try {
                          Provider.of<FirebaseAuthImplementation>(context,
                                  listen: false)
                              .changeUserPassword(
                                  oldPassword.text, newPassword.text);
                          Navigator.pop(context);
                        } on Exception catch (e) {
                          BlackJack.errorHandling(e, context);
                        }
                        oldPassword.clear();
                        newPassword.clear();
                        verifyNewPassword.clear();
                      } else {
                        throw Exception();
                      }
                    },
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    child: const Text(
                      'cancel',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget deleteUser(BuildContext context) {
    TextEditingController password = TextEditingController();
    return ListTile(
      title: const Text('Delete user'),
      subtitle: const Text('Delete the current user and their profile'),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Delete user?'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        'Are you sure you want to delete the user? this will remove all user data and game statistics. This cant be undone'),
                    TextField(
                      controller: password,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.password),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text('Delete user'),
                        onPressed: () {
                          try {
                            Provider.of<FirebaseAuthImplementation>(context,
                                    listen: false)
                                .deleteUser(password.text);
                            password.clear();
                          } on Exception catch (e) {
                            BlackJack.errorHandling(e, context);
                          }
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              );
            });
      },
    );
  }
}
//TODO: finlir och det sista som har med inloggning och användarhantering att göra.
 

