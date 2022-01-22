// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:gsheets/gsheets.dart';
import 'package:insiit/providers/credentials_provider.dart';
// import 'package:insiit/login_page.dart';
import 'package:insiit/providers/google_login_controller.dart';
import 'package:insiit/screens/notification_screen.dart';
import 'package:provider/provider.dart';
// import 'package:insiit/login_page.dart';

const _credentials = CredentialsProvider.credentials;

const _spreadsheetId = CredentialsProvider.homePageSheet;

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isLoaded = false;
  late bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as List;
    final list = routeArgs[0];
    final name = routeArgs[1];
    final hostel = routeArgs[2];

    final signInFunctions = Provider.of<GoogleSignInController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hello $name !",
          style: const TextStyle(fontSize: 23),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isPressed = true;
              });
              Future(() async {
                final gsheets = GSheets(_credentials);
                // fetch spreadsheet by its id
                final ss = await gsheets.spreadsheet(_spreadsheetId);
                // get worksheet by its title
                var sheet = ss.worksheetByTitle('Sheet1');
                sheet ??= await ss.addWorksheet('Sheet1');

                List updateList = (await sheet.values.allRows());

                updateList.remove(updateList[0]);

                // print(updateList[0][2].runtimeType);

                return updateList;
              }).then((res) {
                setState(() {
                  _isLoaded = true;
                });
                Navigator.of(context).pushNamed(NotificationScreen.routeName,
                    arguments: [res, hostel]);
              });
            },
            icon: (_isPressed && !_isLoaded)
                ? const CircularProgressIndicator(
                    color: Colors.black54,
                  )
                : const Icon(Icons.notifications),
          ),
          IconButton(
              onPressed: () {
                // Provider.of<GoogleSignInController>(context, listen: false)
                //     .logOut();
                signInFunctions.logOut();
                Navigator.of(context).pushReplacementNamed('/');
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return Center(
              // child: Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text("${routeArgs[index][0]} -- ${routeArgs[index][1]}"),
              // ),
              child: Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Table(
                      // border: TableBorder.all(
                      //     color: Theme.of(context).primaryColor,
                      //     style: BorderStyle.solid,
                      //     width: 2),
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              // routeArgs[index][0],
                              list[index][0],
                              style: const TextStyle(fontSize: 18),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              // routeArgs[index][1],
                              list[index][1],
                              style: const TextStyle(fontSize: 18),
                            )),
                          )
                        ]),
                      ],
                    ),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: list.length,
        ),
      ),
    );
  }
}
