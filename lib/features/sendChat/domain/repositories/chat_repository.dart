import 'package:chat_bot_frontend/features/sendChat/data/models/message_model.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/entities/chat.dart';

abstract class ChatRepository {
  Future<void> addChat(ChatModel chat);
  Future<List<ChatModel>> getChats();
  Future<void> updateChat(ChatModel chat);
  Future<void> deleteChat(int id);
}
