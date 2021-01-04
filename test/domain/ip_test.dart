import 'package:flutter_test/flutter_test.dart';
import 'package:kerbal_remote_application/domain/connection/ip.dart';

void main() {
  group('IpValidator class', () {
    test('Malformed ip address shall return a MalformedIpFailure', () {
      final ipValidator = IpValidator('192.168.1.');
      expect(ipValidator.getFailureOrNull() is MalformedIpFailure, true);
    });

    test('A correct ip address shall return null', () {
      final ipValidator = IpValidator('192.168.1.1');
      expect(ipValidator.getFailureOrNull(), isNull);
    });
  });

  group('Ip class', () {
    test('Correct Ip class constructor', () {
      final ip = Ip('192.168.1.1');
      expect(ip.isFailed, isFalse);
    });

    test('Incorrect Ip instance', () {
      final ip = Ip('192.168.1.');
      expect(ip.isFailed, isTrue);
      expect(ip.isValid, isFalse);
      expect(ip.failure is MalformedIpFailure, isTrue);
      expect(ip.value, isNull);
    });

    test('"localhost" shall be a correct ip address', () {
      final ip = Ip('localhost');
      expect(ip.isValid, isTrue);
    });
  });
}