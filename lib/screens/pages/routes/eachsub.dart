import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: EnvironmentalEducationApp()));

class EnvironmentalEducationApp extends StatefulWidget {
  @override
  _EnvironmentalEducationAppState createState() =>
      _EnvironmentalEducationAppState();
}

class _EnvironmentalEducationAppState extends State<EnvironmentalEducationApp> {
  final String apiUrl =
      "https://www.eschool2go.org/api/v1/project/ba7ea038-2e2d-4472-a7c2-5e4dad7744e3?path=Environmental%20Education";

  List<Map<String, dynamic>> units = [];

  Future<void> fetchUnits() async {
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var extractedUnits = List<Map<String, dynamic>>.from(data);

        // Sort the units list based on the first part of the title in ascending order
        extractedUnits.sort((a, b) => (a['title'] != null && b['title'] != null)
            ? a['title']
                .toString()
                .split(' ')[0]
                .compareTo(b['title'].toString().split(' ')[0])
            : 0);

        setState(() {
          units = extractedUnits;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  Widget buildUnitItem(Map<String, dynamic> unit) {
    String pdfUrl =
        unit['download_url'] ?? ''; // Use 'download_url' instead of 'id'
    String title = unit['title'] ?? '';

    return Column(
      children: [
        ListTile(
          title: Text(title),
          subtitle: Text("${unit['category_path'] ?? ''}"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle download PDF button click
                // You can implement the logic for downloading the PDF here
                // For example, you can use a package like 'flutter_downloader'
                // to download the PDF file.
              },
              child: const Text("Download PDF"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle read online button click
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFScreen(pdfUrl: pdfUrl),
                  ),
                );
              },
              child: const Text("Read Online"),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUnits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Environmental Education"),
        backgroundColor: Colors.green,
      ),
      body: units.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: units.length,
              itemBuilder: (context, index) {
                return buildUnitItem(units[index]);
              },
            ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  final String pdfUrl;

  PDFScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
      ),
      body: PDFView(
        filePath: pdfUrl,
      ),
    );
  }
}
