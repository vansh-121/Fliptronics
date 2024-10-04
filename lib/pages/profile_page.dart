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
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("User_Profile_Pics")
            .child(name)
            .putFile(pickedimage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();
        FirebaseFirestore.instance.collection("Users").doc(name).set({
          "Name": name,
          "Gender": gender,
          "Contact No.": contactno,
          "Profile Pic": url
        }).then((value) {
          print("Data uploaded");
        });
      } catch (ex) {
        print(ex.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: pickedimage != null
                          ? CircleAvatar(
                              radius: 80,
                              backgroundImage: FileImage(pickedimage!),
                            ).px32()
                          : CircleAvatar(
                              radius: 80,
                              child: Icon(
                                CupertinoIcons.person_solid,
                                size: 80,
                              ),
                            ))
                  .px32(),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      hintText: "Enter your Name", labelText: "Name"),
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name";
                    }
                    return null;
                  }).px32(),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  controller: genderController,
                  decoration: const InputDecoration(
                      hintText: "Male/Female", labelText: "Gender"),
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Gender";
                    }
                    return null;
                  }).px32(),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  controller: contactnoController,
                  decoration: const InputDecoration(
                      hintText: "Enter your contact details",
                      labelText: "Contact Number"),
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Contact Number";
                    }
                    return null;
                  }).px32(),
              SizedBox(
                height: 49,
              ),
              ElevatedButton(
                onPressed: () {
                  savedetails(nameController.text, genderController.text,
                      contactnoController.text);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: context.theme.shadowColor),
                child: "Save Details".text.color(Colors.white).make(),
              ).px32(),
              SizedBox(height: 20), // Add space at the bottom
            ],
          ),
        ),
      ),
    );
  }

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
