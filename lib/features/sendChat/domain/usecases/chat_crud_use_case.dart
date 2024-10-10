import 'package:chat_bot_frontend/features/sendChat/data/models/message_model.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/entities/chat.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/repositories/chat_repository.dart';

class ChatCrudUseCase {
  final ChatRepository repository;

  ChatCrudUseCase(this.repository);

  // Método para agregar un nuevo chat
  Future<void> addChat(ChatModel chat) async {
    await repository.addChat(chat);
  }

  // Método para obtener todos los chats
  Future<List<ChatModel>> getChats() async {
    return await repository.getChats();
  }

  // Método para actualizar un chat
  Future<void> updateChat(ChatModel chat) async {
    await repository.updateChat(chat);
  }

  // Método para eliminar un chat
  Future<void> deleteChat(int id) async {
    await repository.deleteChat(id);
  }
}
