import 'package:flutter/material.dart';

class SuspendedMobile extends StatefulWidget {
  @override
  _SuspendedMobileState createState() => _SuspendedMobileState();
}

class _SuspendedMobileState extends State<SuspendedMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Admin'),
      ),
    );
  }
}
