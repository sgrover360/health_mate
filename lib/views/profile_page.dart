import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';

import '../models/user_data.dart';

class ProfilePage extends ProfileScreen {
  ProfilePage({
    super.key,
    super.auth,
    super.providers,
  });

  User? user = FirebaseAuth.instance.currentUser;
  bool _isEditing = false;
  late UserData newUser;

  Future<bool> _reauthenticate(BuildContext context) {
    final l = FirebaseUILocalizations.labelsOf(context);
    return showReauthenticateDialog(
      context: context,
      providers: providers,
      auth: auth,
      onSignedIn: () => Navigator.of(context).pop(true),
      actionButtonLabelOverride: l.deleteAccount,
    );
  }

  @override
  Widget build(BuildContext context) {
    newUser = UserData(id: user!.uid, email: user!.email!);
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 171, 175),
                    Color.fromARGB(255, 251, 145, 145)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 0.9],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: user!.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : null,
                          child: user!.photoURL == null
                              ? const Icon(Icons.person, size: 65)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    user!.displayName ?? newUser.name,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  title: const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    user!.email!,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                    title: const Text(
                      'Phone',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        SizedBox(
                            width: 120,
                            child: TextFormField(
                              decoration:
                              const InputDecoration(hintText: 'xxx-xxxxxxx'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter valid phone number';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                newUser.phone = value!;
                              },
                            )),
                        const SizedBox(width: 25),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _isEditing = !_isEditing;
                          },
                        )
                      ],
                    )),
                const SizedBox(height: 55),
                SizedBox(
                  width: 300,
                  height: 45,
                  child: InkWell(
                    splashColor: const Color.fromARGB(255, 176, 220, 240),
                    hoverColor: const Color.fromARGB(255, 214, 231, 239),
                    highlightColor: Colors.blueGrey,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          size: 40,
                          color: Color.fromARGB(255, 111, 198, 239),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Sign out',
                          style: TextStyle(
                              color: Color.fromARGB(255, 111, 198, 239),
                              fontSize: 25,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    onTap: () => FirebaseUIAuth.signOut(
                      context: context,
                      auth: auth,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                DeleteAccountButton(
                  auth: auth,
                  onSignInRequired: () {
                    return _reauthenticate(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
