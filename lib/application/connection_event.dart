part of 'connection_bloc.dart';

@immutable
abstract class KrpcConnectionEvent {}

class RPCConnectionRequest extends KrpcConnectionEvent {
  final String ip;
  final int rpcPort;
  final String clientName;
  RPCConnectionRequest(this.ip, this.rpcPort, this.clientName);
}

class DisconnectKrpcEvent extends KrpcConnectionEvent {}
