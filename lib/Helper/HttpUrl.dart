
class HttpUrl {

  static const String base = "http://172.27.3.3:7063/";

  static String get authu => "${base}MobileApi4H2H/oauth/token?grant_type=client_credentials";

  static String get Registration => "${base}MobileApi4H2H/mobileBanking/registerUser?";

  static String get mobieNumberVAlidation => "${base}MobileApi4H2H/mobileBanking/validateMobile";

  static String get otpGenerate => "${base}MobileApi4H2H/mobileBanking/generateOTP?";

  static String get verifyOtp => "${base}MobileApi4H2H/mobileBanking/validateOTP?";

  static String get mPinRegister => "${base}MobileApi4H2H/mobileBanking/mpinRegister?";

  static String get logIn => "${base}MobileApi4H2H/mobileBanking/doLogin?";

  static String get checkMpin => "${base}MobileApi4H2H/mobileBanking/mpinCheck";

  static String get updateMpin => "${base}MobileApi4H2H/mobileBanking/mpinUpdate?";

  static String get verifyMpin => "${base}MobileApi4H2H/mobileBanking/verifyMPIN?";

  static String get pendingList => "${base}MobileApi4H2H/mobileBanking/pendingFileList?";

  static String get approveList => "${base}MobileApi4H2H/mobileBanking/approvedFileList??";

  static String get failedList => "${base}MobileApi4H2H/mobileBanking/failedFileList?";

  static String get rejectedList => "${base}MobileApi4H2H/mobileBanking/rejectedFileList?";

  static String get processList => "${base}MobileApi4H2H/mobileBanking/processedFileList?";

  static String get fileApproved => "${base}MobileApi4H2H/mobileBanking/fileApprovel?";

  static String get fileReject => "${base}MobileApi4H2H/mobileBanking/fileReject?";

  static String get getTrustedDevices => "${base}MobileApi4H2H/mobileBanking/mobileDeviceList";

  static String get getDeiveForRegistration => "${base}MobileApi4H2H/mobileBanking/deviceList";

  static String get removeTrustedDevices => "${base}MobileApi4H2H/mobileBanking/removeMobile";

  static String get forgotPassword => "${base}MobileApi4H2H/mobileBanking/passwordSave";

  static String get accountList => "${base}MobileApi4H2H/mobileBanking/accountDetail";

  static String get accountStatement => "${base}MobileApi4H2H/mobileBanking/accountstmt";

  static String get logutApi => "${base}MobileApi4H2H/mobileBanking/logout?";

}



