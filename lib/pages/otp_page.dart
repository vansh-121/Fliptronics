import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class OtpPage extends StatefulWidget {
  String verificationid;
  OtpPage({super.key, required this.verificationid});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: const Text("Verify OTP"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey, // Use the same GlobalKey for form validation
            child: Column(
              children: [
                TextFormField(
                  controller: otpController, // OTP controller for input
                  decoration: const InputDecoration(
                    hintText: "Enter the OTP",
                    labelText: "OTP",
                  ),
                  keyboardType:
                      TextInputType.number, // Set keyboard for number input
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the OTP";
                    } else if (!RegExp(r"^[0-9]{6}$").hasMatch(value)) {
                      return "Please enter a valid 6-digit OTP";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    
                    if (_formKey.currentState!.validate()) {
                      try {
                        PhoneAuthCredential credential =
                            await PhoneAuthProvider.credential(
                                verificationId: widget.verificationid,
                                smsCode: otpController.text.toString());
                        FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) {
                          Navigator.of(context).pushReplacementNamed('home');
                        });
                      } catch (ex) {
                        print(ex.toString()); // Log the error message
                      }
                      showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: context.theme.cardColor,
                          title: const Text("Verified"),
                          content: const Text("OTP Verified"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed(
                                    '/home'); // Close the dialog
                              },
                              child: Text("Login"),
                            ),
                          ],
                        );
                      },
                    );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).shadowColor,
                      foregroundColor: Colors.white),
                  child: const Text("Verify OTP"),
                ),
              ],
            ).p16(),
          )
        ],
      ).p16(),
    );
  }

  @override
  void dispose() {
    otpController.dispose(); // Dispose the controller to free resources
    super.dispose();
  }
}
