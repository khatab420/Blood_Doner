import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReceiverSetupScreen extends StatefulWidget {
  final String email;

  const ReceiverSetupScreen({super.key, required this.email});

  @override
  _ReceiverSetupScreenState createState() => _ReceiverSetupScreenState();
}

class _ReceiverSetupScreenState extends State<ReceiverSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _bloodType = 'A+';
  String _urgencyLevel = 'low';
  double? _latitude, _longitude;

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  Future<void> _submitReceiverData() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://solar-tech-energy.com/Blood_Doner/add_receiver.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'blood_type': _bloodType,
          'urgency_level': _urgencyLevel,
          'latitude': _latitude,
          'longitude': _longitude,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receiver data saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save receiver data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receiver Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _bloodType,
                onChanged: (value) {
                  setState(() {
                    _bloodType = value!;
                  });
                },
                items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Blood Type'),
              ),
              DropdownButtonFormField<String>(
                value: _urgencyLevel,
                onChanged: (value) {
                  setState(() {
                    _urgencyLevel = value!;
                  });
                },
                items: ['low', 'medium', 'high']
                    .map((level) => DropdownMenuItem(
                  value: level,
                  child: Text(level),
                ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Urgency Level'),
              ),
              ElevatedButton(
                onPressed: _getLocation,
                child: const Text('Get Location'),
              ),
              ElevatedButton(
                onPressed: _submitReceiverData,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
