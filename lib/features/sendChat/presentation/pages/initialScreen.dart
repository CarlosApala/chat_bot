import 'dart:async';
import 'dart:typed_data';
import 'package:chat_bot_frontend/features/sendChat/presentation/pages/HomeScreen.dart';
import 'package:chat_bot_frontend/features/utils/utils.dart';
import 'package:chat_bot_frontend/features/utils/whastapp_session.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:whatsapp_bot_flutter/whatsapp_bot_flutter.dart';
import '';

class InintialScreen extends StatefulWidget {
  const InintialScreen({super.key});

  @override
  State<InintialScreen> createState() => _InintialScreenState();
}

class _InintialScreenState extends State<InintialScreen> {
  int _counter = 0;
  Uint8List? _qrCodeBytes;
  bool _isConnected = false;
  Timer? _qrCodeTimer;

  @override
  void initState() {
    super.initState();
    _initializeWhatsappClient();
  }

  @override
  void dispose() {
    _qrCodeTimer?.cancel();
    super.dispose();
  }

  void _initializeWhatsappClient() async {
    client = await WhatsappBotFlutter.connect(
      onConnectionEvent: (ConnectionEvent event) async {
        print(event.toString());
        if (event == ConnectionEvent.connected ||
            event == ConnectionEvent.authenticated) {
          setState(() {
            WhatsappSession().isConnected = true;
            WhatsappSession().qrCodeBytes = null;
          });
          _qrCodeTimer?.cancel(); // Cancela el temporizador al conectar
        } else if (event == ConnectionEvent.disconnected) {
          setState(() {
            WhatsappSession().isConnected = false;
          });
        }
      },
      onQrCode: (String qr, Uint8List? imageBytes) {
        setState(() {
          WhatsappSession().qrCodeBytes = imageBytes;
        });

        if (!WhatsappSession().isConnected) {
          _startQrCodeTimer(); // Inicia el timer solo si no está conectado
        }
      },
    );

    // Verifica el estado previo
    setState(() {
      _isConnected = WhatsappSession().isConnected;
      _qrCodeBytes = WhatsappSession().qrCodeBytes;
    });
  }

  void _startQrCodeTimer() {
    _qrCodeTimer?.cancel(); // Cancela cualquier timer previo
    _qrCodeTimer = Timer.periodic(Duration(seconds: 20), (timer) {
      print("Regenerando QR...");
      _initializeWhatsappClient(); // Vuelve a intentar la conexión solo si no estás conectado
    });
  }

  void _sendMessage(String phoneNumber, String message) async {
    if (client != null && _isConnected) {
      try {
        await client!.chat
            .sendTextMessage(phone: phoneNumber, message: message);
        print("Mensaje enviado a $phoneNumber: $message");
      } catch (e) {
        print("Error al enviar mensaje: $e");
      }
    } else {
      print("No está conectado o cliente no disponible.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Actualiza los estados de acuerdo al singleton
    _isConnected = WhatsappSession().isConnected;
    _qrCodeBytes = WhatsappSession().qrCodeBytes;
    FocusScope.of(context)
        .requestFocus(FocusNode()); // Evita que el foco se quede en un widget

    return ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_qrCodeBytes != null && !_isConnected)
              Column(
                children: [
                  Image.memory(_qrCodeBytes!),
                  const SizedBox(height: 20),
                  const Text(
                    'Escanee el código QR para conectar',
                    style: TextStyle(),
                  ),
                ],
              ),
            _isConnected ? const Text('Sesión conectada') : const ProgressBar(),
            const SizedBox(height: 20),
            /*  FilledButton(
              onPressed: () {
                // Llama al método para enviar un mensaje
                _sendMessage('1234567890', 'Hola desde Flutter!');
              },
              child: const Text('Enviar Mensaje'),
            ), */
          ],
        ),
      ),
    );
  }
}
