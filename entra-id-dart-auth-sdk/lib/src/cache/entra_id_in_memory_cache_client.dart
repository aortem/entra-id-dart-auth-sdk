import 'dart:async';
import 'package:entra_id_dart_auth_sdk/src/interfaces/entra_id_i_cache_client.dart';

/// An in-memory implementation of the cache client for storing authentication tokens.
///
/// This cache stores key-value pairs in memory with optional expiration (TTL).
/// It supports automatic purging of expired entries via a background sweep timer.
class InMemoryCacheClient implements EntraIdICacheClient {
  final Map<String, _Entry> _store = {};
  final bool _enableSweeper;
  final Duration _sweepInterval;
  Timer? _sweeper;

  /// Creates an in-memory cache client instance.
  ///
  /// [enableSweeper] Whether to enable automatic expiration sweep. Defaults to true.
  /// [sweepInterval] How often to check for expired entries. Defaults to 5 minutes.
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

  /// Disposes the cache client and cancels the expiration sweep timer.
  ///
  /// Call this method when the cache is no longer needed to prevent resource leaks.
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
