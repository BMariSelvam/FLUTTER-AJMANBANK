import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Helper/Loader.dart';
import '../../Helper/PreferenceHelper.dart';
import '../../Helper/approute.dart';
import '../../Helper/assets.dart';
import '../../Helper/colors.dart';
import '../../Helper/fonts.dart';
import '../../Helper/size.dart';
import '../../Model/ResponseModel/AccountListModel.dart';
import 'AjamnEnquiryController.dart';

class EnquiryDetailScreen extends StatefulWidget {
  const EnquiryDetailScreen({Key? key}) : super(key: key);

  @override
  State<EnquiryDetailScreen> createState() => _EnquiryDetailScreenState();
}

class _EnquiryDetailScreenState extends State<EnquiryDetailScreen> {
  late StateMentListController controller;
  AccountListModel? accountListModel;
  String? vLoginId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(StateMentListController());
    accountListModel = Get.arguments as AccountListModel;
    initalValue();
  }

  initalValue() async {
    await PreferenceHelper.getUserData().then((value) => setState(() {
      vLoginId = value?.userInfoVO?.vLoginId;
    }));
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<StateMentListController>(builder: (logic)
    {
      if (logic.isLoading == true) {
        return Center(
          child: MyLoader(),
        );
      }
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
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
            //     Navigator.pop(context);
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
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                    ),
                  ),
                  Text(
                    'Account Statement',
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
          body: SingleChildScrollView(
            padding: EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enquires",
                  style: TextStyle(
                    fontFamily: MyFont.myFont,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width(context)/1.8,
                              // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                              child: Text(
                                "Title : ${vLoginId}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Active",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.green,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "AED ${controller.startBalence}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Savings Account",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Flexible(
                        //       child: Text(
                        //         "${accountListModel?.accNo}",
                        //         overflow: TextOverflow.ellipsis,
                        //         style: TextStyle(
                        //           fontFamily: MyFont.myFont,
                        //           fontWeight: FontWeight.bold,
                        //           color: MyColors.primaryCustom,
                        //           fontSize: 20,
                        //         ),
                        //       ),
                        //     ),
                        //     IconButton(
                        //         onPressed: () {},
                        //         icon: Icon(
                        //           Icons.arrow_forward_ios,
                        //           size: 20,
                        //         )),
                        //   ],
                        // ),
                        SizedBox(height: 10),
                        Divider(color: MyColors.gray),
                        SizedBox(height: 10),
                        Text(
                          "IBAN : ${accountListModel?.iban}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Transaction History",
                  style: TextStyle(
                    fontFamily: MyFont.myFont,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  child: transactionHistoryList(),
                )
              ],
            ),
          )
        ),
      );
    });
  }

  transactionHistoryList() {
    return (controller.transaction.length != 0)
        ? ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.transaction.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5,5, 5, 5),
              child: Row(
                children: [
                  SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.asset(Assets.profile))),
                  SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${controller.transaction[index].transDesc}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Text(
                              "+ AED ${controller.transaction[index].transAmount}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: MyFont.myFont,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${controller.transaction[index].valueDate}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
          })
    : Padding(
      padding: const EdgeInsets.symmetric(vertical: 150),
      child: Center(child: Text("No Record Found")),
    );
   }

}