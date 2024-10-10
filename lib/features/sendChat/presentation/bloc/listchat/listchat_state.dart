part of 'listchat_bloc.dart';

@immutable
sealed class ListchatState {}

class ListchatInitial extends ListchatState {}

class ListchatLoading extends ListchatState {}

class ListchatLoaded extends ListchatState {
  final List<ChatModel> chats;

  ListchatLoaded(this.chats);
}

class ListchatError extends ListchatState {
  final String message;

  ListchatError(this.message);
}
