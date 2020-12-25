import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/application/connection_bloc.dart';
import 'package:kerbal_remote_application/ui/connection/connection_page.dart';

class KrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
          create: (BuildContext context) => KrpcConnectionBloc(),
          child: ConnectionPage()),
    );
  }
}
