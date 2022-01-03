import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/firebase_implementation.dart';
import 'package:provider/provider.dart';

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController oldPassword= TextEditingController(), newPassword= TextEditingController(), verifyNewPassword = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('User profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.portrait, size: 100),
          Text(
              'Email: ${Provider.of<FirebaseImplementation>(context, listen: true).getUserEmail()}'),
          ListTile(
            title: const Text('Log out'),
            subtitle: const Text('Logs you out of your account'),
            onTap: (){
              Provider.of<FirebaseImplementation>(context, listen: false).signOut();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Change password'),
            subtitle: const Text('changes your password'),
            onTap: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: const Text('Change your password'),
                  content: Column(children:[TextField(
                    controller: oldPassword,
                    decoration: const InputDecoration(
                      labelText: 'Old Password',
                    ),
                  ),
                    TextField(
                      controller: newPassword,
                      decoration: const InputDecoration(
                        labelText: 'New password'
                      ),
                    ),
                    TextField(
                      controller: verifyNewPassword,
                      decoration: const InputDecoration(
                        labelText: 'verify new password'
                      ),
                    ),
                  ],
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text('Change password'),
                      onPressed: (){
                        if(newPassword.text == verifyNewPassword.text){
                          try {
                            Provider.of<FirebaseImplementation>(
                                context, listen: false).changeUserPassword(
                                oldPassword.text, newPassword.text);
                            Navigator.pop(context);
                          }
                          on FirebaseAuthException catch (e){
                            if(e.code == 'user-not-found'){
                              //TODO: gör nåt jävla skit
                            }
                            else if(e.code == 'wrong-password'){
                              //TODO: gör nåt annat jävla skit
                            }
                          }
                          catch (e){
                            //TODO: gör generell jävla skit
                          }
                        }
                        else{
                          print('passwords didnt match');
                        }
                      },
                    )
                  ],
                );
              });
            },
          )
        ],
      ),
    );
  }
}
