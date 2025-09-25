import 'package:flutter/material.dart';
import 'package:tharkyApp/Screens/Chat/recent_chats.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'Matches.dart';

class HomeScreen extends StatelessWidget {
  final User currentUser;
  HomeScreen(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Matches(currentUser),
              RecentChats(currentUser),
            ],
          ),
        ),
      ),
    );
  }
}
