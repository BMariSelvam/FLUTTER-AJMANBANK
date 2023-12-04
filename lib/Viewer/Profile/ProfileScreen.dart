import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Helper/PreferenceHelper.dart';
import '../../Helper/approute.dart';
import '../../Helper/assets.dart';
import '../../Helper/colors.dart';
import '../../Helper/fonts.dart';
import '../../Helper/size.dart';
import '../../Model/AuthuModel.dart';
import '../../Model/RemoveDeviceModel.dart';
import '../../Model/ResponseModel/RegistrationFirstScreenRegModel.dart';
import '../Registration/MPinSetting/changempinscreen.dart';
import 'PrfileController.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController controller;
  AuthuModel? authuModel;
  UserModel? registrationFirstScreenRegModel;

  String? access_token;
  String? vGcifNo;
  String? vLoginId;
  String? vMobile;
  String? vEmail;
  int? vUserId;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
    getCheckData();
  }

  getCheckData() async {
    authuModel = await PreferenceHelper.getToken();
    access_token = authuModel?.accessToken;
    await PreferenceHelper.getUserData().then((value) => setState(() {
          vUserId = value?.userInfoVO?.vUserId;
          vLoginId = value?.userInfoVO?.vLoginId;
          vGcifNo = value?.userInfoVO?.vCorporateId;
          vMobile = value?.userInfoVO?.vmobile;
          vEmail = value?.userInfoVO?.vEmailId;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (logic) {
      if (logic.isLoading == true) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryCustom,
          elevation: 0,
          title: Text(
            'Profile',
            style: TextStyle(
              fontFamily: MyFont.myFont,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Stack(
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
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
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
                      'User ID : ${vUserId}',
                      style: TextStyle(
                        fontFamily: MyFont.myFont,
                        color: MyColors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${vLoginId}',
                      style: TextStyle(
                        fontFamily: MyFont.myFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: MyColors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${vEmail}',
                      style: TextStyle(
                        fontFamily: MyFont.myFont,
                        fontSize: 13,
                        color: MyColors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mobile Number: ${vMobile}',
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
                    Obx(() {
                      return Align(
                          alignment: Alignment.topLeft,
                          child: (controller.mPinCheck.value == false)
                              ? GestureDetector(
                            onTap: () {
                              setState(() {
                                controller.isClick.value = true;
                              });
                              Get.toNamed(AppRoute.mPinSettingScreen,
                                  arguments: false);
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.refresh_sharp,
                                  color: MyColors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      controller.isClick.value = true;
                                    });
                                    Get.toNamed(AppRoute.mPinSettingScreen,
                                        arguments: false);
                                  },
                                  child: Text(
                                    'Set MPIN',
                                    style: TextStyle(
                                      fontFamily: MyFont.myFont,
                                      fontSize: 15,
                                      color: MyColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              setState(() {
                                controller.isClick.value = true;
                              });
                              Get.to(() => ChangeMPINScreen());
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.refresh_sharp,
                                  color: MyColors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      controller.isClick.value = true;
                                    });
                                    Get.to(() => ChangeMPINScreen());
                                  },
                                  child: Text(
                                    'Change MPIN',
                                    style: TextStyle(
                                      fontFamily: MyFont.myFont,
                                      fontSize: 15,
                                      color: MyColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    }),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          controller.getDivecList();
                          _openBottomSheet(context);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete,
                              color: MyColors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                controller.getDivecList();
                                _openBottomSheet(context);
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
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.isClick.value = true;
                          });
                          logoutFunc();
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.logout,
                              color: MyColors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  controller.isClick.value = true;
                                });
                                logoutFunc();
                              },
                              child: Text(
                                'Logout',
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
                    ),
                    (controller.lastLoginTime != null)
                    ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                      child: Text(
                        'Last login : ${controller.lastLoginTime}',
                        style: TextStyle(
                          fontFamily: MyFont.myFont,
                          fontSize: 12,
                          color: MyColors.white,
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 45,
              width: width(context),
              // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Trusted Devices:',
                  style: TextStyle(
                    fontFamily: MyFont.myFont,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyColors.mainTheme,
                  ),
                ),
              ),
            ),
            Expanded(child: deviceList()),
          ],
        );
      },
    );
  }

  GetBuilder<ProfileController> deviceList() {
    return GetBuilder<ProfileController>(builder: (logic) {
      return ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: false,
          itemCount: controller.getdeviceList.length,
          itemBuilder: (context, index) {
            String inputDate = "${controller.getdeviceList[index].registerDate}";
            DateTime date = DateTime.parse(inputDate);
            String formattedDate = DateFormat('MMMM d, yyyy').format(date);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${controller.getdeviceList[index].vDeviceModelName}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: MyFont.myFont,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: MyColors.darkGray,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Date of Registration : ${formattedDate}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: MyFont.myFont,
                                fontSize: 12,
                                color: MyColors.darkGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      (controller.deviceId !=
                              controller.getdeviceList[index].deviceId)
                          ? SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      side: const BorderSide(
                                          color: MyColors.primaryCustom),
                                      backgroundColor:
                                          MyColors.secondaryMainTheme),
                                  onPressed: () {
                                    showPopup(controller
                                        .getdeviceList[index].deviceId);
                                  },
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(
                                        fontFamily: MyFont.myFont,
                                        color: MyColors.primaryCustom),
                                  )),
                            )
                          : Container(),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            );
          });
    });
  }

  showPopup(String? vDeviceId) {
    return showDialog(
        context: Get.context!,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text(
              'Do you want to remove this device',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: MyFont.myFont,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: MyColors.darkGray,
              ),
            ),
            content: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      controller.removeDeviceModel = RemoveDeviceModel(
                          requestFlag: "N",
                          vDeviceId: vDeviceId,
                          vCorporateId: vGcifNo,
                          vSecureToken: access_token,
                          msgSourceChannelID: "120",
                          vLoginID: vLoginId,
                          vMobileNo: vMobile);
                      controller.RemoveDevice();
                    },
                    child: Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(Get.context!);
                    },
                    child: Text('No'))
              ],
            ),
          );
        });
  }

  logoutFunc() {
    return showDialog(
        context: Get.context!,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text(
              'Are you sure want to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: MyFont.myFont,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: MyColors.darkGray,
              ),
            ),
            content: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      controller.logoutfun();
                    },
                    child: Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(Get.context!);
                    },
                    child: Text('No'))
              ],
            ),
          );
        });
  }
}
