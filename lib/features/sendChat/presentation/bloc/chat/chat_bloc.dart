import 'package:bloc/bloc.dart';
import 'package:chat_bot_frontend/features/sendChat/data/models/message_model.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/entities/chat.dart';
import 'package:chat_bot_frontend/features/sendChat/domain/usecases/chat_crud_use_case.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatCrudUseCase chatCrudUseCase;

  ChatBloc(this.chatCrudUseCase) : super(ChatInitial()) {
    on<ChatEvent>((event, emit) {});

    on<SaveChatMessage>((event, emit) async {
      final message = Chat(titulo: event.titulo, mensaje: event.mensaje);
      ChatModel chat = ChatModel.fromEntity(message);
      await chatCrudUseCase.addChat(chat);
      emit(ChatSaveChat());
    });

    on<DeleteChatMessage>(
      (event, emit) async {
        await chatCrudUseCase.deleteChat(event.id);
        emit(ChatSaveChat());
      },
    );

    on<UpdateChatMessage>(
      (event, emit) async {
        //final message = Chat(titulo: event.titulo, mensaje: event.mensaje);
        await chatCrudUseCase.updateChat(event.chat);
      },
    );
  }
}
