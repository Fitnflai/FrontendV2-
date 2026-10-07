import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CachedHttp {
  static final Map<String, _CacheEntry> _cache = {};
  static final Map<String, Future<http.Response>> _pendingRequests = {};
  static http.Client? client;
  static bool inTestMode = false;

  static void setInTestMode(bool value) {
    inTestMode = value;
  }



  static Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final urlStr = url.toString();
    final now = DateTime.now();
    final actualHeaders = headers ?? {};
    final authHeader = actualHeaders['Authorization'] ?? '';
    final cacheKey = '$urlStr|$authHeader';

    // Cache policy: only GET requests to specific endpoints are cached
    final isCacheable = urlStr.contains('/entrenamientos/semana') || 
                        urlStr.contains('/users/me') ||
                        urlStr.contains('/estado-seguridad-parq') ||
                        urlStr.contains('/usuarios/mi-plan-activo');

    if (isCacheable) {
      final cached = _cache[cacheKey];
      if (cached != null && !cached.isExpired) {
        debugPrint('🎯 CachedHttp GET HIT: $urlStr');
        return cached.response;
      }

      // Deduplication of concurrent identical requests
      final pending = _pendingRequests[cacheKey];
      if (pending != null) {
        debugPrint('🔗 CachedHttp GET DEDUPLICATED: $urlStr');
        return pending;
      }

      debugPrint('🌐 CachedHttp GET FETCHING (MISS): $urlStr');
      final future = client != null
          ? client!.get(url, headers: actualHeaders)
          : http.get(url, headers: actualHeaders);
      _pendingRequests[cacheKey] = future;

      try {
        final response = await future;
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Cache duration: /users/me caches for 1 minute, weekly workouts cache for 5 minutes
          final duration = urlStr.contains('/users/me') 
              ? const Duration(minutes: 1) 
              : const Duration(minutes: 5);
          _cache[cacheKey] = _CacheEntry(response, now.add(duration));
        }
        return response;
      } finally {
        _pendingRequests.remove(cacheKey);
      }
    }

    // For non-cacheable GET requests, fallback directly to raw HTTP
    return client != null
        ? client!.get(url, headers: actualHeaders)
        : http.get(url, headers: actualHeaders);
  }

  static Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    debugPrint('⚡ CachedHttp POST: Invalidation triggered for $url');
    clearCache();
    final actualHeaders = headers ?? {};
    return client != null
        ? client!.post(url, headers: actualHeaders, body: body, encoding: encoding)
        : http.post(url, headers: actualHeaders, body: body, encoding: encoding);
  }

  static Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    debugPrint('⚡ CachedHttp PATCH: Invalidation triggered for $url');
    clearCache();
    final actualHeaders = headers ?? {};
    return client != null
        ? client!.patch(url, headers: actualHeaders, body: body, encoding: encoding)
        : http.patch(url, headers: actualHeaders, body: body, encoding: encoding);
  }

  static Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    debugPrint('⚡ CachedHttp PUT: Invalidation triggered for $url');
    clearCache();
    final actualHeaders = headers ?? {};
    return client != null
        ? client!.put(url, headers: actualHeaders, body: body, encoding: encoding)
        : http.put(url, headers: actualHeaders, body: body, encoding: encoding);
  }

  static Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    debugPrint('⚡ CachedHttp DELETE: Invalidation triggered for $url');
    clearCache();
    final actualHeaders = headers ?? {};
    return client != null
        ? client!.delete(url, headers: actualHeaders, body: body, encoding: encoding)
        : http.delete(url, headers: actualHeaders, body: body, encoding: encoding);
  }

  static void clearCache() {
    _cache.clear();
    debugPrint('🧹 CachedHttp CACHE CLEARED');
  }
}

class _CacheEntry {
  final http.Response response;
  final DateTime expiry;

  _CacheEntry(this.response, this.expiry);

  bool get isExpired => DateTime.now().isAfter(expiry);
}
