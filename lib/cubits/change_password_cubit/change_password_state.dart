abstract class ChangePasswordState {}

class ChangePasswordInitialState extends ChangePasswordState {}

class ChangePasswordLoadingState extends ChangePasswordState {}

class ChangeOldPasswordValidateState extends ChangePasswordState {}

class ChangeOldPasswordErrorState extends ChangePasswordState {
  final String msg;
  ChangeOldPasswordErrorState({required this.msg});
}

class ChangePasswordNewPasswordValidateState extends ChangePasswordState {}

class ChangePasswordNewPasswordErrorState extends ChangePasswordState {
  final String msg;
  ChangePasswordNewPasswordErrorState({required this.msg});
}

