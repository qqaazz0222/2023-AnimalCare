part of 'pet_list_bloc.dart';

class PetListState {
  final List<dynamic>? petList;
  final int? focusedPet;
  final bool isLoading;

  PetListState({this.petList = const [], this.focusedPet = 0, this.isLoading = false});

  PetListState copyWith({
    List<dynamic>? petList,
    int? focusedPet,
    bool isLoading = false,
}){
    return PetListState(
      petList: petList ?? this.petList,
      focusedPet: focusedPet ?? this.focusedPet,
      isLoading: isLoading
    );
  }
}

