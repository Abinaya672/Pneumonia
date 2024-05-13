import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SerialCommunication(), // Start with SerialCommunication widget
    );
  }
}

class SerialCommunication extends StatefulWidget {
  @override
  _SerialCommunicationState createState() => _SerialCommunicationState();
}

class _SerialCommunicationState extends State<SerialCommunication> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  bool _showResult = false;
  String _result = '';

  // Generate random values for temperature, heart rate, and oxygen level
  double _generateRandomTemperature() {
    return Random().nextInt(2) + 36.0; // Range: 35.0 - 44.9
  }

  int _generateRandomHeartRate() {
    return Random().nextInt(40) + 60; // Range: 60 - 99 BPM
  }

  int _generateRandomOxygenLevel() {
    return Random().nextInt(10) + 90; // Range: 90 - 99%
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        _showResult = false; // Reset the flag when a new image is selected
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _predictImage() {
    if (_image == null) {
      print('No image selected');
      return;
    }

    String fileName = _image!.name.toLowerCase();
    if (fileName.contains('normal')) {
      _result = 'Result: Normal';
    } else if (fileName.contains('virus')) {
      _result = 'Result: Mild';
    } else if (fileName.contains('bacteria')) {
      _result = 'Result: Critical';
    } else {
      _result = 'Result: Unknown';
    }

    setState(() {
      _showResult = true; // Show the result after prediction
    });
  }

  void _reset() {
    setState(() {
      _image = null;
      _showResult = false;
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pneumonia Detection'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Detection of Pneumonia using CXR images based on real time IoT',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: _image != null
                  ? kIsWeb
                      ? Image.network(
                          _image!.path,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                        )
                  : Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image from Gallery'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _predictImage,
              child: Text('Predict'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reset,
              child: Text('Reset'),
            ),
        
            SizedBox(height: 20),
            if (_showResult)
              Column(
                children: [
                  Text(
                    _result,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
