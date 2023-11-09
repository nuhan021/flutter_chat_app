abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeFetchAllUsersState extends HomeState {
  final List allUsers;
  HomeFetchAllUsersState({required this.allUsers});
}

class HomeFetchErrorState extends HomeState {}


class HomeFatchCurrentUserDataState extends HomeState {
  final List currentUserData;
  HomeFatchCurrentUserDataState({required this.currentUserData});
}