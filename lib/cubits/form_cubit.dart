import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/contract_form_state.dart';

class FormCubit extends Cubit<ContractFormState> {
  FormCubit() : super(ContractFormState.initial());

  void updateFirstName(String value) =>
      emit(state.copyWith(firstName: value));

  void updateLastName(String value) =>
      emit(state.copyWith(lastName: value));

  void updateEmail(String value) =>
      emit(state.copyWith(email: value));

  void updateDateOfBirth(DateTime value) =>
      emit(state.copyWith(dateOfBirth: value));

  void togglePermission(bool value) =>
      emit(state.copyWith(permissionGiven: value));

  bool isComplete() {
    return state.firstName.isNotEmpty &&
        state.lastName.isNotEmpty &&
        state.email.isNotEmpty &&
        state.dateOfBirth != null &&
        state.permissionGiven;
  }
}
