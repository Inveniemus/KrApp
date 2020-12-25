import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:meta/meta.dart';

import '../krpc/client.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class KrpcConnectionBloc extends Bloc<KrpcConnectionEvent, KrpcConnectionState> {

  ProviderContainer container;

  KrpcConnectionBloc() : super(KrpcDisconnectedState()) {
    container = ProviderContainer();
  }

  @override
  Stream<KrpcConnectionState> mapEventToState(
    KrpcConnectionEvent event,
  ) async* {
    if (event is RPCConnectionRequest) {

      final client = container.read(clientProvider);
      client.ip = event.ip;
      client.rpcPort = event.rpcPort;
      client.clientName = event.clientName;

      try {
        await client.connectRPC();
        yield KrpcConnectedState();
      } on Exception catch (e, s) {
        yield KrpcConnectionErrorState(e.toString(), s.toString());
      }

    } else if (event is DisconnectKrpcEvent) {
      final client = container.read(clientProvider);
      await client.disconnect();
      yield KrpcDisconnectedState();
    }
  }
}
