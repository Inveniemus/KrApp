import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:kerbal_remote_application/krpc/client.dart';
import 'package:krpc_dart/krpc_dart.dart';
import 'package:meta/meta.dart';

import '../../domain/vessel/vessel_data.dart';

part 'vessel_event.dart';
part 'vessel_state.dart';

/// This class uses the KrpcClient to get [VesselData] from the active vessel,
/// if any.
class VesselBloc extends Bloc<VesselEvent, VesselState> {

  KrpcClient _client;
  VesselBloc() : super(NoVesselDataState()) {
    _client = ProviderContainer().read(clientProvider);
  }

  @override
  Stream<VesselState> mapEventToState(VesselEvent event) async* {
    print(event.toString());
    if (event is RequestVesselDataEvent) {
      if (_client.status == KrpcClientStatus.connected) {
        // Get data
      } else {
        yield NoVesselDataState();
      }
    }
  }
}
