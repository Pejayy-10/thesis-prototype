import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Result')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
          child: const Text('Back to Home'),
        ),
      ),
    );
  }
}
