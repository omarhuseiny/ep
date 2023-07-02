import 'package:flutter/material.dart';

import '../widgets/home_widget.dart';
import '../widgets/seizure_widget.dart';
import 'notes_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xffF2BED1),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person),
          ),
          const SizedBox(
            width: 10,
          )
        ],
        title: const Text('Medical Care'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Home',
              icon: Icon(Icons.home),
            ),
            Tab(
              text: 'Add Note',
              icon: Icon(Icons.note),
            ),
            Tab(
              text: 'Seizures',
              icon: Icon(Icons.list),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: HomeWidget()),
          Center(child: NoteScreen()),
          Center(child: MyList()),
        ],
      ),
    );
  }
}
