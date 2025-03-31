import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            profileDetail('Name', 'Nishanth'),
            profileDetail('Email', 'Nishu2005@gmail.com'),
            profileDetail('Phone', '9788230172'),
            profileDetail('Address', 'Harveypati, Madurai'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text('$title: $value', style: const TextStyle(fontSize: 18)),
    );
  }
}
