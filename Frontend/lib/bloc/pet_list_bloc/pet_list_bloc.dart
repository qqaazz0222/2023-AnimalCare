import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pet_list_event.dart';
part 'pet_list_state.dart';

class PetListBloc extends Bloc<PetListEvent, PetListState> {
  PetListBloc() : super(PetListState()) {
    on<GetFocusedCardPetListEvent>(_onGetFocusedCardPetListEvent);
    on<GetAllPetListEvent>(_onGetAllPetListEvent);
  }

  Future<void> _onGetFocusedCardPetListEvent(GetFocusedCardPetListEvent event, Emitter<PetListState> emit) async {
    emit(state.copyWith(isLoading: true));



    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onGetAllPetListEvent(GetAllPetListEvent event, Emitter<PetListState> emit) async {
    // emit(state.copyWith(isLoading: true));
  }
}
