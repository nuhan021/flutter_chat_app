abstract class AuthState {}

// TODO __ initial state
class AuthInitialState extends AuthState {}

class AuthSignUpNamesState extends AuthState {
  final String msg;
  AuthSignUpNamesState({required this.msg});
}

class AuthSignUpNamesValidateState extends AuthState {}


class AuthSignUpPhoneState extends AuthState {
  final String msg;
  AuthSignUpPhoneState({required this.msg});
}

class AuthSignUpPhoneValidateState extends AuthState {}

// TODO __ email validation states
class AuthSignUpEmailTextChange extends AuthState {
  final String msg;
  AuthSignUpEmailTextChange({required this.msg});
}

class AuthSignUpEmailValidate extends AuthState {}
// TODO __ END email validation states

// TODO __ password validation states
class AuthPasswordValidateState extends AuthState {}

class AuthPasswordErrorState extends AuthState {
  final String msg;
  AuthPasswordErrorState({required this.msg});
}
// TODO __ END password validation states

// TODO __ confirm passworld validation states
class AuthConfirmPasswordValidateState extends AuthState {}

class AuthConfirmPasswordErrorState extends AuthState {
  final String msg;
  AuthConfirmPasswordErrorState({required this.msg});
}
// TODO __ END confirm password validation states


// TODO __ sign up create user state
class AuthSignUpState extends AuthState {}

class AuthSignUpErrorState extends AuthState {
  final String msg;
  AuthSignUpErrorState({required this.msg});
}
// TODO __ sign up create user state


// TODO __ loading states
class AuthLoadingState extends AuthState {}


// TODO __ sign in user state
class AuthSignInState extends AuthState {}
class AuthSignInErrorState extends AuthState {
  final String msg;
  AuthSignInErrorState({required this.msg});
}
// TODO __ sign in user state

// TODO __ sign out user state
class AuthSignOutState extends AuthState {}
