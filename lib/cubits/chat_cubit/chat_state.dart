abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatSendMessageState extends ChatState {}

class ChatGetMessagesState extends ChatState {
  final List messages;

  ChatGetMessagesState({required this.messages});
}


class ChatLoadingState extends ChatState {}
