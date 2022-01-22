// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../providers/google_login_controller.dart';
import 'package:provider/provider.dart';

class IncorrectEmail extends StatelessWidget {
  const IncorrectEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginData = Provider.of<GoogleSignInController>(context);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Hello !",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text("Please login through your IIT GN Email ID"),
          FlatButton(
            onPressed: loginData.logOut,
            color: Colors.grey[300],
            child: const Text(
              "Logout",
              style: TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
