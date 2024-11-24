import 'package:flutter/material.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Pages/Chat/ChatUserPage/Widget/SearchBarWidget.dart';
import 'package:textpop/Pages/Chat/ChatUserPage/Widget/UserInfoWidget.dart';
import 'package:textpop/ViewModels/Chat/ChatUserViewModel.dart';
import 'package:provider/provider.dart';

class ChatUserUI extends StatelessWidget {

  final ChatUserViewModel ViewModel;

  const ChatUserUI(this.ViewModel);

  @override
  Widget build(BuildContext context) {
    
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ViewModel.AppData.SelectedMode.AppBackground(),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          children: [
            SizedBox(height: height * 0.05),

            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  RawMaterialButton(
                    constraints: const BoxConstraints(), //set the min width and height to 0
                    onPressed: () => Navigator.pop(context),
                    highlightColor: Colors.transparent,
                    child: Image.asset(
                      ViewModel.AppData.SelectedMode.ArrowBackPath(),
                      height: 25,
                    )
                  ),
                  Text(
                    ViewModel.AppData.SelectedLanguage.ChatUserPage_AddConversationBanner(),
                    style: TextStyle(color: ViewModel.AppData.SelectedMode.TextColor(), fontSize: 26, fontWeight: FontWeight.bold)
                  ),
                ],
              )
            ),

            SizedBox(height: height * 0.025),

            SearchBarWidget(ViewModel),

            SizedBox(height: height * 0.02),

            Expanded(
              child: Container(
                height: height * 0.7,
                decoration: BoxDecoration(
                  color: ViewModel.AppData.SelectedMode.ChatBackground(),
                  borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                
                child: ChangeNotifierProvider(
                  create: (context) => ViewModel,
                  builder: (context, child) {
                    return Consumer<ChatUserViewModel>(
                      builder:(context, value, child) {

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: ViewModel.UsersFromSearchResult.length,
                          itemBuilder:(context, index) {
                            return UserInfoWidget(
                              ViewModel.AppData.SelectedMode,
                              UserInfoModel(
                                ViewModel.UsersFromSearchResult[index].Id,
                                ViewModel.UsersFromSearchResult[index].Username,
                              ),
                              ViewModel.EnterConversation
                            );
                          },
                        );
                        
                      },
                    );
                  },
                ),
              )
            )
          ],
        ),
      )
    );
  }
}