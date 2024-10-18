part of 'estado_bloc.dart';

abstract class EstadoState extends Equatable {
  const EstadoState();  

  @override
  List<Object> get props => [];
}
class EstadoInitial extends EstadoState {}
