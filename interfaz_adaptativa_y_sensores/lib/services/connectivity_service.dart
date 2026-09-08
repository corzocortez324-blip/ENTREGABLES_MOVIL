import 'package:connectivity_plus/connectivity_plus.dart';

/// Representa el tipo de señal/conexión detectada en el dispositivo.
enum SignalStatus { wifi, mobile, ethernet, vpn, bluetooth, other, none }

extension SignalStatusX on SignalStatus {
  bool get hasSignal => this != SignalStatus.none;

  String get label {
    switch (this) {
      case SignalStatus.wifi:
        return 'Conectado por Wi-Fi';
      case SignalStatus.mobile:
        return 'Conectado por datos móviles';
      case SignalStatus.ethernet:
        return 'Conectado por Ethernet';
      case SignalStatus.vpn:
        return 'Conectado por VPN';
      case SignalStatus.bluetooth:
        return 'Conectado por Bluetooth';
      case SignalStatus.other:
        return 'Conectado';
      case SignalStatus.none:
        return 'Sin señal / sin conexión';
    }
  }

  String get shortLabel {
    switch (this) {
      case SignalStatus.wifi:
        return 'Wi-Fi';
      case SignalStatus.mobile:
        return 'Datos móviles';
      case SignalStatus.ethernet:
        return 'Ethernet';
      case SignalStatus.vpn:
        return 'VPN';
      case SignalStatus.bluetooth:
        return 'Bluetooth';
      case SignalStatus.other:
        return 'Otro';
      case SignalStatus.none:
        return 'Sin señal';
    }
  }
}

/// Envuelve `connectivity_plus` para exponer el estado de señal del
/// teléfono como un [Stream] (tiempo real) y como una consulta puntual.
///
/// Nota: `connectivity_plus` indica el TIPO de conexión de red disponible
/// (Wi-Fi, datos móviles, ninguna, etc.). Es la forma multiplataforma
/// estándar en Flutter de saber "si hay señal"; no expone la intensidad en
/// dBm de la antena celular, ya que eso requeriría plugins nativos
/// específicos de Android y no está disponible de forma fiable en iOS.
class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<SignalStatus> get statusStream =>
      _connectivity.onConnectivityChanged.map(_mapResults);

  Future<SignalStatus> checkNow() async {
    final results = await _connectivity.checkConnectivity();
    return _mapResults(results);
  }

  SignalStatus _mapResults(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return SignalStatus.none;
    }
    if (results.contains(ConnectivityResult.mobile)) return SignalStatus.mobile;
    if (results.contains(ConnectivityResult.wifi)) return SignalStatus.wifi;
    if (results.contains(ConnectivityResult.ethernet)) {
      return SignalStatus.ethernet;
    }
    if (results.contains(ConnectivityResult.vpn)) return SignalStatus.vpn;
    if (results.contains(ConnectivityResult.bluetooth)) {
      return SignalStatus.bluetooth;
    }
    return SignalStatus.other;
  }
}
