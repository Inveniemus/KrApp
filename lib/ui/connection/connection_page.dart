import 'package:flutter/material.dart';

import 'connection_widget.dart';

class ConnectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connection to KSP'),
      ),
      body: ConnectionWidget(),
    );
  }
}
