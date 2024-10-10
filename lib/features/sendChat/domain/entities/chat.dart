import 'package:isar/isar.dart';

part 'chat.g.dart'; // Generado automáticamente

@collection
class Chat {
  Id id = Isar.autoIncrement; // Campo id requerido por Isar, con autoincremento
  String? titulo;
  String? mensaje;

  Chat({this.titulo, this.mensaje});
}
