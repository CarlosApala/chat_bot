import 'package:bloc/bloc.dart';
import 'package:chat_bot_frontend/features/sendChat/data/models/message_model.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/entities/chat.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/usecases/chat_crud_use_case.dart';
import 'package:meta/meta.dart';

part 'listchat_event.dart';
part 'listchat_state.dart';

class ListchatBloc extends Bloc<ListchatEvent, ListchatState> {
  final ChatCrudUseCase chatCrudUseCase;

  ListchatBloc(this.chatCrudUseCase) : super(ListchatInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
  }

  Future<void> _onLoadChats(
      LoadChatsEvent event, Emitter<ListchatState> emit) async {
    emit(ListchatLoading());
    try {
      final chats = await chatCrudUseCase
          .getChats(); // Asumiendo que este método está implementado

      emit(ListchatLoaded(chats));
    } catch (e) {
      emit(ListchatError(e.toString()));
    }
  }
}
