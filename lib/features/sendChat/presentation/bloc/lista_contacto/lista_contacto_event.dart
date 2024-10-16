part of 'lista_contacto_bloc.dart';

@immutable
sealed class ListaContactoEvent {}

class LoadExcel extends ListaContactoEvent {}

class EnviarMensajesMasivos extends ListaContactoEvent {
  int index;
  String mensaje;
  EnviarMensajesMasivos({required this.index,required this.mensaje});
}
