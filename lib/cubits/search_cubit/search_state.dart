abstract class SearchState {}

class SearchInitialState extends SearchState {}

class SearchUserFindState extends SearchState {
  final List findUser;
  SearchUserFindState({required this.findUser});
}

class SearchUserNotFindState extends SearchState {}