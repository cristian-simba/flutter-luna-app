import 'package:flutter/material.dart';

class Calendary extends StatefulWidget {
  const Calendary({super.key});

  @override
  _CalendaryState createState() => _CalendaryState();
}

class _CalendaryState extends State<Calendary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario'),
      ),
      body: Center(
        child: Text('This is Calendario page'),
      ),
    );
  }
}
