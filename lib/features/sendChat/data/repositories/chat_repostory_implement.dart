import 'package:chat_bot_frontend/features/sendChat/data/models/message_model.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/entities/chat.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/repositories/chat_repository.dart';
import 'package:isar/isar.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Isar isar;
  ChatRepositoryImpl(this.isar);

  @override
  Future<void> addChat(ChatModel chat) async {
    try {
      //final chatModel = ChatModel.fromEntity(chat);
      await isar.writeTxn(() async {
        await isar.chatModels.put(chat);
      });
    } catch (e) {
      // Manejo del error, puedes lanzar una excepción o registrar el error
      throw Exception('Error al agregar el chat: $e');
    }
  }

  @override
  Future<List<ChatModel>> getChats() async {
    try {
      final chatModels = await isar.chatModels.where().findAll();
      return chatModels.map((chatModel) => chatModel).toList();
      //return chatModels.map((chatModel) => chatModel).toList();
    } catch (e) {
      // Manejo del error
      throw Exception('Error al obtener los chats: $e');
    }
  }

  @override
  Future<void> updateChat(ChatModel chat) async {
    try {
      //final chatModel = ChatModel.fromEntity(chat);
      await isar.writeTxn(() async {
        await isar.chatModels.put(chat);
      });
    } catch (e) {
      // Manejo del error
      throw Exception('Error al actualizar el chat: $e');
    }
  }

  @override
  Future<void> deleteChat(int id) async {
    try {
      await isar.writeTxn(() async {
        final success = await isar.chatModels.delete(id);
        print("se elimino el objeto $success");
      });
    } catch (e) {
      // Manejo del error
      throw Exception('Error al eliminar el chat: $e');
    }
  }
}
