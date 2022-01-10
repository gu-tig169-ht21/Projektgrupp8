import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/firebase_implementation.dart';
import 'package:provider/provider.dart';

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User profile'),
      ),
      body: Column(
        children: [
          _profilePicture(),
          Text(
            'Email: ${Provider.of<FirebaseAuthImplementation>(context, listen: true).getUserEmail()}',
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
        Provider.of<FirebaseAuthImplementation>(context, listen: false)
            .signOut();
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
                        TextField(
                          controller: oldPassword,
                          decoration: const InputDecoration(
                            labelText: 'Old Password',
                          ),
                        ),
                        TextField(
                          controller: newPassword,
                          decoration: const InputDecoration(
                            labelText: 'New password',
                          ),
                        ),
                        TextField(
                          controller: verifyNewPassword,
                          decoration: const InputDecoration(
                              labelText: 'Verify new password'),
                        ),
                      ],
                    ),
                    actions: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: const Text('Change password'),
                            onPressed: () {
                              if (newPassword.text == verifyNewPassword.text) {
                                try {
                                  Provider.of<FirebaseAuthImplementation>(
                                          context,
                                          listen: false)
                                      .changeUserPassword(
                                          oldPassword.text, newPassword.text);
                                  Navigator.pop(context);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'User-not-found') {
                                    //TODO: gör nåt jävla skit, ändra i alertdialogen när du trycker på knappen?
                                  } else if (e.code == 'Wrong-password') {
                                    //TODO: gör nåt annat jävla skit
                                  }
                                } catch (e) {
                                  //TODO: gör generell jävla skit
                                }
                                oldPassword.clear();
                                newPassword.clear();
                                verifyNewPassword.clear();
                              } else {
                                print('passwords didnt match');
                              }
                            },
                          ),
                          ElevatedButton(
                            child: const Text('cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ]);
              });
        });
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
                          } on FirebaseAuthException catch (e) {
                            //TODO: implementera felhantering
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
