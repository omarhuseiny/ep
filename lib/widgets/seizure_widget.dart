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
  late List<dynamic> _myItems = [];
  @override
  void initState() {
    super.initState();
    getAllSeizures().then((s)
    {
      setState(() {
        _myItems = s as List<dynamic>;
      });
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();

  int lastsID = -1;

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
                    title: Text("Seizure Name: ${_myItems[index].seizureName}"),
                    subtitle: Text(
                      "Seizure Peroid: ${_myItems[index].duration} minutes",
                    ),
                    trailing: Text(_myItems[index].time),
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

                lastsID = last_seizure['id'];

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
                        readOnly: true,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Seizure name',
                        ),
                      ),
                      TextField(
                        readOnly: true,
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
                        _myItems.add(Seizure(
                          seizureName: _nameController.text,
                          time: _timeController.text,
                          duration: _periodController.text));
                        _nameController.clear();
                        _periodController.clear();
                        _timeController.clear();
                      });
                      if(lastsID != -1) {
                        postAck(lastsID).then((response)
                        {
                          if(response.statusCode == 200)
                          {
                            lastsID = -1;
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

  Future<List<Seizure>?> getAllSeizures() async {
    Uri url = Uri.parse('http://kirollos.rocks:6969/seizures/list/acked/');
    final headers = {
      'Authorization': 'Bearer 69420',
      'Content-Type': 'application/json', // optional header for specifying the request payload format
    };
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['data']);
      return data['data'].map<Seizure>((json) => Seizure.fromJson(json)).toList();
      //return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class Seizure {
  final String seizureName;
  final String time;
  final String duration;

  Seizure({
    required this.seizureName,
    required this.time,
    required this.duration,
  });

  factory Seizure.fromJson(Map<String, dynamic> json) {
    return Seizure(
      seizureName: json['seizure_name'],
      time: json['time'],
      duration: json['duration'],
    );
  }
  //@override
  //String toString() {
  //  return "Name : $seizureName, time : $time, duration : $duration";
  //}
}
