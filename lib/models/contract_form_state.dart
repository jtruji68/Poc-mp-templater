class ContractFormState {
  final String firstName;
  final String lastName;
  final String email;
  final DateTime? dateOfBirth;
  final bool permissionGiven;

  ContractFormState({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.permissionGiven,
  });

  factory ContractFormState.initial() => ContractFormState(
    firstName: '',
    lastName: '',
    email: '',
    dateOfBirth: null,
    permissionGiven: false,
  );

  ContractFormState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    DateTime? dateOfBirth,
    bool? permissionGiven,
  }) {
    return ContractFormState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      permissionGiven: permissionGiven ?? this.permissionGiven,
    );
  }
}