import 'package:flutter/services.dart';
import 'package:insiit/screens/home_page.dart';
import 'package:insiit/screens/notification_screen.dart';
import 'providers/google_login_controller.dart';
import '../login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: GoogleSignInController()),
        // ChangeNotifierProvider(
        //   create: (context) => GoogleSignInController(),
        //   // child: const LoginPage(),
        // ),
      ],
      child: MaterialApp(
        title: 'insIIT',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        routes: {
          '/': (ctx) => const LoginPage(),
          // '/': (ctx) => const LocalNotificationsPlugin(),
          HomePage.routeName: (ctx) => const HomePage(),
          NotificationScreen.routeName: (ctx) => const NotificationScreen(),
        },
      ),
    );
  }
}
