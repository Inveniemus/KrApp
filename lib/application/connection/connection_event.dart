part of 'connection_bloc.dart';

@immutable
abstract class KrpcConnectionEvent {}

class RPCConnectionRequest extends KrpcConnectionEvent {}
class DisconnectKrpcEvent extends KrpcConnectionEvent {}

abstract class ConnectionParametersEvent extends KrpcConnectionEvent {}
class IpParameterEvent extends ConnectionParametersEvent {
  final Ip ip;
  IpParameterEvent(this.ip);
}
class RpcPortParameterEvent extends ConnectionParametersEvent {
  final Port port;
  RpcPortParameterEvent(this.port);
}
class StreamPortParameterEvent extends ConnectionParametersEvent {
  final Port port;
  StreamPortParameterEvent(this.port);
}
class ClientNameParameterEvent extends ConnectionParametersEvent {
  final String string;
  ClientNameParameterEvent(this.string);
}