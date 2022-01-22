// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/notifications';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as List;
    final list = routeArgs[0];
    final hostel = routeArgs[1];

    // print(hostel);
    // print(list);
    final newList = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i][1] == hostel || list[i][1] == "All") {
        newList.add(list[i]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        elevation: 0,
      ),
      body: newList.isEmpty
          ? const Center(
              child: Text(
                "No Notifications Yet!",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Center(
                      child: Row(
                        children: [
                          Column(
                            children: const [
                              Icon(Icons.more_vert_outlined),
                              Icon(Icons.star),
                              Icon(Icons.more_vert_outlined),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "${newList[newList.length - index - 1][0]}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: newList.length,
                ),
              ),
            ),
    );
  }
}
