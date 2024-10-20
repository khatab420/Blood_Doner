import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DonorSetupScreen extends StatefulWidget {
  final String email;

  const DonorSetupScreen({super.key, required this.email});

  @override
  _DonorSetupScreenState createState() => _DonorSetupScreenState();
}

class _DonorSetupScreenState extends State<DonorSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _bloodType = 'A+';
  bool _isAvailable = false;
  DateTime? _lastDonationDate;
  double? _latitude, _longitude;

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  Future<void> _submitDonorData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('https://solar-tech-energy.com/Blood_Doner/add_donor.php'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': widget.email,
            'blood_type': _bloodType,
            'last_donation_date': _lastDonationDate?.toIso8601String(),
            'is_available': _isAvailable ? 1 : 0,
            'latitude': _latitude,
            'longitude': _longitude,
          }),
        );

        print('Response: ${response.body}');  // Log the response

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Donor data saved successfully!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${data['message']}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Server error! Please try again later.')),
          );
        }
      } catch (e) {
        print('Exception: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error!')),
        );
      catch (e) {
        print('Exception: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error!')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donor Setup')),
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
              SwitchListTile(
                title: const Text('Available for Donation'),
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _getLocation,
                child: const Text('Get Location'),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _lastDonationDate = pickedDate;
                    });
                  }
                },
                child: const Text('Select Last Donation Date'),
              ),
              ElevatedButton(
                onPressed: _submitDonorData,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
