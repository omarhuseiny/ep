import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'tile_widget.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late List<dynamic> _myItems = [];

  @override
  void initState() {
    super.initState();
    getAllNotes().then((s)
    {
      setState(() {
        _myItems = s as List<dynamic>;
      });
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: _myItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: ListTile(
                    title: Text(_myItems[index].title),
                    subtitle: Text(_myItems[index].content),
                    leading: Image.asset("assets/images/note1.png"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add Note'),
                // TODO: to avoid overflow
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: _contentController,
                        decoration: const InputDecoration(
                          labelText: 'Content',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      NoteModel note = NoteModel(title: _nameController.text, content: _contentController.text);
                      postNote(note);
                      setState(() {
                        _myItems.add(note);
                        _nameController.clear();
                        _contentController.clear();
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Future<List<NoteModel>?> getAllNotes() async {
    Uri url = Uri.parse('http://kirollos.rocks:6969/notes/list/');
    final headers = {
      'Authorization': 'Bearer 69420',
      'Content-Type': 'application/json', // optional header for specifying the request payload format
    };
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['data']);
      return data['data'].map<NoteModel>((json) => NoteModel.fromJson(json)).toList();
      //return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> postNote(NoteModel note) async {
    final url = Uri.parse('http://kirollos.rocks:6969/notes/add/');

    final headers = {
      'Authorization': 'Bearer 69420',
      'Content-Type': 'application/json', // optional header for specifying the request payload format
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({"title": note.title, "content": note.content})
    );

    print(response.body);

    return response;
  }
}

class NoteModel {
  final String title;
  final String content;

  NoteModel({
    required this.title,
    required this.content,
  });
  factory NoteModel.fromJson(dynamic json) {
    return NoteModel(
      title: json['title'],
      content: json['content'],
    );
  }
  @override
  String toString() {
    return "Title : $title, Content : $content";
  }
}