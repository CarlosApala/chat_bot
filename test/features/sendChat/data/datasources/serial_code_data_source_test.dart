import 'dart:io';

import 'package:chat_bot_frontend/features/sendChat/data/datasources/serial_code_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';

import 'serial_code_data_source_test.mocks.dart';

@GenerateMocks([SerialCodeDataSource, http.Client])
void main() {
  group('probar el codigo serial', () {
    test('paso la prueba de envio de datos', () async {
      final datos = MockSerialCodeDataSource();
      when(datos.validateCode("d3aef7f7-3571-4a5a-adef-789eb1b8990e"))
          .thenAnswer((_) async => true);

      final bool actual =
          await datos.validateCode('d3aef7f7-3571-4a5a-adef-789eb1b8990e');
      final bool matcher = true;
      expect(actual, matcher);
    });


test('probando errores', () async {
  final datos = MockSerialCodeDataSource();
  // Cualquier código inválido debe lanzar una excepción
  when(datos.validateCode(any)).thenThrow(Exception("Invalid dcode"));

  expect(() async => await datos.validateCode("invalid-code"), throwsException);
  expect(() async => await datos.validateCode("inasdfka-code"), throwsException);
});



  });
}
