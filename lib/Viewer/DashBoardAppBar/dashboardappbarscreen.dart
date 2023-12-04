import 'package:ajmanbank/Helper/colors.dart';
import 'package:ajmanbank/Helper/fonts.dart';
import 'package:ajmanbank/Helper/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Helper/assets.dart';
import 'dashboardappbarcontroller.dart';

class DashBoardAppBarScreen extends StatefulWidget {
  const DashBoardAppBarScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardAppBarScreen> createState() => _DashBoardAppBarScreenState();
}

class _DashBoardAppBarScreenState extends State<DashBoardAppBarScreen> {
  late DashBoardAppbarController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(DashBoardAppbarController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controller.isRemoveClick.value
          ? AppBar(
              backgroundColor: Colors.white24,
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    color: MyColors.primaryCustom,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))),
              ),
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              title: Text(
                'DASHBOARD',
                style: TextStyle(fontFamily: MyFont.myFont, fontSize: 18),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.home),
                ),
              ],
            )
          : AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              title: Text(
                'DASHBOARD',
                style: TextStyle(fontFamily: MyFont.myFont, fontSize: 18),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.home),
                ),
              ],
            ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage(Assets.innerBackground),
              fit: BoxFit.fill,
            )),
          ),
          controller.isRemoveClick.value
              ? Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: deviceList(),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      height: height(context) / 1.5,
                      decoration: const BoxDecoration(
                          color: MyColors.primaryCustom,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0))),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60.0),
                                child: Image.asset(
                                  Assets.profile,
                                  scale: 4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'User ID : AB123456789',
                              style: TextStyle(
                                fontFamily: MyFont.myFont,
                                color: MyColors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Prayathnaa Ramalingam',
                              style: TextStyle(
                                fontFamily: MyFont.myFont,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: MyColors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Prayathnaa.ramalingam@gmail.com',
                              style: TextStyle(
                                fontFamily: MyFont.myFont,
                                fontSize: 13,
                                color: MyColors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'MobNO: 9004974891',
                              style: TextStyle(
                                fontFamily: MyFont.myFont,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: MyColors.white,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Settings',
                                style: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontSize: 15,
                                  color: MyColors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(
                              color: MyColors.white,
                              thickness: 1,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.refresh_sharp,
                                    color: MyColors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      'Change mPin',
                                      style: TextStyle(
                                        fontFamily: MyFont.myFont,
                                        fontSize: 15,
                                        color: MyColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    color: MyColors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        controller.isRemoveClick.value =
                                            !controller.isRemoveClick.value;
                                      });
                                    },
                                    child: Text(
                                      'Remove Trusted Device',
                                      style: TextStyle(
                                        fontFamily: MyFont.myFont,
                                        fontSize: 15,
                                        color: MyColors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 60, 0, 20),
                              child: Text(
                                'Last login : 09/05/2023 14:55:33',
                                style: TextStyle(
                                  fontFamily: MyFont.myFont,
                                  fontSize: 12,
                                  color: MyColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }

  ListView deviceList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mayur\'s Android Device',
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: MyColors.darkGray,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Date of Registration : May 20,2022',
                          style: TextStyle(
                            fontFamily: MyFont.myFont,
                            fontSize: 12,
                            color: MyColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  color: MyColors.primaryCustom),
                              backgroundColor: MyColors.secondaryMainTheme),
                          onPressed: () {},
                          child: Text(
                            'Remove',
                            style: TextStyle(
                                fontFamily: MyFont.myFont,
                                color: MyColors.primaryCustom),
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              const Divider(
                thickness: 1.0,
                indent: 20,
                endIndent: 20,
              ),
            ],
          );
        });
  }
}
