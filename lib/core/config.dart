// Configuration

import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'assets.dart';

class Config {
  // production || development
  static Mode mode = Mode.production;

  init() async {
    if (mode == Mode.production) {
      if (kDebugMode) {
        dev.log("Warning: Running in production mode in debug mode!");
      }
      await dotenv.load(fileName: production);
    } else {
      if (kDebugMode) {
        dev.log("Warning: Running in development mode in debug mode!");
      }
      await dotenv.load(fileName: development);
    }
  }

  static bool isProduction() => mode == Mode.production;
}

enum Mode { development, production }
