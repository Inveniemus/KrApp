import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/application/vessel/vessel_bloc.dart';
import 'package:kerbal_remote_application/ui/vessel/vessel_page_body.dart';

class VesselPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('ACTIVE VESSEL'),)
      ),
      body: BlocProvider(
        create: (context) => VesselBloc(),
        child: VesselPageBody(),
      ),
    );
  }
}
