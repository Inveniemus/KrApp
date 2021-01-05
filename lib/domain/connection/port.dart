import 'package:kerbal_remote_application/domain/ValueValidated.dart';

final defaultStreamPort = Port('50001');

class Port extends ValueValidated<String> {
  final String _value;
  Port(this._value) : super(_value, PortValidator(_value));

  Port.defaultRpc() : this('50000');
  Port.defaultStream() : this('50001');
}

class PortValidator extends Validator<String> {

  final String _value;
  const PortValidator(this._value) : super(_value);

  @override
  Failure getFailureOrNull() {
    final portRE = RegExp(
        r'^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|'
        r'655[0-2][0-9]|6553[0-5])$');
    if (portRE.hasMatch(_value)) {
      return null;
    }
    return PortFailure();
  }
}

class PortFailure extends Failure {
  String description() => 'Port number is incorrect.';
}
