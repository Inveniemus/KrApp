import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KrApp'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          IconButton(
            icon: Icon(Icons.connected_tv),
            onPressed: () => Navigator.of(context).pushNamed('/connection'),
          ),
          IconButton(
            icon: Icon(Icons.airplanemode_active),
            onPressed: () => Navigator.of(context).pushNamed('/vessel'),
          )
        ],
      ),
    );
  }
}
