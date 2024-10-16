import 'dart:typed_data';

class WhatsappSession {
  static final WhatsappSession _instance = WhatsappSession._internal();

  factory WhatsappSession() {
    return _instance;
  }

  WhatsappSession._internal();

  bool isConnected = false;
  Uint8List? qrCodeBytes;
  // Puedes añadir más variables si es necesario
}
