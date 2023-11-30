// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart'
//     hide EmailAuthProvider, AuthProvider;
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

// import 'app_routes.dart';

// class AuthGate extends StatelessWidget {
//   AuthGate({super.key});

//   final List<AuthProvider<AuthListener, AuthCredential>> providers = [
//     EmailAuthProvider(),
//     GoogleProvider(
//         clientId:
//             "1005622537424-ek0pnmrgkou172j6afli4ec8m0de9b8p.apps.googleusercontent.com")
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return SignInScreen(
//               providers: providers,
//               headerBuilder: (context, constraints, shrinkOffset) {
//                 return Column(
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Image.asset(
//                           'assets/logo.png',
//                           width: 100, // Set the desired width
//                           height: 100, // Set the desired height
//                         ),
//                       ),
//                     ),
//                     const Text(
//                       'Health Mate',
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 );
//               },
//               footerBuilder: (context, action) {
//                 return const Padding(
//                   padding: EdgeInsets.only(top: 16),
//                   child: Text(
//                     'By signing in, you agree to our terms and conditions.',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 );
//               },
//             );
//           } else {
//             // return const AppRoutes();
//           }
//         });
//   }
// }
///////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../models/chat_data.dart';
import '../controllers/chat_service.dart';
import '../views/home_page.dart';
// import 'package:health_mate/views/doctor_register.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _LoginPageState();
}

class _LoginPageState extends State<AuthGate> {
  final LoginController _controller = LoginController();
  TextEditingController? _mailController;
  TextEditingController? _passwordController;
  TextEditingController? _userController;
  TextEditingController? _passwordConfirmController;

  bool _registerMode = false;

  @override
  void initState() {
    super.initState();

    _userController = TextEditingController();
    _mailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _userController?.dispose();
    _mailController?.dispose();
    _passwordController?.dispose();
    _passwordConfirmController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Chip(
                  label: Text(
                      _registerMode ? "Register for chat" : "Login to chat")),
              if (_registerMode) const SizedBox(height: 10),
              if (_registerMode)
                SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _userController,
                      decoration:
                          const InputDecoration(label: Text("User name")),
                    )),
              const SizedBox(height: 10),
              SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _mailController,
                    decoration: const InputDecoration(label: Text("Email")),
                  )),
              const SizedBox(height: 10),
              SizedBox(
                  width: 200,
                  child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(label: Text("Password")))),
              if (_registerMode) const SizedBox(height: 10),
              if (_registerMode)
                SizedBox(
                    width: 200,
                    child: TextField(
                        controller: _passwordConfirmController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            label: Text("Confirm Password")))),
              const SizedBox(height: 20),
              Center(
                  child: SizedBox(
                width: 100,
                child: ElevatedButton(
                    child: Text(_registerMode ? "Register" : "Login"),
                    onPressed: () async =>
                        _registerMode ? await _register() : await _login()),
              )),
              const SizedBox(height: 20),
              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  try {
                    await signInWithGoogle();
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())));
                  }
                },
              ),
              TextButton(
                child: Text(_registerMode
                    ? "Want to log in?"
                    : "Want to register for chat?"),
                onPressed: () {
                  setState(() {
                    _registerMode = !_registerMode;
                  });
                },
              ),
              // TextButton(
              //   child: const Text('Doctor? Register Here'),
              //   onPressed: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) => const RegistrationForm()));
              //   },
              // )
            ])));
  }

  Future _login() async {
    try {
      var user = await _controller.login(_mailController?.text.trim() ?? "",
          _passwordController?.text.trim() ?? "");

      _passwordController?.text = "";
      _passwordConfirmController?.text = "";

      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage(user: user)));

      //await Navigator.of(context).push(
      //    MaterialPageRoute(builder: (context) => ChatOverviewPage(user)));
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.message ?? "")));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      ChatUser chatUser = await _controller.signInWithGoogle();

      // Navigate to the HomePage with the obtained ChatUser
      await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomePage(user: chatUser)));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future _register() async {
    try {
      if (_passwordController!.text != _passwordConfirmController!.text) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords don't match!")));
        return;
      }

      _controller.register(_mailController?.text.trim() ?? "",
          _passwordController?.text.trim() ?? "", _userController?.text ?? "");

      _passwordController?.text = "";
      _passwordConfirmController?.text = "";

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Account created! You may sign in now!")));

      setState(() {
        _registerMode = false;
      });
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.message ?? "")));
    }
  }
}
