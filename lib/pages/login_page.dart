import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalogue/pages/home_page.dart';
import 'package:flutter_catalogue/utils/routes.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:math' as math;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '';
  String email = '';
  String password = '';
  bool changebutton = false;
  final fb = FacebookLogin();
  GoogleSignIn googleAuth = GoogleSignIn(
    clientId:
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
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    width:
                        math.min(MediaQuery.of(context).size.width * 0.6, 350),
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? "assets/images/login_dark.png"
                          : "assets/images/login.png",
                      fit: BoxFit.contain,
                    ),
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
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: Column(
                      children: [
                        TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Enter your email",
                                labelText: "Email"),
                            onChanged: (value) {
                              email = value;
                              setState(() {});
                            },
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: "Enter your password",
                                labelText: "Password"),
                            onChanged: (value) {
                              password = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your password.";
                              } else if (value.length < 6) {
                                return "Password length must be greater than 6.";
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
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
                          height: 5,
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
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);
                            await Navigator.pushNamed(
                                context, Routes.HomeRoute);
                          } catch (e) {
                            // Show error dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Login Failed'),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
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
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/signup");
                        },
                        child: Text(
                          "New user ? Sign up now!",
                          style: TextStyle(
                            color: context.theme.highlightColor, // Red color
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _googleSignInButton(),

                  SizedBox(height: 15),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pushNamed("/phoneverification");
                  //   },
                  //   child: Text(
                  //     "Use Phone Number Instead",
                  //     style: TextStyle(
                  //       color: context.theme.focusColor,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15,
                  //     ),
                  //   ),
                  // ),
                  _facebookSignInButton(),
                ],
              ),
            ),
          ),
        ));
  }

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

  Widget _facebookSignInButton() {
    return Center(
      child: SizedBox(
        height: 40,
        child: SignInButton(
          Buttons.facebook,
          text: "Sign In with Facebook",
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () async {
            final result = await fb.logIn(permissions: [
              FacebookPermission.publicProfile,
              FacebookPermission.email,
            ]);

            switch (result.status) {
              case FacebookLoginStatus.success:
                final accessToken = result.accessToken;
                final facebookAuthCredential =
                    FacebookAuthProvider.credential(accessToken!.token);
                FirebaseAuth.instance
                    .signInWithCredential(facebookAuthCredential)
                    .then((signedInUser) {
                  print("Signed in with Facebook!!");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage()), // Navigate directly to the home screen
                  );
                }).catchError((e) {
                  print(e);
                });
                break;

              case FacebookLoginStatus.cancel:
                print('Login cancelled by the user.');
                break;

              case FacebookLoginStatus.error:
                print('Error during login: ${result.error}');
                break;
            }
          },
        ),
      ),
    );
  }
}
