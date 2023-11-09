import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'change_email_state.dart';

class ChangeEmailCubit extends Cubit<ChangeEmailState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;
  Timer? emailVerificationTimer;
  ChangeEmailCubit(): super(ChangeEmailInitialState());

  //todo chek new email are validate
  void validateEmail({required String email}) {
    if(EmailValidator.validate(email) == true) {
      emit(EmailValidateState());
    } else {
      emit(EmailErrorState(msg: 'Provide a valid email'));
    }
  }
  //todo check user password is correct or not__if correct then update the email with new email
  void checkPassword({required String password, required String newEmail}) async {
    emit(LoadingState());
    String email = _auth.currentUser!.email.toString();
    String userId = _auth.currentUser!.uid.toString();

    print('email: $email \nuserId: $userId');

    try{
     UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
     if(credential.user != null) {
       await _auth.currentUser?.sendEmailVerification();
       
       emailVerificationTimer =  Timer.periodic(
         Duration(seconds: 1),
           (val) async {

           bool isEmailVarified = _auth.currentUser!.emailVerified;

           if(isEmailVarified) {
             await _auth.currentUser?.updateEmail(newEmail);
             await _firestore.collection('users').doc(userId).update({
               "email": newEmail
             });
             emit(PasswordValidateState());
             emailVerificationTimer?.cancel();
           }
           }
       );
       

     }
    } on FirebaseAuthException catch(err) {
      emit(PasswordErrorState(msg: err.code.toString()));
    }
  }
}
