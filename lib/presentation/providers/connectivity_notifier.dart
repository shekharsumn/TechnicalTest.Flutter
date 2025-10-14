import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity state class
class ConnectivityState {

  const ConnectivityState({
    this.isConnected = false,
    this.isLoading = false,
    this.error,
  });

  final bool isConnected;
  final bool isLoading;
  final String? error;

  ConnectivityState copyWith({
    bool? isConnected,
    bool? isLoading,
    String? error,
  }) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Connectivity Notifier using modern Riverpod pattern
class ConnectivityNotifier extends Notifier<ConnectivityState> {
  Timer? _timer;
  static const Duration _checkInterval = Duration(seconds: 15);

  @override
  ConnectivityState build() {
    // Initialize with loading state
    state = const ConnectivityState(isLoading: true);
    
    // Start connectivity monitoring
    _initialize();
    
    // Clean up when provider is disposed
    ref.onDispose(() {
      _timer?.cancel();
    });

    return state;
  }

  void _initialize() {
    // Initial check
    _checkConnection();

    // Periodic checks
    _timer = Timer.periodic(_checkInterval, (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      final connected = result.isNotEmpty && result.first.rawAddress.isNotEmpty;
      
      // Only update state if connection status changed
      if (connected != state.isConnected || state.isLoading) {
        state = ConnectivityState(
          isConnected: connected,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      // Only update if we're not already in disconnected state
      if (state.isConnected || state.isLoading) {
        state = ConnectivityState(
          isConnected: false,
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  /// Manually trigger connectivity check
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _checkConnection();
  }
}

/// Providers
final connectivityNotifierProvider = NotifierProvider<ConnectivityNotifier, ConnectivityState>(
  ConnectivityNotifier.new,
);

/// Convenience provider for just the connection status
final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(connectivityNotifierProvider).isConnected;
});

/// Convenience provider for loading state
final isConnectivityLoadingProvider = Provider<bool>((ref) {
  return ref.watch(connectivityNotifierProvider).isLoading;
});