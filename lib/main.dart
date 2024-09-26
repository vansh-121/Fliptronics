import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_catalogue/core/store.dart';
import 'package:flutter_catalogue/pages/cart_page.dart';
import 'package:flutter_catalogue/pages/login_page.dart';
import 'package:flutter_catalogue/themes.dart';
import 'package:flutter_catalogue/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'pages/home_page.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyD_sqvHUcufqoTdkZzjwprC8u9Lk0iABRY",
      authDomain: "windows-38d91.firebaseapp.com",
      projectId: "windows-38d91",
      storageBucket: "windows-38d91.appspot.com",
      messagingSenderId: "590193531184",
      appId: "1:590193531184:web:68e3331009e195fe43d0f5",
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>
          VxState(store: MyStore(), child: MyApp()), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const HomePage(),
      themeMode: ThemeMode.system,
      theme: MyTheme.LightTheme(context),
      darkTheme: MyTheme.DarkTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.loginRoute,
      routes: {
        "/": (context) => const LoginPage(),
        Routes.HomeRoute: (context) => const HomePage(),
        Routes.loginRoute: (context) => const LoginPage(),
        Routes.CartRoute: (context) => const CartPage(),
      },
    );
  }
}
