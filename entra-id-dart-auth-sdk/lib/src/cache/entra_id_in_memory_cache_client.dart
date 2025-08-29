import 'dart:async';
import 'package:entra_id_dart_auth_sdk/src/interfaces/entra_id_i_cache_client.dart';

class InMemoryCacheClient implements EntraIdICacheClient {
  final Map<String, _Entry> _store = {};
  final bool _enableSweeper;
  final Duration _sweepInterval;
  Timer? _sweeper;

  InMemoryCacheClient({
    bool enableSweeper = true,
    Duration sweepInterval = const Duration(minutes: 5),
  }) : _enableSweeper = enableSweeper,
       _sweepInterval = sweepInterval {
    if (_enableSweeper) {
      _sweeper = Timer.periodic(_sweepInterval, (_) => _purgeExpired());
    }
  }

  @override
  Future<void> save(String key, String value, {Duration? ttl}) async {
    _store[key] = _Entry(
      value: value,
      expiresAt: ttl == null ? null : DateTime.now().add(ttl),
    );
  }

  @override
  Future<String?> retrieve(String key) async {
    final e = _store[key];
    if (e == null) return null;
    if (e.isExpired) {
      _store.remove(key);
      return null;
    }
    return e.value;
  }

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }

  void dispose() {
    _sweeper?.cancel();
    _sweeper = null;
  }

  void _purgeExpired() {
    final now = DateTime.now();
    _store.removeWhere(
      (_, e) => e.expiresAt != null && e.expiresAt!.isBefore(now),
    );
  }
}

class _Entry {
  final String value;
  final DateTime? expiresAt;
  _Entry({required this.value, this.expiresAt});
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}
