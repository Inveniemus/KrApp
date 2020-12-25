import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import 'kr_app.dart';

void main() {
  // Run the app, with the provider scope
  runApp(ProviderScope(child: KrApp()));
}
