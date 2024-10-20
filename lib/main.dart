import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'Screens/role_selection_screen.dart';
import 'Screens/donor_setup_screen.dart';
import 'Screens/receiver_setup_screen.dart';

void main() => runApp(const BloodDonorApp());

class BloodDonorApp extends StatelessWidget {
  const BloodDonorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Donor App',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/roleSelection': (context) => RoleSelectionScreen(
          email: ModalRoute.of(context)!.settings.arguments as String,
        ),
        '/donorSetup': (context) => DonorSetupScreen(
          email: ModalRoute.of(context)!.settings.arguments as String,
        ),
        '/receiverSetup': (context) => ReceiverSetupScreen(
          email: ModalRoute.of(context)!.settings.arguments as String,
        ),
      },
    );
  }
}
