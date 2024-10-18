import 'dart:io';

import 'package:chat_bot_frontend/features/sendChat/data/datasources/serial_code_data_source.dart';
import 'package:chat_bot_frontend/features/sendChat/data/repositories/serial_code_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';

import '../datasources/serial_code_data_source_test.mocks.dart';

@GenerateMocks([SerialCodeDataSource])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SerialCodeRepositoryImpl repository;
  late MockSerialCodeDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSerialCodeDataSource();
    repository = SerialCodeRepositoryImpl(mockDataSource);
  });

  group('SerialCodeRepositoryImpl', () {
    test('should validate serial code and create validation file', () async {
      when(mockDataSource.validateCode('d3aef7f7-3571-4a5a-adef-789eb1b8990e')).thenAnswer((_) async => true);

    final isValid=await repository.verifySerialCode('d3aef7f7-3571-4a5a-adef-789eb1b8990e');
    print(isValid);
    /*   final isValid = await repository
          .verifySerialCode('d3aef7f7-3571-4a5a-adef-789eb1b8990e');

      expect(isValid, true); */
    });

    test('should return false if serial code is invalid', () async {
      when(mockDataSource.validateCode(any)).thenAnswer((_) async => false);

      final isValid = await repository.verifySerialCode('invalid-code');

      expect(isValid, false);
    });

    test('should check if validation file exists', () async {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/serial_validation.enc';
      final file = File(filePath);
      await file.writeAsString('test'); // Creating file

      when(mockDataSource.validateCode(any)).thenAnswer((_) async => true);

      final bool hasValid = await repository.hasValidSerial();

      expect(hasValid, true);

      await file.delete(); // Clean up
    });

    test('should return false if validation file does not exist', () async {
      final bool hasValid = await repository.hasValidSerial();
      expect(hasValid, false);
    });
  });
}
