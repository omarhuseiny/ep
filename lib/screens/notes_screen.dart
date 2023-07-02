import 'package:flutter/material.dart';

// import 'tile_widget.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final List<Map<String, dynamic>> _myItems = [];

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
                    title: Text(_myItems[index]['name']),
                    subtitle: Text(_myItems[index]['content']),
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
                      setState(() {
                        _myItems.add({
                          'name': _nameController.text,
                          'content': _contentController.text,
                        });
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
}
