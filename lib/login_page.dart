// ignore_for_file: deprecated_member_use, avoid_print

import '../providers/credentials_provider.dart';
import 'package:insiit/screens/home_page.dart';
import 'package:gsheets/gsheets.dart';
import '../screens/incorrect_email.dart';
import 'package:provider/provider.dart';
import 'providers/google_login_controller.dart';
import 'package:flutter/material.dart';

const _credentials = CredentialsProvider.credentials;

const _spreadsheetId = CredentialsProvider.sheetId;
const _studentDetailsSheetID = CredentialsProvider.studentSheet;

late List<List<String>> updateList = [];

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String chosenHostel = 'A';
  bool _isPressed = false;
  final List hostels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: loginUI(),
      ),
    );
  }

  loginUI() {
    return Consumer<GoogleSignInController>(
      builder: (context, model, child) {
        if (model.googleAccount != null) {
          return Center(child: loggedInUI(model));
        } else {
          return loginControls(context);
        }
      },
    );
  }

  loggedInUI(GoogleSignInController model) {
    return model.googleAccount!.email.contains('iitgn.ac.in')
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (model.googleAccount!.photoUrl != null)
                  ? CircleAvatar(
                      backgroundImage:
                          Image.network(model.googleAccount!.photoUrl ?? '')
                              .image,
                      radius: 50,
                    )
                  : ClipRRect(
                      child: Image.asset(
                        "assets/images/iitgn.png",
                        height: 75,
                        width: 75,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
              const SizedBox(
                height: 10,
              ),
              Text(
                model.googleAccount!.displayName ?? '',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                model.googleAccount!.email,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              ActionChip(
                avatar: const Icon(Icons.logout),
                label: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Provider.of<GoogleSignInController>(context, listen: false)
                      .logOut();
                },
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Choose Hostel",
                      style: TextStyle(fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: DropdownButton(
                        hint: const Text("Select Hostel"),
                        dropdownColor: Colors.grey[300],
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 36,
                        isExpanded: true,
                        style: const TextStyle(color: Colors.black),
                        value: chosenHostel,
                        onChanged: (hostel) {
                          setState(() {
                            chosenHostel = hostel.toString();
                          });
                        },
                        items: hostels.map((value) {
                          return DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(value),
                            ),
                            value: value,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              _isPressed
                  ? const CircularProgressIndicator()
                  : FlatButton(
                      onPressed: () {
                        setState(() {
                          _isPressed = true;
                        });

                        void addData() async {
                          final gsheet_1 = GSheets(_credentials);
                          // fetch spreadsheet by its id
                          final ss = await gsheet_1
                              .spreadsheet(_studentDetailsSheetID);
                          // get worksheet by its title
                          var sheet = ss.worksheetByTitle('Sheet1');
                          sheet ??= await ss.addWorksheet('Sheet1');

                          List totalData = (await sheet.values.allRows());

                          for (int i = 0; i < totalData.length; i++) {
                            if (totalData[i][0] ==
                                    model.googleAccount!.displayName &&
                                totalData[i][1] == model.googleAccount!.email) {
                              // print(totalData[i][2]);
                              // print(chosenHostel);
                              final cell =
                                  await sheet.cells.cell(column: 3, row: i + 1);
                              cell.post(chosenHostel);
                              break;
                              // totalData[i][2] = chosenHostel;
                            } else if (i == (totalData.length - 1)) {
                              await sheet.values.appendRow([
                                model.googleAccount!.displayName,
                                model.googleAccount!.email,
                                chosenHostel
                              ]);
                            }
                          }
                        }

                        addData();
                        // print(model.googleAccount!.displayName);
                        // print(model.googleAccount!.email);
                        // print(chosenHostel);
                        // print(model.googleAccount!.id);

                        Future(() async {
                          final gsheets = GSheets(_credentials);
                          // fetch spreadsheet by its id
                          final ss = await gsheets.spreadsheet(_spreadsheetId);
                          // get worksheet by its title
                          var sheet = ss.worksheetByTitle('Sheet1');
                          sheet ??= await ss.addWorksheet('Sheet1');
                          updateList = (await sheet.values.allRows());
                          return updateList;
                        }).then((res) => Navigator.of(context)
                                .pushReplacementNamed(HomePage.routeName,
                                    arguments: [
                                  res,
                                  model.googleAccount!.displayName,
                                  chosenHostel
                                ]));
                      },
                      color: Colors.grey[300],
                      child: const Text("Continue"),
                    ),
            ],
          )
        : const IncorrectEmail();
  }

  loginControls(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Image.asset("assets/images/iitgn.png"),
            width: 250,
            height: 250,
          ),
          const SizedBox(
            height: 20.0,
          ),
          const SizedBox(
            height: 70,
            child: Text(
              "IIT GN",
              style: TextStyle(fontSize: 65, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          GestureDetector(
            child: FlatButton(
              onPressed: () {
                Provider.of<GoogleSignInController>(context, listen: false)
                    .login();
              },
              color: Colors.grey[300],
              child: const Text(
                "Login with IITGN ID (Google)",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
