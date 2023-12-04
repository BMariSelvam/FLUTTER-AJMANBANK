import 'package:ajmanbank/Helper/approute.dart';
import 'package:ajmanbank/Helper/colors.dart';
import 'package:ajmanbank/Helper/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Helper/assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: MyColors.white,
            elevation: 0,
            automaticallyImplyLeading: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  color: MyColors.primaryCustom,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25.0),
                      bottomRight: Radius.circular(25.0))),
            ),
            title: Container(
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'HOME PAGE',
                    style: TextStyle(
                      fontFamily: MyFont.myFont,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
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
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.innerBackground),
                        fit: BoxFit.fill)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(AppRoute.dashboardScreen);
                        },
                        leading: Image.asset(Assets.home1),
                        title: Text(
                          'DASHBOARD',
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            color: MyColors.primaryCustom,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: MyColors.primaryCustom,
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(AppRoute.dateLineScreen);
                        },
                        leading: Image.asset(Assets.home2),
                        title: Text(
                          'DATE LINE',
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            color: MyColors.primaryCustom,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: MyColors.primaryCustom,
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(AppRoute.AccountListScreen);
                        },
                        leading: Image.asset(Assets.home3),
                        title: Text(
                          'ENQUIRES',
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            color: MyColors.primaryCustom,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: MyColors.primaryCustom,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
