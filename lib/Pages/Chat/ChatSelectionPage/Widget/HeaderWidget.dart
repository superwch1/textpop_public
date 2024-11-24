import 'package:flutter/material.dart';
import 'package:textpop/Localisation/Mode/Mode.dart';
import 'package:textpop/Models/UserInfoModel.dart';
import 'package:textpop/Services/WebServer/ConnectionOption.dart';

class HeaderWidget extends StatelessWidget{

  //Reason not using ChatSelectionViewModel is because of having ChatSelectionTempUi
  final UserInfoModel MyUser;
  final Mode SelectedMode;
  final void Function(BuildContext context) EditUserInfo;
  final void Function(BuildContext context) OpenSetting;

  const HeaderWidget(this.MyUser, this.SelectedMode, this.EditUserInfo, this.OpenSetting);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return ListView( 
      physics: const NeverScrollableScrollPhysics(),  
      children: [
        SizedBox(
          height: height * 0.02,
        ),

        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => EditUserInfo(context),
                child: Container(
                  width: width * 0.7,
                  decoration:BoxDecoration(
                    color: SelectedMode.BannerBackground(),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(30))
                  ),
                  height: height * 0.09,
                  child: Row(
                    children: [ 

                      SizedBox(
                        width: width * 0.05,
                      ),

                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipPath(
                          clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(height * 0.4),
                            ),
                          ),

                          child: Image.network(
                            ConnectionOption().AvatarUrl(MyUser.Id), 
                            height: height * 0.06 
                          )
                        ),
                      ),

                      SizedBox(
                        width: width * 0.04,
                      ),

                      Align(
                        alignment: const Alignment(-1, 0),
                        child: Text(MyUser.Username,
                          style: TextStyle(
                          color: SelectedMode.TextColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                          ),
                        )
                      ),
                    ] 
                  )
                ),
              ),

              Container(
                margin: EdgeInsets.only(right: width * 0.05),
                child: RawMaterialButton(
                  constraints: BoxConstraints(
                    minHeight: height * 0.07,
                    minWidth: height * 0.07,  
                  ),
                  shape: const CircleBorder(),
                  fillColor: SelectedMode.MiscAButtonBackground(),
                  onPressed: () => OpenSetting(context),
                  
                  child: SizedBox(
                    height: height * 0.04,
                    width: height * 0.04,
                    child: Image.asset(SelectedMode.SettingPath()),
                  ),
                ),
              )
            ],
          )
        )
      ],
    );
  }
}