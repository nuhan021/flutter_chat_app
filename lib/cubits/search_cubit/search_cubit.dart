import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_chat_app/cubits/search_cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SearchCubit() : super(SearchInitialState());


  Stream<List<QueryDocumentSnapshot>> searchData() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  void searchUser({ required List<QueryDocumentSnapshot> allUsers, required String searchTerm}) {
    List filteredUsers = allUsers.where((user) =>
        user['phone'].contains(searchTerm)).toList();
    if(filteredUsers.isEmpty || searchTerm == '') {
      emit(SearchUserNotFindState());
    }
    else {
      emit(SearchUserFindState(findUser: filteredUsers));
    }
  }
}