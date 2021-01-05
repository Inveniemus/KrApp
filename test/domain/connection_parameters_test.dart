import 'package:flutter_test/flutter_test.dart';
import 'package:kerbal_remote_application/domain/connection/connection_parameters.dart';
import 'package:kerbal_remote_application/domain/connection/ip.dart';
import 'package:kerbal_remote_application/domain/connection/port.dart';

void main() {

  test('Invalid parameters', () {
    final param = ConnectionParameters();
    param.ip = Ip('lllllocalhost');
    param.rpcPort = Port('50000');
    expect(param.rpcValid, isFalse);
    expect(param.valid, isFalse);
  });

  test('Valid RPC parameters', () {
    final param = ConnectionParameters();
    param.ip = Ip('localhost');
    param.rpcPort = Port('50000');
    expect(param.rpcValid, isTrue);
    expect(param.valid, isFalse);
  });

  test('Valid stream parameters', () {
    final param = ConnectionParameters();
    param.ip = Ip('localhost');
    param.rpcPort = Port('50000');
    param.streamPort = Port('50001');
    expect(param.rpcValid, isTrue);
    expect(param.valid, isTrue);
  });
}