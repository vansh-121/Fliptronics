import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController contactnoController = TextEditingController();
  File? pickedimage;
  String? imageUrl;

  // Mock UID, in a real app you would get this from Firebase Auth or another source
  final String userUid =
      "mockUserId"; // Replace with FirebaseAuth.instance.currentUser!.uid

  @override
  void initState() {
    super.initState();
    loadProfileData(); // Load data when the page is opened
  }

  // Method to load profile data from Firebase Firestore
  Future<void> loadProfileData() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userUid) // Using UID as the document reference
          .get();
      if (doc.exists) {
        var data = doc.data();
        if (data != null) {
          setState(() {
            nameController.text = data['Name'];
            genderController.text = data['Gender'];
            contactnoController.text = data['Contact No.'];
            imageUrl = data['Profile Pic']; // Load the image URL from Firestore
          });
        }
      }
    } catch (e) {
      print("Failed to load profile data: $e");
    }
  }

  // Method to save details including profile picture to Firebase Firestore
  savedetails(String name, String gender, String contactno) async {
    if (name == "" || gender == "" || contactno == "" || pickedimage == null) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: context.theme.cardColor,
            title: const Text("Required"),
            content: const Text("Enter required fields !!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Ok"),
              ),
            ],
          );
        },
      );
    } else {
      try {
        // Upload the profile picture to Firebase Storage and get the download URL
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("User_Profile_Pics")
            .child(
                userUid) // Use UID or unique identifier for saving profile pics
            .putFile(pickedimage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();

        // Save details in Firebase Firestore using UID
        FirebaseFirestore.instance.collection("Users").doc(userUid).set({
          "Name": name,
          "Gender": gender,
          "Contact No.": contactno,
          "Profile Pic": url
        }).then((value) {
          print("Data uploaded");
          setState(() {
            imageUrl = url; // Update the state to show the image
          });
        });
      } catch (ex) {
        print(ex.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.cardColor,
      appBar: AppBar(
        title: Text("Your Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40), // Add some space from the top
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: context.theme.cardColor,
                        title: Text("Pick Image from"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              onTap: () {
                                pickimage(ImageSource.camera);
                                Navigator.pop(context);
                              },
                              leading: Icon(CupertinoIcons.photo_camera),
                              title: Text("Camera"),
                            ),
                            ListTile(
                              onTap: () {
                                pickimage(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                              leading: Icon(Icons.image),
                              title: Text("Gallery"),
                            )
                          ],
                        ),
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
                },
                // Display picked image or the image URL from Firestore
                child: pickedimage != null
                    ? CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(pickedimage!), // Local image
                      ).px32()
                    : imageUrl != null
                        ? CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                                imageUrl!), // Loaded from Firestore
                          ).px32()
                        : CircleAvatar(
                            radius: 80,
                            child: Icon(
                              CupertinoIcons.person_solid,
                              size: 80,
                            ),
                          ),
              ).px32(),
              SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your Name",
                  labelText: "Name",
                ),
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name";
                  }
                  return null;
                },
              ).px32(),
              SizedBox(height: 15),
              TextFormField(
                controller: genderController,
                decoration: const InputDecoration(
                  hintText: "Male/Female",
                  labelText: "Gender",
                ),
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Gender";
                  }
                  return null;
                },
              ).px32(),
              SizedBox(height: 15),
              TextFormField(
                controller: contactnoController,
                decoration: const InputDecoration(
                  hintText: "Enter your contact details",
                  labelText: "Contact Number",
                ),
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Contact Number";
                  }
                  return null;
                },
              ).px32(),
              SizedBox(height: 49),
              ElevatedButton(
                onPressed: () {
                  savedetails(
                    nameController.text,
                    genderController.text,
                    contactnoController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.shadowColor,
                ),
                child: "Save Details".text.color(Colors.white).make(),
              ).px32(),
              SizedBox(height: 20), // Add space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // Method to pick an image from camera or gallery
  pickimage(ImageSource imagesource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imagesource);
      if (photo == null) return;
      final imagepath = File(photo.path);
      setState(() {
        pickedimage = imagepath;
      });
    } catch (ex) {
      print(ex.toString());
    }
  }
}
