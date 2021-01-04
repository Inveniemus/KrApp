import '../ValueValidated.dart';

class Ip extends ValueValidated<String> {
  final String _value;
  Ip(this._value) : super(_value, IpValidator(_value));
}

class IpValidator extends Validator<String> {
  final String _value;
  IpValidator(this._value) : super(_value);

  @override
  Failure getFailureOrNull() {
    if (_value == 'localhost') return null;
    final ipRE = RegExp(r'\d+\.\d+\.\d+\.\d+');
    if (!ipRE.hasMatch(_value)) {
      return MalformedIpFailure();
    } else {
      return null;
    }
  }
}

class MalformedIpFailure extends Failure {}