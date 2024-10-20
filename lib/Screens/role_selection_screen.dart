import 'package:flutter/material.dart';
import 'donor_setup_screen.dart';  // Import donor screen
import 'receiver_setup_screen.dart';  // Import receiver screen

class RoleSelectionScreen extends StatelessWidget {
  final String email; // Get email from registration flow

  const RoleSelectionScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonorSetupScreen(
                      email: email,
                    ),
                  ),
                );

              },
              child: const Text('I am a Donor'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiverSetupScreen(
                      email: email,
                    ),
                  ),
                );

              },
              child: const Text('I am a Receiver'),
            ),
          ],
        ),
      ),
    );
  }
}
