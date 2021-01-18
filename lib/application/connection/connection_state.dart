part of 'connection_bloc.dart';

@immutable
abstract class KrpcConnectionState {}

class KrpcDisconnectedState extends KrpcConnectionState {}

class KrpcConnectedState extends KrpcConnectionState {}

class KrpcConnectingState extends KrpcConnectionState {}


enum ConnectionValidity {valid, rpcOnly, invalid}

class KprcConnectionValidityState extends KrpcConnectionState {
  final ConnectionValidity validity;
  KprcConnectionValidityState(this.validity);
}


class KrpcConnectionErrorState extends KrpcConnectionState {
  final String error;
  final String stackTrace;
  KrpcConnectionErrorState(this.error, this.stackTrace);
}