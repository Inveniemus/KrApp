import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerbal_remote_application/domain/connection/ip.dart';
import 'package:kerbal_remote_application/domain/connection/port.dart';
import 'package:kerbal_remote_application/krpc/client.dart';
import 'package:krpc_dart/krpc_dart.dart';
import 'package:mockito/mockito.dart';
import 'package:kerbal_remote_application/application/connection_bloc.dart';

// Mocks
class KrpcClientMock extends Mock implements KrpcClient {}

// Custom Matchers
class ConnectionValidityMatcher extends CustomMatcher {
  ConnectionValidityMatcher(ConnectionValidity matcher)
      : super('KprcConnectionValidityState with validity to', 'validity',
            matcher);

  featureValueOf(actual) => (actual as KprcConnectionValidityState).validity;
}

void main() {
  KrpcClientMock krpcClientMock;
  ProviderContainer container;

  setUp(() {
    krpcClientMock = KrpcClientMock();
    container = ProviderContainer(
      overrides: [
        clientProvider.overrideWithProvider(Provider((ref) => krpcClientMock)),
      ],
    );
  });

  blocTest(
    'Should emit an invalid Validity State when only Ip is changed',
    build: () => KrpcConnectionBloc(),
    act: (bloc) => bloc.add(IpParameterEvent(Ip('localhost'))),
    expect: [ConnectionValidityMatcher(ConnectionValidity.invalid)],
  );

  blocTest(
    'Should emit a valid Validity State when Ip and ports are set',
    build: () => KrpcConnectionBloc(),
    act: (bloc) {
      bloc.add(IpParameterEvent(Ip('localhost')));
      bloc.add(RpcPortParameterEvent(Port('1000')));
      bloc.add(StreamPortParameterEvent(Port('1001')));
    },
    expect: [
      ConnectionValidityMatcher(ConnectionValidity.invalid),
      ConnectionValidityMatcher(ConnectionValidity.rpcOnly),
      ConnectionValidityMatcher(ConnectionValidity.valid)
    ],
  );

  blocTest(
      'Should call for client connection when Connection parameters are rpcOnly'
      'valid and a connection request event is received',
    build: () => KrpcConnectionBloc(),
    act: (bloc) {
      bloc.add(IpParameterEvent(Ip('localhost')));
      bloc.add(RpcPortParameterEvent(Port('1000')));
      bloc.add(RPCConnectionRequest());
    },
    expect: [
      ConnectionValidityMatcher(ConnectionValidity.invalid),
      ConnectionValidityMatcher(ConnectionValidity.rpcOnly),
      isA<KrpcConnectingState>(),
      isA<KrpcConnectedState>(),
    ]
  );
}
