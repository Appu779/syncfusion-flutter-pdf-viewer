import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weeklynuget/screens/pages/routes/eachsub.dart';

void main() => runApp(MaterialApp(home: SubjectList()));

class SubjectList extends StatefulWidget {
  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  List<Subject> subjects = [];
  List<Color> avatarColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.brown,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.cyan,
    Colors.pink,
    Colors.lime,
    Colors.indigo,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.eschool2go.org/api/v1/project/ba7ea038-2e2d-4472-a7c2-5e4dad7744e3'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          subjects = data.entries.map((entry) {
            var subjectData = entry.value;
            var name = subjectData['name'] ?? 'Unknown';
            var path = subjectData['path'] ?? '/unknown';
            return Subject(name, path);
          }).toList();
        });
      } else {
        // If the server returns a non-200 status code
        throw Exception('Failed to load subjects: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or exceptions
      print('Error: $error');
      // You can show an error message to the user if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Class 12 \nBooks',
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 93, 105, 191),
        toolbarHeight: 80,
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
        ),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          Color avatarColor = avatarColors[index % avatarColors.length];
          return GestureDetector(
            onTap: () {
              // Navigate to EnvironmentalEducationApp when the card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EnvironmentalEducationApp()),
              );
            },
            child: Card(
              color: const Color(0xfffdfbfe),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: avatarColor,
                      child: Text(
                        subjects[index].name[0], // First letter of the subject
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Text(
                      subjects[index].name,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Subject {
  final String name;
  final String path;

  Subject(this.name, this.path);
}
