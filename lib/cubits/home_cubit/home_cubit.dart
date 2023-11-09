import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/home_cubit/home_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  HomeCubit() : super(HomeInitialState());


  Stream<List<QueryDocumentSnapshot>> fatchAllUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  void fatchCurrentUserData() async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid.toString())
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> userDataMap = snapshot.data() as Map<String, dynamic>;
        emit(HomeFatchCurrentUserDataState(currentUserData: [userDataMap]));
      } else {
        // Handle the case where the snapshot doesn't exist (user data not found)
        emit(HomeFetchErrorState());
      }
    } catch (e) {
      // Handle any other exceptions here
      emit(HomeFetchErrorState());
    }
  }


  Stream<DocumentSnapshot<Map<String, dynamic>>> chatList ({required String currentUserId}) {
    return _firestore.collection('users').doc(currentUserId).snapshots();
  }

}
