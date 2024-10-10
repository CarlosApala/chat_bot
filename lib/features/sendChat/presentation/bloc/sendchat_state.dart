part of 'sendchat_bloc.dart';

abstract class SendchatState extends Equatable {
  const SendchatState();  

  @override
  List<Object> get props => [];
}
class SendchatInitial extends SendchatState {}
