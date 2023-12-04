import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Helper/Loader.dart';
import '../../Helper/approute.dart';
import '../../Helper/assets.dart';
import '../../Helper/colors.dart';
import '../../Helper/fonts.dart';
import '../../Helper/size.dart';
import '../Home/homescreen.dart';
import 'AcountListController.dart';
import 'AjmanEnquiryScreen.dart';

class EnquiryScreen extends StatefulWidget {
  const EnquiryScreen({Key? key}) : super(key: key);

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  late AcountListController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(AcountListController());
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AcountListController>(builder: (logic) {
      if (logic.isLoading == true) {
        return Center(
          child: MyLoader(),
        );
      }
      return SafeArea(
        child: Scaffold(
          appBar:AppBar(
            backgroundColor: MyColors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              height: height(context) / 8,
              decoration: const BoxDecoration(
                  color: MyColors.primaryCustom,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0))),
            ),
            // leading: IconButton(
            //   onPressed: () {
            //     Get.offAllNamed(AppRoute.homeScreen);
            //   },
            //   icon: const Icon(
            //     Icons.arrow_back_ios,
            //     size: 15,
            //   ),
            // ),
            title: Container(
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
                    'ENQUIRES',
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
                        borderRadius: BorderRadius.circular(60.0),
                        child: Image.asset(Assets.profile))),
              )
            ],
          ),

          body:SingleChildScrollView(
            padding: EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                enquiryList()
              ],
            ),
          )
        ),
      );
    });
  }

  ListView enquiryList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.accoutListModel.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Get.to(() => EnquiryDetailScreen(),arguments: controller.accoutListModel[index]);
                  },
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text(
                      "${controller.accoutListModel[index].accNo}",
                      style: TextStyle(
                        fontFamily: MyFont.myFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: MyColors.primaryCustom,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text(
                      "Savings Account",
                      style: TextStyle(
                        fontFamily: MyFont.myFont,
                        fontSize: 18,
                        color: MyColors.primaryCustom,
                      ),
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ],
            ),
          );
          });
  }

}