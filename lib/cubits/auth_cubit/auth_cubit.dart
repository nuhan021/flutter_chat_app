import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/auth_cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthCubit extends Cubit<AuthState> {
  // TODO __ firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // TODO __ firebase firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // TODO __ initial state
  AuthCubit() : super(AuthInitialState()) {
    // TODO __ check user logged in or not ?
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      emit(AuthSignInState());
    } else {
      emit(AuthSignOutState());
    }
  }

  //todo __ check first and last name are empty?
  void authSignUpNames({required String firstName, required String lastName}) {
    if (firstName == '' || lastName == '') {
      emit(AuthSignUpNamesState(msg: 'required'));
    } else {
      emit(AuthSignUpNamesValidateState());
    }
  }

  // todo __ check phone number is not empty?
  void authSignUpPhone({required String phone}) {
    if (phone.length < 10) {
      emit(AuthSignUpPhoneState(msg: 'provide a valide number'));
    } else {
      emit(AuthSignUpPhoneValidateState());
    }
  }

  // TODO __ check email are right or wrong
  void authSignUpEmailTextChange({required String email}) {
    if (EmailValidator.validate(email) == false) {
      emit(AuthSignUpEmailTextChange(msg: 'Please provide a valide email'));
    } else {
      emit(AuthSignUpEmailValidate());
    }
  }

  // TODO __check password is at list 8 characters or more
  void authSignupPasswordChange({required String password}) {
    if (password.length < 8) {
      emit(
          AuthPasswordErrorState(msg: 'Password must be 8 characters or more'));
    } else {
      emit(AuthPasswordValidateState());
    }
  }

  //TODO __ check password and confirm password are same or not?
  void authSignupConfirmPasswordChange(
      {required String confirmPassword, required String password}) {
    if (password != confirmPassword) {
      emit(AuthConfirmPasswordErrorState(msg: "Password don't match"));
    } else {
      emit(AuthConfirmPasswordValidateState());
    }
  }

  //TODO __ create a new account for user
  void signUp(
      {required String email,
      required String password,
      required String firstName,
      required String lastName, required String phone}) async {
    emit(AuthLoadingState());
    try {
      UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await _firestore.collection('users').doc(value.user!.uid).set({
          "uId": value.user!.uid,
          "email": email,
          "firstName": firstName,
          "lastName": lastName,
          "phone" : phone,
          "chatList" : [],
          "profileUrl": "",
        });
        return value;
      });
      if (credential.user != null) {
        emit(AuthSignUpState());
      }
    } on FirebaseAuthException catch (ex) {
      emit(AuthSignUpErrorState(msg: ex.code.toString()));
    }
  }

  //TODO __ sign in function
  void signIn({required String email, required String password}) async {
    emit(AuthLoadingState());
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        emit(AuthSignInState());
      }
    } on FirebaseAuthException catch (ex) {
      emit(AuthSignInErrorState(msg: ex.code.toString()));
    }
  }

  // TODO __ sign out function
  void signOut() async {
    await _auth.signOut();
    emit(AuthSignOutState());
  }
}
