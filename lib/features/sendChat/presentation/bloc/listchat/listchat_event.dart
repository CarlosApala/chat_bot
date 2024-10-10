part of 'listchat_bloc.dart';

@immutable
sealed class ListchatEvent {}

class LoadChatsEvent extends ListchatEvent {}
