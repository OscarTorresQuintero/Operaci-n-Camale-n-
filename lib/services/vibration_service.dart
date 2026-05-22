import 'package:vibration/vibration.dart';

/// Servicio de vibración para señales del Protocolo ShadowNet.
///
/// Implementa patrones de vibración basados en código Morse
/// para comunicar eventos al operador sin necesidad de audio.
class VibrationService {

  /// Duración en ms de un punto Morse (.).
  static const int _kDot = 100;

  /// Duración en ms de una raya Morse (—).
  static const int _kDash = 300;

  /// Pausa en ms entre símbolos del mismo carácter.
  static const int _kSymbolGap = 100;

  /// Pausa en ms entre letras distintas.
  static const int _kLetterGap = 300;

  /// Patrón Morse de "OK" usado al completar una misión.
  ///
  /// O = .--   K = -.-
  static const List<int> _missionComplete = [
    _kDot,  _kSymbolGap,
    _kDash, _kSymbolGap,
    _kDash,
    _kLetterGap,
    _kDash, _kSymbolGap,
    _kDot,  _kSymbolGap,
    _kDash,
  ];

  /// Patrón SOS usado al detectar un nodo cercano.
  ///
  /// S = ...   O = ---   S = ...
  static const List<int> _nodeDetected = [
    _kDot, _kSymbolGap, _kDot, _kSymbolGap, _kDot,
    _kLetterGap,
    _kDash, _kSymbolGap, _kDash, _kSymbolGap, _kDash,
    _kLetterGap,
    _kDot, _kSymbolGap, _kDot, _kSymbolGap, _kDot,
  ];

  /// Patrón de autodestrucción tras 3 fallos biométricos.
  ///
  /// Genera una secuencia de vibraciones fuertes con pausas largas.
  static const List<int> _selfDestruct = [
    500, 150,
    500, 150,
    500, 150,
    1000, 200,
    1000, 200,
    1000,
  ];

  /// Vibra el código Morse "OK" al completar una misión.
  ///
  /// No hace nada si el dispositivo no tiene motor de vibración.
  static Future<void> missionComplete() async {
    final bool hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;

    await Vibration.vibrate(pattern: _missionComplete);
  }

  /// Vibra SOS (...---...) al detectar un nodo cercano.
  static Future<void> nodeDetected() async {
    final bool hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;

    await Vibration.vibrate(pattern: _nodeDetected);
  }

  /// Vibra patrón fuerte de autodestrucción tras tres fallos biométricos.
  static Future<void> selfDestruct() async {
    final bool hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;

    await Vibration.vibrate(pattern: _selfDestruct);
  }

  /// Cancela cualquier vibración activa en el dispositivo.
  static Future<void> cancel() async {
    await Vibration.cancel();
  }
}
