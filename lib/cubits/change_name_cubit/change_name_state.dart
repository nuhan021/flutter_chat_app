abstract class ChangeNameState {}

class InitialState extends ChangeNameState {}

class LoadingState extends ChangeNameState {}

class PasswordValidateState extends ChangeNameState {}

class PasswordInvalideState extends ChangeNameState {
  final String msg;
  PasswordInvalideState({required this.msg});
}