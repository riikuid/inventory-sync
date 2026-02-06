// go_router_refresh.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

/// Dengerin banyak stream/cubit sekaligus, trus panggil notifyListeners()
/// supaya GoRouter nge-re-run redirect() kalo ada perubahan state.
class RouterRefresh extends ChangeNotifier {
  final List<Stream<dynamic>> _streams;
  late final List<StreamSubscription> _subs;

  RouterRefresh(this._streams) {
    _subs = _streams.map((s) => s.listen((_) => notifyListeners())).toList();
  }

  @override
  void dispose() {
    for (final sub in _subs) {
      sub.cancel();
    }
    super.dispose();
  }
}
