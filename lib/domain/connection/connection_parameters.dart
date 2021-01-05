import 'ip.dart';
import 'port.dart';

/// For kRPC connection parameters handling.
///
/// The client name is always optional, and only ip and rpc port are required
/// for an RPC connection.
class ConnectionParameters {
  Ip ip;
  Port rpcPort;
  Port streamPort;
  String clientName;

  bool get rpcValid {
    if (ip == null || ip.isFailed || rpcPort == null || rpcPort.isFailed) {
      return false;
    }
    return true;
  }

  bool get valid {
    if (!rpcValid || streamPort == null || streamPort.isFailed) {
      return false;
    }
    return true;
  }
}
