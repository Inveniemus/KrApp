import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:kerbal_remote_application/domain/connection/connection_parameters.dart';
import 'package:krpc_dart/krpc_dart.dart';
import 'package:meta/meta.dart';

import '../krpc/client.dart';

part 'connection_event.dart';

part 'connection_state.dart';

class KrpcConnectionBloc
    extends Bloc<KrpcConnectionEvent, KrpcConnectionState> {
  ProviderContainer _container;
  ConnectionParameters _parameters;
  KrpcClient _client;

  KrpcConnectionBloc() : super(KrpcDisconnectedState()) {
    _container = ProviderContainer();
    _client = _container.read(clientProvider);
  }

  @override
  Stream<KrpcConnectionState> mapEventToState(
    KrpcConnectionEvent event,
  ) async* {
    if (event is ConnectionParametersEvent) {
      _parameters = event.parameters;
    } else if (event is RPCConnectionRequest) {
      yield KrpcConnectingState();

      if (_parameters.rpcValid) {
        yield* _tryToConnect();
      } else {
        yield KrpcDisconnectedState();
      }
    } else if (event is DisconnectKrpcEvent) {
      yield* _tryToDisconnect();
    }
  }

  Stream<KrpcConnectionState> _tryToConnect() async* {
    try {
      await _client.connectRPC();
      yield KrpcConnectedState();
    } on Exception catch (e, s) {
      yield KrpcConnectionErrorState(e.toString(), s.toString());
    }
  }

  Stream<KrpcConnectionState> _tryToDisconnect() async* {
    try {
      await _client.disconnect();
      yield KrpcDisconnectedState();
    } on Exception catch (e, s) {
      yield KrpcConnectionErrorState(e.toString(), s.toString());
    } finally {
      _client = null;
    }
  }
}
