part of 'connection_bloc.dart';

@immutable
abstract class KrpcConnectionEvent {}

class ConnectionParametersEvent extends KrpcConnectionEvent {
  final ConnectionParameters parameters;
  ConnectionParametersEvent(this.parameters);
}
class RPCConnectionRequest extends KrpcConnectionEvent {}
class DisconnectKrpcEvent extends KrpcConnectionEvent {}
