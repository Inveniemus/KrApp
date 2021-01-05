import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kerbal_remote_application/domain/connection/connection_parameters.dart';

import '../../application/connection_bloc.dart';
import '../../domain/connection/ip.dart';
import '../../domain/connection/port.dart';

class ConnectionWidget extends StatefulWidget {
  @override
  _ConnectionWidgetState createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  ConnectionParameters _connectionParameters;

  @override
  void initState() {
    super.initState();
    _connectionParameters = ConnectionParameters();
  }

  void setNewConnectionParameters(ConnectionParameters newParameters) {
    _connectionParameters = newParameters;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Icon(Icons.error),
        IpInputField('ip address or "localhost"', Ip.localhost()),
        PortInputField('RPC port', Port.defaultRpc()),
        PortInputField('Stream port', Port.defaultStream()),
        TextInputField('Client name', 'Dart-client'),
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
                if (true) {
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
    );
  }
}

class IpInputField extends StatefulWidget {
  final String _label;
  final Ip _initialValue;

  IpInputField(this._label, this._initialValue);

  @override
  _IpInputFieldState createState() => _IpInputFieldState();
}

class _IpInputFieldState extends State<IpInputField> {
  Ip _value;
  String _inputMessage;

  @override
  void initState() {
    super.initState();
    _value = widget._initialValue;
  }

  void rebuildInputMessage(String message) {
    if (_inputMessage != message) {
      setState(() {
        _inputMessage = message;
      });
    }
  }

  void setValidValue(Ip ip) {
    setState(() {
      _value = ip;
      _inputMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: getInputDecoration(
            widget._label, widget._initialValue.value, _inputMessage),
        onChanged: (String value) {
          final ip = Ip(value);
          if (ip.isValid) {
            setValidValue(ip);
          } else if (value == '') {
            rebuildInputMessage(null);
          } else {
            rebuildInputMessage(ip.failure.description());
          }
        },
      ),
    );
  }
}

class PortInputField extends StatefulWidget {
  final String _label;
  final Port _initialValue;

  PortInputField(this._label, this._initialValue);

  @override
  _PortInputFieldState createState() => _PortInputFieldState();
}

class _PortInputFieldState extends State<PortInputField> {
  Port _value;
  String _inputMessage;

  @override
  void initState() {
    super.initState();
    _value = widget._initialValue;
  }

  void rebuildInputMessage(String message) {
    if (_inputMessage != message) {
      setState(() {
        _inputMessage = message;
      });
    }
  }

  void setValidValue(Port port) {
    setState(() {
      _value = port;
      _inputMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: getInputDecoration(
            widget._label, widget._initialValue.value, _inputMessage),
        onChanged: (String value) {
          final port = Port(value);
          if (port.isValid) {
            setValidValue(port);
          } else if (value == '') {
            rebuildInputMessage(null);
          } else {
            rebuildInputMessage(port.failure.description());
          }
        },
      ),
    );
  }
}

class TextInputField extends StatelessWidget {
  final String _label;
  final String _initialValue;

  TextInputField(this._label, this._initialValue);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: getInputDecoration(_label, _initialValue),
        onChanged: (String value) {},
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
