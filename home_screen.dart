import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sinav_social/utils/IO.dart';
import 'package:sinav_social/utils/firebase_push_notification.dart';
import 'package:sinav_social/utils/flutx_spacing.dart';
import 'package:sinav_social/utils/flutx_theme/custom_theme.dart';
import 'package:sinav_social/utils/flutx_theme/flutx_app_theme.dart';
import 'package:sinav_social/utils/pref.dart';
import 'package:sinav_social/widgets/custom_dialog.dart';
import 'package:sinav_social/widgets/exam_date_widget.dart';
import 'package:sinav_social/widgets/flutx_container.dart';
import '../games/dashboard/dashboard_view.dart';
import '../services/blacklist_service.dart';
import '../utils/providers/question_provider.dart';
import 'calculate_points/calculate_points_screen.dart';
import 'flashcards/flashcards_home.dart';
import 'index.dart';
import 'osym_question/question_tab.dart';
import 'profile/profile_screen.dart';
import 'user_information_screen.dart';
import 'package:sinav_social/widgets/custom_card_decoration.dart';
import 'package:sinav_social/widgets/custom_card_content.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  final bool isFromRegister;
  const HomeScreen({Key key, this.isFromRegister = false}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final GlobalKey container_key = GlobalKey();
  final GlobalKey indicator_container_key = GlobalKey();
  Size  container_card_size,indicator_container_size;
  var container_card_height, indicator_container_height;

  int selectedCategory = 0;
  ThemeData theme;
  CustomTheme customTheme;

  List<String> images_path = ['assets/card_images/card_1_image.jpg','assets/card_images/card_2_image.jpg','assets/card_images/card_3_image.jpg','assets/card_images/card_4_image.jpg'];
  List<String> card_topics = ["Soru & Sohbet","Bilgi Kartları","Konu Takibi","Haftalık Plan"];
  List<String> button_topics = ["Yapılacaklar","Çıkmış Sorular","Puan Hesapla"];

  List<List<String>> strings_array = [
    ['assets/card_images/card_1_image.jpg','assets/card_images/card_2_image.jpg','assets/card_images/card_3_image.jpg','assets/card_images/card_4_image.jpg'],
    ["Soru & Sohbet","Bilgi Kartları","Konu Takibi","Haftalık Plan"],
    ["Yapılacaklar","Çıkmış Sorular","Puan Hesapla"]
  ];

  @override
  void initState() {
    super.initState();
    IO.initialize();
    theme = AppTheme.theme;
    customTheme = AppTheme.customTheme;
    FirebasePushNotification.setNotificationToken();
    UserServices.setCurrentDeviceId();
    Future.delayed(Duration.zero, () {
      BlackListService.checkIfUserIsBlackListed(context);
    });
    if (widget.isFromRegister) {
      Future.delayed(Duration.zero, () {
        Nav.offAllWithoutContext(
            const UserInformationScreen(isOpenedAlready: false));
      });
    } else {
      var userBranch = Prefs.getString("userBranch");
      if (userBranch == null || userBranch == "") {
        Future.delayed(Duration.zero, () {
          Nav.offAllWithoutContext(
              const UserInformationScreen(isOpenedAlready: false));
        });
      }
    }
    Future.delayed(Duration.zero, () {
      getQuestions();
    });

    //Reyhan Akta
    // This method will be call when the UI has been occured on user screen
    WidgetsBinding.instance.addPostFrameCallback((_) => { getSizesofCardContainer()  });
  }


  void getSizesofCardContainer(){
    RenderBox _container_card_box =  container_key.currentContext.findRenderObject();
    RenderBox _indc_container_box =  indicator_container_key.currentContext.findRenderObject();

     container_card_size   = _container_card_box.size;
     container_card_height = container_card_size.height;

     indicator_container_size   = _indc_container_box.size;
     indicator_container_height = indicator_container_size.height;

     print("the sizes of indicator ${indicator_container_height}" );
  }

  void getQuestions() {
    QuestionProvider questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    questionProvider.setCurrentLessonName("all");
    questionProvider.getQuestions(10);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        bool isExit = await CustomDialog.areYouSureGetDefaultDialog(
            "Çıkmak istediğinize emin misiniz?", context,
            buttonText1: "Hayır", buttonText2: "Evet");
        return isExit;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        key: _drawerKey,
        drawer: const HomeScreenDrawer(),
        body:Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.25,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.50,
                child: GridView.count(
                  padding: const EdgeInsets.all(10.0),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    // Customization card section //
                      for(int i=0;i<4;i++)
                        Container(
                          key:i==0?container_key:null,
                          decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(15.0),
                              color: Colors.white,
                              boxShadow:[
                                BoxShadow(
                                  color:Colors.grey.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                )
                              ]
                          ),
                          child:Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10), // Image border
                                  child:Image(
                                    width: double.infinity,
                                    height:165/2,
                                    image: AssetImage("${strings_array[0][i]}"),
                                    fit: BoxFit.fill,
                                  ),

                                ),
                                SizedBox(height: 10,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("${strings_array[1][i]}",style: TextStyle(fontSize: 15,fontFamily: 'Jura',fontWeight: FontWeight.bold),) ,
                                )

                              ],
                            ),
                          ),

                        ),

                    // Customization card section //

                  ],),


              ),

              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.25,
                  child: Column(
                    children: <Widget>[

                      Flexible(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                               for(int i=0;i<3;i++)
                                Flexible(
                                  flex: 1,
                                  child:Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow:[
                                                BoxShadow(
                                                  color:Colors.grey.withOpacity(0.4),
                                                  spreadRadius: 1,
                                                  blurRadius: 15,
                                                  offset: Offset(0, 3),
                                                )
                                              ]
                                          ),

                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 12),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.0)
                                              ),
                                                primary: colorFromHex("#20c0b4")
                                            ),
                                            onPressed: () {},
                                            child: Text("${strings_array[2][i]}"),
                                          ),
                                        ),
                                      ),

                                  ),
                                ),









                              ],
                            ),

                          )),
                    for(int i=0;i<2;i++)
                      Flexible(
                          flex: 1,
                          child:Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0,vertical:5.0),
                            child:Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius:BorderRadius.circular(15.0),
                                  color: Colors.white,
                                  boxShadow:[
                                    BoxShadow(
                                      color:Colors.grey.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    )
                                  ]
                              ),
                            ) ,
                          )),


                    ],
                  )
              ),

            ],
          ),
        )

      ),
    );
  }

  Widget customContainer(
      Widget widget, IconData icon, Color color, String text) {
    return Card(
      elevation: 0.5,
      margin: FxSpacing.fromLTRB(0, 0, 0, 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: FxContainer(
        onTap: () {
          if (text == "Soru/Sohbet Odaları") {
            getQuestions();
          }
          Get.to(() => widget);
        },
        // margin: FxSpacing.fromLTRB(0, 0, 0, 12),
        paddingAll: 12,
        // borderRadiusAll: 8,
        child: Row(
          children: [
            FxContainer(
              paddingAll: 10,
              borderRadiusAll: 4,
              color: color.withAlpha(20),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            FxSpacing.width(16),
            SizedBox(
              width: getWidth(1.9),
              child: customAutoSizeText(
                text,
                color: theme.colorScheme.onBackground,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            FxContainer(
              paddingAll: 10,
              borderRadiusAll: 4,
              color: color.withAlpha(20),
              child: Icon(
                FeatherIcons.arrowRight,
                color: color,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class customCardContent {
}
