import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalogue/pages/home_page.dart';
import 'package:flutter_catalogue/utils/routes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String name = '';
  String email = '';
  String password = '';
  bool changeButton = false;
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
                Image.asset(
                  "assets/images/signup.png",
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text(
                  "Create Account !",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 28),
                ),
                SizedBox(height: 10),
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
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Enter your email", labelText: "Email"),
                        onChanged: (value) {
                          email = value;
                          setState(() {});
                        },
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
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
                        },
                      ),
                      const SizedBox(height: 10),
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
                          changeButton = true;
                        });

                        try {
                          // Check if the account exists
                          final signInMethods = await FirebaseAuth.instance
                              .fetchSignInMethodsForEmail(email);

                          if (signInMethods.isNotEmpty) {
                            // Account already exists, show dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Account Already Exists'),
                                  content: const Text(
                                      'An account with this email already exists. Please log in.'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Login'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close dialog
                                        Navigator.pushNamed(
                                            context,
                                            Routes
                                                .loginRoute); // Navigate to login
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Create new account
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            // Show success dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Congratulations!'),
                                  content: const Text(
                                      'You\'re now part of our experiences!'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Continue'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close dialog
                                        Navigator.pushNamed(
                                            context,
                                            Routes
                                                .HomeRoute); // Navigate to home page
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } catch (e) {
                          print('Error: $e');
                          // Handle error (e.g., show error dialog)
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
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
                          changeButton = false;
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: changeButton ? 50 : 100,
                      height: 40,
                      alignment: Alignment.center,
                      child: changeButton
                          ? const Icon(
                              Icons.done,
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/login");
                      },
                      child: Text(
                        "Already have an account ?",
                        style: TextStyle(
                          color: context.theme.highlightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _googleSignUpButton(),
                const SizedBox(height: 15),
                _facebookSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _googleSignUpButton() {
    return Center(
      child: SizedBox(
        height: 40,
        child: SignInButton(
          Buttons.google,
          text: "Sign Up with Google",
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
                  print("Signed up with Google!!");
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

  Widget _facebookSignUpButton() {
    return Center(
      child: SizedBox(
        height: 40,
        child: SignInButton(
          Buttons.facebook,
          text: "Sign Up with Facebook",
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
                  print("Signed up with Facebook!!");
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
                print('Sign-up cancelled by the user.');
                break;

              case FacebookLoginStatus.error:
                print('Error while signing up with Facebook: ${result.error}');
                break;
            }
          },
        ),
      ),
    );
  }
}
