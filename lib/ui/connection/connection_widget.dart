import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/connection_bloc.dart';
import '../../domain/connection/ip.dart';
import '../../domain/connection/port.dart';

typedef IpCallback = Function(Ip ip);
typedef PortCallback = Function(Port port);

class ConnectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Icon(Icons.error),
        InputField<Ip>('ip address or "localhost"'),
        InputField<Port>('RPC port'),
        InputField<Port>('Stream port'),
        InputField<String>('Client name'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocConsumer<KrpcConnectionBloc, KrpcConnectionState>(
            listener: (context, state) {
              print(state);
              if (state is KrpcConnectionErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("ERROR! Couldn't connect"),
                  duration: Duration(seconds: 1),
                ));
              }
            },
            builder: (context, state) {
              if (state is KrpcDisconnectedState) {
                return KrpcConnectionButton(ConnectionButtonStatus.ready);
              } else if (state is KrpcConnectedState) {
                return KrpcConnectionButton(ConnectionButtonStatus.connected);
              } else if (state is KrpcConnectingState) {
                return KrpcConnectionButton(ConnectionButtonStatus.connecting);
              } else if (state is KprcConnectionValidityState) {
                if (state.validity == ConnectionValidity.invalid) {
                  return KrpcConnectionButton(ConnectionButtonStatus.notValid);
                } else if (state.validity == ConnectionValidity.rpcOnly) {
                  return KrpcConnectionButton(ConnectionButtonStatus.rpcOnly);
                } else {
                  return KrpcConnectionButton(ConnectionButtonStatus.ready);
                }
              } else if (state is KrpcConnectionErrorState) {
                return KrpcConnectionButton(ConnectionButtonStatus.error);
              } else {
                return KrpcConnectionButton(ConnectionButtonStatus.ready);
              }
            },
          ),
        ),
      ],
    );
  }
}

class InputField<T> extends StatefulWidget {
  final String _label;

  InputField(this._label);

  @override
  _InputFieldState<T> createState() => _InputFieldState<T>();
}

class _InputFieldState<T> extends State<InputField> {
  String _inputMessage;

  void _processStringValue(String value) {
    if (T is Ip) {
      final ip = Ip(value);
      if (ip.isValid || value == '') {
        context.read<KrpcConnectionBloc>().add(IpParameterEvent(ip));
        _rebuildInputMessage(null);
      } else {
        _rebuildInputMessage(ip.failure.description());
      }
    } else if (T is Port) {
      final port = Port(value);
      if (port.isValid || value == '') {
        if (widget._label == 'RPC port') {
          context.read<KrpcConnectionBloc>().add(RpcPortParameterEvent(port));
        } else if (widget._label == 'Stream port') {
          context
              .read<KrpcConnectionBloc>()
              .add(StreamPortParameterEvent(port));
        }
        _rebuildInputMessage(null);
      } else {
        _rebuildInputMessage(port.failure.description());
      }
    } else if (T is String) {
      context.read<KrpcConnectionBloc>().add(ClientNameParameterEvent(value));
    }
  }

  void _rebuildInputMessage(String message) {
    if (_inputMessage != message) {
      setState(() {
        _inputMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: getInputDecoration(widget._label, _inputMessage),
        onChanged: (String value) {
          _processStringValue(value);
        },
      ),
    );
  }
}

InputDecoration getInputDecoration(String label, [String hint, String helper]) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    helperText: helper,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
  );
}

/// kRPC connection button, to be used when entries are finished.
///
/// This connection button is grey by default until the entries of the form are
/// valid. Then it comes to amber, waiting for the user to push it. When kRPC is
/// connected, it turns green with the message "connected".
class KrpcConnectionButton extends StatelessWidget {
  final ConnectionButtonStatus _status;

  String _text;
  Color _color;

  KrpcConnectionButton(this._status) {
    switch (_status) {
      case ConnectionButtonStatus.notValid:
        _text = "Entries not valid!";
        _color = Colors.grey;
        break;
      case ConnectionButtonStatus.ready:
        _text = "Connect?";
        _color = Colors.amber;
        break;
      case ConnectionButtonStatus.connected:
        _text = "Connected!";
        _color = Colors.green;
        break;
      case ConnectionButtonStatus.error:
        _text = "ERROR!";
        _color = Colors.grey;
        break;
      case ConnectionButtonStatus.rpcOnly:
        _text = "RPC only";
        _color = Colors.greenAccent;
        break;
      case ConnectionButtonStatus.connecting:
        _text = 'Connecting...';
        _color = Colors.redAccent;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: _color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Text(_text),
      onPressed: () {
        if (_status == ConnectionButtonStatus.notValid) {
          context.read<KrpcConnectionBloc>().add(RPCConnectionRequest());
        } else if (_status == ConnectionButtonStatus.rpcOnly) {
          context.read<KrpcConnectionBloc>().add(RPCConnectionRequest());
        } else if (_status == ConnectionButtonStatus.ready) {
          context.read<KrpcConnectionBloc>().add(RPCConnectionRequest());
        } else if (_status == ConnectionButtonStatus.connected) {
          context.read<KrpcConnectionBloc>().add(DisconnectKrpcEvent());
        } else if (_status == ConnectionButtonStatus.error) {
          context.read<KrpcConnectionBloc>().add(RPCConnectionRequest());
        }
      },
    );
  }
}

enum ConnectionButtonStatus {notValid, rpcOnly, ready, connecting, connected, error }
