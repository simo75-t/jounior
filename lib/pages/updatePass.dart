import 'package:flutter/material.dart';
import 'package:jounior/pages/homepage.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 37, 116, 78),
      ),
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
                controller: _oldPassword,
                decoration: const InputDecoration(
                  labelText: 'Please Enter the Old Password',
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
                controller: _newPassword,
                decoration: const InputDecoration(
                  labelText: 'Please Enter a new Password',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 37, 116, 78)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 16),
            // حقل إدخال اسم المستخدم
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color: const Color.fromARGB(255, 37, 116, 78), width: 2),
              ),
              child: TextFormField(
                controller: _confirmPassword,
                decoration: const InputDecoration(
                  labelText: 'Please Enter the new password Again',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 37, 116, 78)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 37, 70, 116),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 50.0),
              ),
              child: const Text('Update',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
