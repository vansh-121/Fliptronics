import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalogue/themes.dart';
import 'package:velocity_x/velocity_x.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.theme.canvasColor,
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          padding: EdgeInsets.zero,
          child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: MyTheme.DarkColor,
              ),
              margin: EdgeInsets.zero,
              accountName: const Text(
                "Vansh Sethi",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              accountEmail: const Text(
                "vansh.sethi98760@gmail.com",
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/1684992616735.jpeg"),
              )),
        ),
        const ListTile(
          leading: Icon(
            CupertinoIcons.home,
          ),
          title: Text(
            "Home",
            style: TextStyle(fontWeight: FontWeight.bold),
            textScaler: TextScaler.linear(1.1),
          ),
        ),
        const ListTile(
          leading: Icon(
            CupertinoIcons.profile_circled,
          ),
          title: Text(
            "Profile",
            style: TextStyle(fontWeight: FontWeight.bold),
            textScaler: TextScaler.linear(1.1),
          ),
        ),
        const ListTile(
          leading: Icon(
            CupertinoIcons.mail,
          ),
          title: Text(
            "Contact Us",
            style: TextStyle(fontWeight: FontWeight.bold),
            textScaler: TextScaler.linear(1.1),
          ),
        )
      ]),
    );
  }
}
