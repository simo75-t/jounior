import 'package:flutter/material.dart';
import 'package:jounior/pages/login.dart';
import 'package:jounior/pages/updatePass.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('profile settings')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color: const Color.fromARGB(255, 37, 116, 78), width: 2),
              ),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  enabled: false,
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 37, 116, 78)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color: const Color.fromARGB(255, 37, 116, 78), width: 2),
              ),
              child: TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  enabled: false,
                  labelText: 'Username',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 37, 116, 78)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 16),
            // logout button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdatePassword()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 0, 135, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 50.0),
              ),
              child: const Text('Update Password',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),

            const SizedBox(height: 16),
            // delete_account button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 216, 16, 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 50.0),
              ),
              child: const Text('delete account',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            // logout button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 216, 16, 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 50.0),
              ),
              child: const Text('Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
