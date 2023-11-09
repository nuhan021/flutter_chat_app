abstract class ChangeEmailState {}

class ChangeEmailInitialState extends ChangeEmailState {}

class LoadingState extends ChangeEmailState {}

class EmailErrorState extends ChangeEmailState {
  final String msg;
  EmailErrorState({required this.msg});
}

class EmailValidateState extends ChangeEmailState {}

class PasswordValidateState extends ChangeEmailState {}

class PasswordErrorState extends ChangeEmailState {
  final String msg;
  PasswordErrorState({required this.msg});
}

