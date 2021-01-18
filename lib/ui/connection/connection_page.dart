import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/application/connection/connection_bloc.dart';

import 'connection_widget.dart';

class ConnectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connection to KSP'),
      ),
      body: BlocProvider(create: (context) => KrpcConnectionBloc(), child: ConnectionWidget()),
    );
  }
}
