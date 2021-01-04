import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/connection_bloc.dart';

class ConnectionWidget extends StatefulWidget {
  _ConnectionWidgetState createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  String ip;
  int rpcPort;
  int streamPort;
  String clientName;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: [
          Icon(Icons.error),
          InputField('ip address or "localhost"', ipValidator),
          InputField('RPC port', portValidator),
          InputField('Stream port', portValidator),
          InputField('Client name'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocConsumer<KrpcConnectionBloc, KrpcConnectionState>(
              listener: (context, state) {
                if (state is KrpcConnectionErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("ERROR! Couldn't connect"),
                    duration: Duration(seconds: 1),
                  ));
                }
              },
              builder: (context, state) {
                if (state is KrpcDisconnectedState) {
                  if (Form.of(context).validate()) {
                    return KrpcConnectionButton(ConnectionButtonStatus.toConnect);
                  } else {
                    return KrpcConnectionButton(ConnectionButtonStatus.notValid);
                  }
                } else if (state is KrpcConnectedState) {
                  return KrpcConnectionButton(ConnectionButtonStatus.connected);
                } else if (state is KrpcConnectionErrorState) {
                  return KrpcConnectionButton(ConnectionButtonStatus.error);
                }
                return KrpcConnectionButton(ConnectionButtonStatus.error);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final Function validator;

  InputField(this.label, [this.validator]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

/// kRPC connection button, to be used when entries are finished.
///
/// This connection button is grey by default until the entries of the form are
/// valid. Then it comes to amber, waiting for the user to push it. When kRPC is
/// connected, it turns green with the message "connected". Note: in case of
/// connection error, messaging is managed by the Scaffold with a SnackBar. This
/// button remains grey.
class KrpcConnectionButton extends StatelessWidget {
  final ConnectionButtonStatus _status;
  final Map<String, dynamic> _connectionData;
  String _text;
  Color _color;

  KrpcConnectionButton(this._status, [this._connectionData]) {
    switch (_status) {
      case ConnectionButtonStatus.notValid:
        _text = "Entries not valid";
        _color = Colors.grey;
        break;
      case ConnectionButtonStatus.toConnect:
        _text = "CONNECT";
        _color = Colors.amber;
        break;
      case ConnectionButtonStatus.connected:
        _text = "CONNECTED!";
        _color = Colors.green;
        break;
      case ConnectionButtonStatus.error:
        _text = "ERROR";
        _color = Colors.grey;
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
        if (_status == ConnectionButtonStatus.connected) {
          context.read<KrpcConnectionBloc>().add(DisconnectKrpcEvent());
        } else if (_status == ConnectionButtonStatus.toConnect) {
          context.read<KrpcConnectionBloc>().add(RPCConnectionRequest(
              _connectionData['ip'],
              _connectionData['rpcPort'],
              _connectionData['clientName']));
        }
      },
    );
  }
}

enum ConnectionButtonStatus { notValid, toConnect, connected, error }
