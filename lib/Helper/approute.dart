import 'package:ajmanbank/Viewer/DashBoardAppBar/dashboardappbarscreen.dart';
import 'package:ajmanbank/Viewer/Registration/registrationtouchsuccessfull.dart';
import 'package:get/get.dart';
import '../Viewer/AjmanEnquiry/AcountListScreen.dart';
import '../Viewer/AjmanEnquiry/AjmanEnquiryScreen.dart';
import '../Viewer/DashBoard/DashBoardTabBarScreen/Approved/approvedsecreen.dart';
import '../Viewer/DashBoard/dashboardscreen.dart';
import '../Viewer/DateLine/dateline.dart';
import '../Viewer/ForgotPassword/ForgotPasswordScreen.dart';
import '../Viewer/Home/homescreen.dart';
import '../Viewer/Login/MpinLogin.dart';
import '../Viewer/Login/loginscreen.dart';
import '../Viewer/Profile/ProfileScreen.dart';
import '../Viewer/Registration/MPinSetting/changempinscreen.dart';
import '../Viewer/Registration/MPinSetting/mpinsettingscreen.dart';
import '../Viewer/Registration/RegistrationFirst/registrationScreen.dart';
import '../Viewer/Registration/RegistrationSecond/mobileOtpVerificationScreen.dart';
import '../Viewer/Registration/RegistrationSecond/secondOtpScreen.dart';
import '../Viewer/Registration/registrationfaceidsuccessfull.dart';
import '../splashscreen.dart';

class AppRoute {
  static const String initialPage = '/splashScreen';
  static const String registrationFirstScreen = '/registrationFirstScreen';
  static const String registrationSecondScreen = '/registrationSecondScreen';
  static const String registrationFaceIDSuccessfully = '/registrationFaceIDSuccessfully';
  static const String registrationTouchSuccessfully = '/registrationTouchSuccessfully';
  static const String login = '/login';
  static const String loginThroughMPIN = '/loginThroughMPIN';
  static const String mPinSettingScreen = '/mPinSettingScreen';
  static const String dashBoardAppBarScreen = '/dashBoardAppBarScreen';
  static const String homeScreen = '/homeScreen';
  static const String dashboardScreen = '/dashboardScreen';
  static const String approvedScreen = '/approvedScreen';
  static const String dateLineScreen = '/dateLineScreen';
  static const String changeMPINScreen = '/changeMPINScreen';
  static const String AccountListScreen = '/AccountListScreen';
  static const String AccountDetailsScreen = '/AccountDetailsScreen';
  static const String ForgotPasswordScreen = '/ForgotPasswordScreen';
  static const String profileScreen = '/profileScreen';
  static const String otpScreen = '/otpScreen';
}


final pages = [
  GetPage(name: AppRoute.initialPage, page: () => const SplashScreen()),
  GetPage(name: AppRoute.registrationFirstScreen, page: () => const RegistrationScreen()),
  GetPage(name: AppRoute.registrationSecondScreen, page: () => const MobileOtpVerification()),
  GetPage(name: AppRoute.registrationFaceIDSuccessfully, page: () => const RegistrationFaceSuccessFully()),
  GetPage(name: AppRoute.registrationTouchSuccessfully, page: () => const RegistrationTouchSuccessFully()),
  GetPage(name: AppRoute.login, page: () => const Login()),
  GetPage(name: AppRoute.loginThroughMPIN, page: () =>  const LoginThroughMPIN()),
  GetPage(name: AppRoute.mPinSettingScreen, page: () => const MPinSettingScreen()),
  GetPage(name: AppRoute.dashBoardAppBarScreen, page: () => const DashBoardAppBarScreen()),
  GetPage(name: AppRoute.homeScreen, page: () => const HomeScreen()),
  GetPage(name: AppRoute.dashboardScreen, page: () => const DashBoardScreen()),
  GetPage(name: AppRoute.approvedScreen, page: () => const ApprovedScreen()),
  GetPage(name: AppRoute.dateLineScreen, page: () => const DateLineScreen()),
  GetPage(name: AppRoute.changeMPINScreen, page: () => const ChangeMPINScreen()),
  GetPage(name: AppRoute.AccountListScreen, page: () => const EnquiryScreen()),
  GetPage(name: AppRoute.AccountDetailsScreen, page: () => const EnquiryDetailScreen()),
  GetPage(name: AppRoute.ForgotPasswordScreen, page: () => const ForgotPasswordScreen()),
  GetPage(name: AppRoute.profileScreen, page: () => const ProfileScreen()),
  GetPage(name: AppRoute.otpScreen, page: () => const OtpScreen()),
];
