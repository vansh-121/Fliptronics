import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter/material.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.cardColor,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Form(
          key: _formKey, // Assign the GlobalKey to the Form
          child: Column(
            children: [
              TextFormField(
                controller: phoneController,
                // Use the controller to get the input
                decoration: const InputDecoration(
                  hintText: "Enter your phone number",
                  labelText: "Phone Number",
                  prefixText: '+91 ', // Add country code prefix
                ),
                keyboardType:
                    TextInputType.phone, // Set keyboard type for phone input
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your phone number";
                  } else if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                    return "Please enter a valid 10-digit phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '+91${phoneController.text.trim()}',
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        // Automatically sign the user in
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                      },
                      verificationFailed: (FirebaseAuthException exception) {
                        // Display an error message
                        if (kDebugMode) {
                          print("Error: ${exception.message}");
                        }
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        Navigator.of(context).pushNamed(
                          '/otpverify',
                          arguments: verificationId,
                        );
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        // Handle auto-retrieval timeout
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).shadowColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Confirm"),
              )
            ],
          ).p16(),
        )
      ]).p16(),
    );
  }
}
