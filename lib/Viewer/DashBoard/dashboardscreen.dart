import 'package:ajmanbank/Helper/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Helper/Loader.dart';
import '../../Helper/PreferenceHelper.dart';
import '../../Helper/approute.dart';
import '../../Helper/assets.dart';
import '../../Helper/colors.dart';
import '../../Helper/constants.dart';
import '../../Helper/fonts.dart';
import '../../Model/AuthuModel.dart';
import '../../Model/RemoveDeviceModel.dart';
import '../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import '../Registration/MPinSetting/changempinscreen.dart';
import 'DashBoardTabBarScreen/Approved/approvedsecreen.dart';
import 'DashBoardTabBarScreen/Failed/failedscreen.dart';
import 'DashBoardTabBarScreen/Pending/pendingscreen.dart';
import 'DashBoardTabBarScreen/Processed/processedscreen.dart';
import 'DashBoardTabBarScreen/Rejected/rejectedscreen.dart';
import 'dashboardcontroller.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with TickerProviderStateMixin {
  late DashBoardController controller;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(DashBoardController());
    controller.tabBarController =TabController(length: 5, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(builder: (logic) {
      if (logic.isLoading == true) {
        return Center(
          child: MyLoader(),
        );
      }
      return DefaultTabController(
        length: 5,
        child: SafeArea(
          child: Scaffold(
              appBar:  AppBar(
                toolbarHeight: height(context) / 10,
                backgroundColor: MyColors.white,
                elevation: 4,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  height: height(context) / 12,
                  decoration: const BoxDecoration(
                      color: MyColors.primaryCustom,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0))),
                ),
                // leading: IconButton(
                //   onPressed: () {
                //     // Get.offAllNamed(AppRoute.homeScreen);
                //   },
                //   icon: const Icon(
                //     Icons.arrow_back_ios,
                //     size: 15,
                //   ),
                // ),
                title: Container(
                  // color: Colors.green,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.offAllNamed(AppRoute.homeScreen);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        ),
                      ),
                      Text(
                        'DASHBOARD',
                        style: TextStyle(
                          fontFamily: MyFont.myFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                        onPressed: () {
                          Get.toNamed(AppRoute.profileScreen);
                        },
                        icon: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(Assets.profile))),
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  tabs:[
                    Tab(
                      child: Text(
                        'Approved(${controller.approvedListlength})',
                        style: TextStyle(
                          fontFamily: MyFont.myFont,
                          color: MyColors.darkGray,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Pending(${controller.pendingListlength})',
                        style: TextStyle(
                          fontFamily: MyFont.myFont,
                          color: MyColors.darkGray,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Rejected(${controller.rejectedListlength})',
                        style: TextStyle(
                          fontFamily: MyFont.myFont,
                          color: MyColors.darkGray,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Processed(${controller.processListlength})',
                        style: TextStyle(
                          fontFamily: MyFont.myFont,
                          color: MyColors.darkGray,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Failed(${controller.failedListlength})',
                        style: TextStyle(
                          fontFamily: MyFont.myFont,
                          color: MyColors.darkGray,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                  controller: controller.tabBarController,
                ),
              ),
              body:  TabBarView(
                  controller: controller.tabBarController,
                  children: const <Widget>[
                    // Content for Tab 1
                    ApprovedScreen(),
                    // Content for Tab 2
                    PendingScreen(),
                    // Content for Tab 3
                    RejectedScreen(),
                    // Content for Tab 4
                    ProcessedScreen(),
                    // Content for Tab 5
                    FailedScreen(),
                  ])
          ),
        ),
      );
    });
  }

}
