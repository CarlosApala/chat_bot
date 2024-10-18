  import 'dart:io';
  import 'package:chat_bot_frontend/features/sendChat/data/datasources/serial_code_data_source.dart';
  import 'package:path_provider/path_provider.dart';
  import 'package:encrypt/encrypt.dart';
  import '../../domain/repositories/serial_code_repository.dart';

  class SerialCodeRepositoryImpl implements SerialCodeRepository {
    final SerialCodeDataSource dataSource;
    final String keyString = 'your-32-character-key-12345'; // Asegúrate de que sea de 32 caracteres
    late final Key key;
    late final IV iv;

    SerialCodeRepositoryImpl(this.dataSource) {
      key = Key.fromUtf8(keyString);
      iv = IV.fromLength(16); // IV de 16 bytes
    }

    @override
    Future<bool> verifySerialCode(String serialCode) async {
      bool isValid = await dataSource.validateCode(serialCode);
      if (isValid) {
        await _createValidationFile();
      }
      return isValid;
    }

    Future<void> _createValidationFile() async {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/serial_validation.enc';

      if (await File(filePath).exists()) {
        return; // Si el archivo ya existe, no hacer nada
      }

      final encrypter = Encrypter(AES(key));
      final encrypted = encrypter.encrypt('Serial code validated successfully', iv: iv);
      final file = File(filePath);
      await file.writeAsString(encrypted.base64);
    }

    @override
    Future<bool> hasValidSerial() async {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/serial_validation.enc';
      final file = File(filePath);
      return await file.exists();
    }
  }
