import 'package:textpop/Localisation/Language/Langauge.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Models/UserInfoModel.dart';

class AppDataModel{
  String AppToken;
  UserInfoModel MyUser;
  Mode SelectedMode;
  Language SelectedLanguage;

  AppDataModel(this.AppToken, this.MyUser, this.SelectedMode, this.SelectedLanguage);
}