import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_bot_frontend/features/utils/utils.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'lista_contacto_event.dart';
part 'lista_contacto_state.dart';

class ListaContactoBloc extends Bloc<ListaContactoEvent, ListaContactoState> {
  List<String> _headers = [];
  List<List<dynamic>> _data = [];

  ListaContactoBloc() : super(ListaContactoInitial()) {
    on<ListaContactoEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadExcel>((event, emit) async {
      // Asegúrate de que el contexto sea válido al llamar a FilePicker
      try {
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

        if (result != null && result.files.isNotEmpty) {
          final file = File(result.files.single.path!);
          var bytes = await file.readAsBytes();
          var excel = Excel.decodeBytes(bytes);

          for (var table in excel.tables.keys) {
            var sheet = excel.tables[table];

            if (sheet != null) {
              _headers = sheet.rows.first
                  .map((cell) => cell?.value?.toString() ?? '')
                  .toList()
                  .cast<String>();
              _data = sheet.rows
                  .skip(1)
                  .map((row) => row.map((cell) => cell?.value ?? '').toList())
                  .toList();
            }
          }
        }
        emit(ListaContactoLoadState(headers: _headers, data: _data));
      } catch (e) {
        // Manejo de errores
        print('Error al cargar el archivo: $e');
      }
    });
    on<EnviarMensajesMasivos>(
      (event, emit) async {
        int numDatosEnviados = 0;
        List<List<dynamic>> lista = [];
        List<String> headers = List.from(_headers); // Clonamos los headers

        try {
          await for (var sent in sendMessagesToColumnAsStream(
              _headers[event.index], event.mensaje)) {
            if (sent) {
              lista.add(_data[numDatosEnviados++]);
              emit(ListaContactoSendend(headers: headers, data: lista));
            }
          }
        } catch (e) {
          print('Error al enviar mensajes: $e');
        }
      },
    );
  }

  Stream<bool> sendMessagesToColumnAsStream(
      String columnName, String message) async* {
    // Obtiene la lista de números de la columna
    List<dynamic> phoneNumbers = getFieldValues(columnName);

    // Recorre los números y envía el mensaje a cada uno
    for (var phoneNumber in phoneNumbers) {
      try {
        // Enviar mensaje usando la librería de WhatsApp
        bool sent = await sendWhatsAppMessage(phoneNumber.toString(), message);
        yield sent; // Emitir true si el envío fue exitoso
      } catch (e) {
        yield false; // Emitir false si hubo un error
        print('Error al enviar mensaje a $phoneNumber: $e');
      }
    }
  }

  Future<bool> sendWhatsAppMessage(String phoneNumber, String message) async {
    try {
      await client!.chat
          .sendTextMessage(message: message, phone: "591" + phoneNumber);
      return true; // Si se envía con éxito, retorna true
    } catch (e) {
      print('Fallo el envío del mensaje a $phoneNumber: $e');
      return false; // Retorna false si hubo un error
    }
  }

  List<dynamic> getFieldValues(String columnName) {
    int columnIndex = _headers.indexOf(columnName);

    if (columnIndex == -1) {
      throw Exception('La cabecera "$columnName" no existe.');
    }

    // Extrae los valores de la columna correspondiente
    List<dynamic> values = _data.map((row) => row[columnIndex]).toList();

    return values;
  }
}
