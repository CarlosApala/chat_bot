import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sendchat_event.dart';
part 'sendchat_state.dart';

class SendchatBloc extends Bloc<SendchatEvent, SendchatState> {
  SendchatBloc() : super(SendchatInitial()) {
    on<SendchatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
