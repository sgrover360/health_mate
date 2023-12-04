import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:health_mate/models/chat_user.dart';
import 'package:health_mate/views/doctor_register.dart';
import 'package:health_mate/views/home_page.dart';
import 'package:health_mate/views/login_controller.dart';

import 'doctor_home_page.dart';

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
        resizeToAvoidBottomInset: true,
        body: Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top),
            child: SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.asset('assets/logo.png'),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Health Mate',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(width: 35)
                    ],
                  ),
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
                        : "Want to register?"),
                    onPressed: () {
                      setState(() {
                        _registerMode = !_registerMode;
                      });
                    },
                  ),
                  TextButton(
                    child: const Text('Doctor? Register Here'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegistrationForm()));
                    },
                  )
                ]),
          ),
        ));
  }

  Future _login() async {
    try {
      var user = await _controller.login(_mailController?.text.trim() ?? "",
          _passwordController?.text.trim() ?? "");

      _passwordController?.text = "";
      _passwordConfirmController?.text = "";

      if (user.isDoctor == false) {
        await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HomePage(user: user)));
      }
      else if (user.isDoctor == true) {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DoctorHomePage(doctor: user)));
      }
      else {
        const snackBar = SnackBar(
          content: Text('Your documents is under verification. We will send an email once your doctor account is activated'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.message ?? ""), backgroundColor: Colors.red,));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      ChatUser chatUser = await _controller.signInWithGoogle();
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
