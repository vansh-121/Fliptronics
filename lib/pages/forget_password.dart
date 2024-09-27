import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalogue/widgets/text_field.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  final _formKey = GlobalKey<FormState>(); // Add this at the top of your widget
  String email = '';
  TextEditingController emailController = TextEditingController();
  forgotpassword(String email) async {
    if (email == "") {
      return Text("Please enter your email address");
    } else {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.cardColor,
      appBar: AppBar(
        title: Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // UiHelper.CustomTextField(
        //     emailController, "Enter your Email", Icons.mail, false),
        // SizedBox(
        //   height: 20,
        // ),
        Form(
          key: _formKey, // Assign the GlobalKey to the Form
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                // Use the controller to get the input
                decoration: const InputDecoration(
                    hintText: "Enter your email id", labelText: "Email"),

                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your email address";
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, proceed with the action
                    forgotpassword(emailController.text);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Success"),
                          content: Text("Check your gmail"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: context.theme.shadowColor,
                    foregroundColor: Colors.white),
                child: Text(
                  "Confirm",
                ),
              ),
            ],
          ).p16(),
        )
      ]).p16(),
    );
  }
}
