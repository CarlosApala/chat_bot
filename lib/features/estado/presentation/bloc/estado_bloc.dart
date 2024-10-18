import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'estado_event.dart';
part 'estado_state.dart';

class EstadoBloc extends Bloc<EstadoEvent, EstadoState> {
  EstadoBloc() : super(EstadoInitial()) {
    on<EstadoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
