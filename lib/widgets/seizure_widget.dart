import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MyList extends StatefulWidget {
  const MyList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  final List<Map<String, dynamic>> _myItems = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();

  int last_sID = -1;

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
                    tileColor: const Color(0xFFF8E8EE),
                    title: Text("Seizure Name: ${_myItems[index]['name']}"),
                    subtitle: Text(
                      "Seizure Peroid: ${_myItems[index]['period']} minutes",
                    ),
                    trailing: Text(_myItems[index]['time']),
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
          getRequest().then((response)
          {
            var body = json.decode(response.body);
            print(body);
            if(response.statusCode == 200 && body['err'] == null && body['status'] == "OK")
            {
              var count = body['count'];
              print(count);
              if(count > 0) {
                var data = body['data'];
                var last_seizure = data[count-1];
                print(last_seizure);

                last_sID = last_seizure['id'];

                _nameController.text = last_seizure['seizure_name'];
                _timeController.text = last_seizure['time'];
                _periodController.text = last_seizure['duration'].toString();
              }

            }
            else
            {
              var error = body['err'];
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Response Status'),
                    content: Text('Error($response.statusCode): $error'),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            }
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add a new item'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Seizure name',
                        ),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _periodController,
                        decoration: const InputDecoration(
                          labelText: 'Period of seizure in minutes',
                        ),
                      ),
                      FormBuilder(
                        child: Column(
                          children: [
                            FormBuilderDateTimePicker(
                              controller: _timeController,
                              name: 'time_field',
                              inputType: InputType.time,
                              format: DateFormat('hh:mm a'),
                              decoration: const InputDecoration(
                                labelText: 'Time',
                                // border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(top: 64),
                                content: Text('Please Wait To Get Location'),
                              ),
                            );
                            // get the current location
                            LocationPermission permission =
                                await Geolocator.requestPermission();
                            if (permission == LocationPermission.whileInUse ||
                                permission == LocationPermission.always) {
                              Position position =
                                  await Geolocator.getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high);
                              // use the position object
                              // print the latitude and longitude
                              double lat = position.latitude;
                              double long = position.longitude;
                              print('Latitude: ${position.latitude}');
                              print('Longitude: ${position.longitude}');
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(top: 64),
                                  content: Text(
                                      'Your Location Has Been Added Properly'),
                                ),
                              );
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirmation'),
                                    content: const Text(
                                        'Do You Need To Check Is It The Corrcet Loction ?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              ).then((value) async {
                                if (value != null && value) {
                                  String url =
                                      'https://www.google.com/maps/search/?api=1&query=$lat,$long';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                } else {
                                  // user tapped on "No" or dismissed the dialog
                                }
                              });
                            }
                          },
                          child: const Text('Add Location'),
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
                          'period': _periodController.text,
                          'time': _timeController.text
                        });
                        _nameController.clear();
                        _periodController.clear();
                        _timeController.clear();
                      });
                      if(last_sID != -1) {
                        postAck(last_sID).then((response)
                        {
                          if(response.statusCode == 200)
                          {
                            last_sID = -1;
                          }
                          else
                          {
                            var message = 'Error: $response.body["err"]';
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Response Status'),
                                  content: Text(message),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        });
                      }
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

  Future<http.Response> getRequest() async {
    final url = Uri.parse('http://kirollos.rocks:6969/seizures/list/unacked/');

    final headers = {
      'Authorization': 'Bearer 69420',
      'Content-Type': 'application/json', // optional header for specifying the request payload format
    };

    final response = await http.get(
      url,
      headers: headers
    );

    print(response.body);

    return response;
  }

  Future<http.Response> postAck(int sID) async {
    final url = Uri.parse('http://kirollos.rocks:6969/seizures/ack/');

    final headers = {
      'Authorization': 'Bearer 69420',
      'Content-Type': 'application/json', // optional header for specifying the request payload format
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({"sID": sID})
    );

    print("ACK body");
    print(json.encode({"sID": sID}));

    print(response.body);

    return response;
  }
}
