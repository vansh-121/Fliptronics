import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_catalogue/core/store.dart';
import 'package:flutter_catalogue/pages/cart_page.dart';
import 'package:flutter_catalogue/pages/forget_password.dart';
import 'package:flutter_catalogue/pages/login_page.dart';
import 'package:flutter_catalogue/pages/otp_page.dart';
import 'package:flutter_catalogue/pages/phone_verification.dart';
import 'package:flutter_catalogue/pages/profile_page.dart';
import 'package:flutter_catalogue/pages/signup_page.dart';
import 'package:flutter_catalogue/pages/users_page.dart';
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
  if (kIsWeb) {
    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) =>
            VxState(store: MyStore(), child: MyApp()), // Wrap your app
      ),
    );
  } else {
    runApp(
      VxState(store: MyStore(), child: MyApp()),
    );
  }
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
        "/": (context) => LoginPage(),
        Routes.HomeRoute: (context) => HomePage(),
        Routes.loginRoute: (context) => LoginPage(),
        Routes.CartRoute: (context) => CartPage(),
        Routes.ForgotRoute: (context) => ForgetPage(),
        Routes.PhoneRoute: (context) => PhonePage(),
        Routes.OTPRoute: (context) => OtpPage(
              verificationid: 'verificationid',
            ),
        Routes.UsersRoute: (context) => UsersPage(),
        Routes.ProfileRoute: (context) => ProfilePage(),
        Routes.SignUpRoute: (context) => SignUpPage(),
      },
    );
  }
}
