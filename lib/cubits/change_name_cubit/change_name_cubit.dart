import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/change_name_cubit/change_name_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeNameCubit extends Cubit<ChangeNameState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChangeNameCubit() : super(InitialState());

  // change name
  void changeName({required String fName, required String lName, required String password}) async {
    emit(LoadingState());
    final String email = _auth.currentUser!.email.toString();
    final String uId = _auth.currentUser!.uid.toString();

    //try to login with given password . if password is correct then update the name
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(credential.user != null) {
        _firestore.collection('users').doc(uId).update({
          'firstName': fName,
          'lastName': lName,
        }).then((value) {
          emit(PasswordValidateState());
        });
      }
    } on FirebaseAuthException catch(err) {
      emit(PasswordInvalideState(msg : err.code.toString()));
    }
  }
}