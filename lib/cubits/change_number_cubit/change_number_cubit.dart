import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/change_number_cubit/change_number_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeNumberCubit extends Cubit<ChangeNumberState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ChangeNumberCubit() : super(InitialState());

  //check the number is valid or not
  void checkNumber({required String number}) {
    if(number.length < 11) {
      emit(NumberInvalideState(msg: 'Please provide a valide number'));
    } else {
      emit(NumberValideState());
    }
  }

  //update the number if password is correct
  void updateNumber({required String number, required String password}) async {
    emit(LoadingState());
    final email = _auth.currentUser!.email.toString();
    final uId = _auth.currentUser!.uid.toString();
    try{
     UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
     if(credential.user != null) {
       _firestore.collection('users').doc(uId).update({
         'phone': number.toString()
       }).then((value) {
         emit(PasswordValideState());
       });
     }
    } on FirebaseAuthException catch (err) {
      emit(PasswordInvalideState(msg: err.code.toString()));
    }
  }
}