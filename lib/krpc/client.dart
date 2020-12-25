import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krpc_dart/krpc_dart.dart';

final clientProvider = Provider((ref) => KrpcClient());