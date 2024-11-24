import 'package:textpop/Models/UserInfoModel.dart';

class ConversationModel {
  int Id;
  UserInfoModel OtherUser;
  String LatestMessage;
  bool Italic;
  int UnseenMessageCount;

  ConversationModel(this.Id, this.OtherUser, this.LatestMessage, this.Italic, this.UnseenMessageCount);
}