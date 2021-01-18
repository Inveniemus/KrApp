import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/connection/connection_bloc.dart';
import 'ui/home.dart';
import 'ui/connection/connection_page.dart';
import 'ui/vessel/vessel_page.dart';

class KrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/connection': (context) => ConnectionPage(),
        '/vessel': (context) => VesselPage(),
      },
    );
  }
}
