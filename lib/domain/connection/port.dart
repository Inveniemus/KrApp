import 'package:kerbal_remote_application/domain/ValueValidated.dart';

class Port extends ValueValidated<String> {
  final String _value;
  Port(this._value) : super(_value, PortValidator(_value));
}

class PortValidator extends Validator<String> {

  final String _value;
  PortValidator(this._value) : super(_value);

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

class PortFailure extends Failure {}
