part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class SaveChatMessage extends ChatEvent {
  final String titulo;
  final String mensaje;

  SaveChatMessage({required this.titulo, required this.mensaje});
}

class UpdateChatMessage extends ChatEvent {
  final ChatModel chat;
  UpdateChatMessage({required this.chat});
}

class DeleteChatMessage extends ChatEvent {
  int id;
  DeleteChatMessage({required this.id});
}
