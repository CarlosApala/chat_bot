part of 'lista_contacto_bloc.dart';

@immutable
sealed class ListaContactoState {}

final class ListaContactoInitial extends ListaContactoState {}

final class ListaContactoLoadState extends ListaContactoState {
  List<String> headers;
  List<List<dynamic>> data;
  ListaContactoLoadState({required this.headers, required this.data});
}

final class ListaContactoSending extends ListaContactoState {
  List<String> headers;
  List<List<dynamic>> data;
  ListaContactoSending({required this.headers, required this.data});
}

final class ListaContactoSendend extends ListaContactoState {
  List<String> headers;
  List<List<dynamic>> data;
  ListaContactoSendend({required this.headers, required this.data});
}
