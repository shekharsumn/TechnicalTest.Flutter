import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  
  factory ConnectivityService() => _instance;
  
  ConnectivityService._internal();
  static final ConnectivityService _instance = ConnectivityService._internal();

  final StreamController<ConnectivityResult> _connectivityController = 
      StreamController<ConnectivityResult>.broadcast();
  
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<ConnectivityResult> get connectivityStream => _connectivityController.stream;

  void initialize() {
    _subscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
        _connectivityController.add(result);
      },
    );
    
    // Get initial connectivity state
    _getInitialConnectivity();
  }

  Future<void> _getInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    final connectivityResult = result.isNotEmpty ? result.first : ConnectivityResult.none;
    _connectivityController.add(connectivityResult);
  }

  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

final connectivityStreamProvider = StreamProvider<ConnectivityResult>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream;
});

final isConnectedProvider = Provider<bool>((ref) {
  final connectivityAsync = ref.watch(connectivityStreamProvider);
  return connectivityAsync.when(
    data: (connectivity) => connectivity != ConnectivityResult.none,
    loading: () => false,
    error: (_, __) => false,
  );
});