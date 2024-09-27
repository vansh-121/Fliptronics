import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalogue/utils/routes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '';
  bool changebutton = false;

  GoogleSignIn googleAuth = GoogleSignIn(
    serverClientId:
        '590193531184-ont553hvvvmicu965evaekb7iqefupqv.apps.googleusercontent.com',
  );

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
        color: context.theme.cardColor,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/login.png",
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome $name!",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 28),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  child: Column(
                    children: [
                      TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Enter your username",
                              labelText: "Username"),
                          onChanged: (value) {
                            name = value;
                            setState(() {});
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your username";
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: "Enter your password",
                              labelText: "Password"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password.";
                            } else if (value.length < 6) {
                              return "Password length must be greater than 6.";
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/forgot");
                            },
                            child: Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                color: context.theme.hintColor, // Red color
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Material(
                  color: const Color.fromARGB(255, 68, 61, 209),
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          changebutton = true;
                        });
                        await Future.delayed(const Duration(seconds: 1));
                        await Navigator.pushNamed(context, Routes.HomeRoute);
                        setState(() {
                          changebutton = false;
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: changebutton ? 50 : 100,
                      height: 40,
                      alignment: Alignment.center,
                      child: changebutton
                          ? const Icon(
                              Icons.done,
                              color: Colors.white,
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // TextButton(
                //   onPressed: () {
                //     googleAuth.signIn().then((result) {
                //       result?.authentication.then((googleKey) {
                //         FirebaseAuth.instance
                //             .signInWithCredential(GoogleAuthProvider.credential(
                //                 idToken: googleKey.idToken,
                //                 accessToken: googleKey.accessToken))
                //             .then((signedInUser) {
                //           print("Signed in !!");
                //           Navigator.of(context).pushReplacementNamed("/home");
                //         }).catchError((e) {
                //           print(e);
                //         });
                //       }).catchError((e) {
                //         print(e);
                //       });
                //     }).catchError((e) {
                //       print(e);
                //     });
                //   },
                //   child: const Text("Sign in with Google",
                //       style: TextStyle(
                //         color: Color.fromARGB(255, 5, 3, 180),
                //         fontWeight: FontWeight.bold,
                //         fontSize: 15,
                //       )),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                _googleSignInButton(),
              ],
            ),
          ),
        ));
  }

  // Moved this method outside the widget tree
  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 40,
        child: SignInButton(
          Buttons.google,
          text: "Sign In with Google",
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            googleAuth.signIn().then((result) {
              result?.authentication.then((googleKey) {
                FirebaseAuth.instance
                    .signInWithCredential(GoogleAuthProvider.credential(
                        idToken: googleKey.idToken,
                        accessToken: googleKey.accessToken))
                    .then((signedInUser) {
                  print("Signed in with Google!!");
                  Navigator.of(context).pushReplacementNamed("/home");
                }).catchError((e) {
                  print(e);
                });
              }).catchError((e) {
                print(e);
              });
            }).catchError((e) {
              print(e);
            });
          },
        ),
      ),
    );
  }
}
