import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/change_password_cubit/change_password_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ChangePasswordCubit() : super(ChangePasswordInitialState());

  //todo -- change password if old password is correct
  void changePassword({
    required String oldPassword,
    required String newPassword
  }) async {
    emit(ChangePasswordLoadingState());
    //todo -- check old password is correct or not?
    final String currentUserEmail = _auth.currentUser!.email.toString();

    // todo -- try to login using old password
   try{
     UserCredential credential = await _auth.signInWithEmailAndPassword(
         email: currentUserEmail, password: oldPassword);

     if(credential.user != null) {
       await _auth.currentUser!.updatePassword(newPassword);
       print('Password update successfully');
       _auth.signOut();
       emit(ChangeOldPasswordValidateState());
     }
   } on FirebaseAuthException catch (err) {
     emit(ChangeOldPasswordErrorState(msg: err.code.toString()));
   }

  }

  //todo -- check new password
  void checkNewPasswordValidation({required String newPassword}) {
    if (newPassword.length < 8) {
      emit(
          ChangePasswordNewPasswordErrorState(msg: 'password must be 8 digit'));
    } else {
      emit(ChangePasswordNewPasswordValidateState());
    }
  }
}
