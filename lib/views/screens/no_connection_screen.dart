import 'package:flutter/material.dart';

class NoconnectionScreen extends StatefulWidget {
  const NoconnectionScreen({Key? key}) : super(key: key);

  @override
  State<NoconnectionScreen> createState() => _NoconnectionScreenState();
}

class _NoconnectionScreenState extends State<NoconnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.error_outline_sharp,
              size: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'No internet connection',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
