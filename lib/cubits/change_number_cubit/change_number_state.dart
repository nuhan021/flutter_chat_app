abstract class ChangeNumberState {}

class InitialState extends ChangeNumberState {}

class LoadingState extends ChangeNumberState {}

class NumberValideState extends ChangeNumberState {}

class NumberInvalideState extends ChangeNumberState {
  final String msg;
  NumberInvalideState({required this.msg});
}

class PasswordValideState extends ChangeNumberState {}

class PasswordInvalideState extends ChangeNumberState {
  final String msg;
  PasswordInvalideState({required this.msg});
}