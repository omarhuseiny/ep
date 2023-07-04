import 'package:flutter/material.dart';

import '../widgets/profile_widget.dart';

import 'package:new_flutter_project/main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF2BED1),
        title: const Text("My Profile"),
        toolbarHeight: 70,
      ),
      body: ProfileWidget(
          //name: 'Omer Tarek',
          name: MyApp.username,
          //email: "omertarek@gmail.com",
          email: MyApp.email,
          age: 30,
          imageUrl: "assets/images/man.png",
          info:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, arcu ac posuere bibendum, quam nulla sagittis nulla, vitae laoreet tellus libero et eros. Morbi feugiat arcu sed purus faucibus, vitae tincidunt nisl luctus.'),
    );
  }
}
