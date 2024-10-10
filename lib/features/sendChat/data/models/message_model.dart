import 'package:chat_bot_frontend/features/sendChat/domain/entities/chat.dart';
import 'package:isar/isar.dart';

part 'message_model.g.dart'; // Generado automáticamente

@collection
class ChatModel {
  Id? id;
  String? titulo;
  String? mensaje;

  ChatModel({this.id, this.titulo, this.mensaje});

  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      id: chat.id,
      titulo: chat.titulo,
      mensaje: chat.mensaje,
    );
  }

  Chat toEntity() {
    return Chat(
      titulo: titulo,
      mensaje: mensaje,
    );
  }
}
