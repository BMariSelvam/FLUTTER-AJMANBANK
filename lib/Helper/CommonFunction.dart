
import 'package:flutter/material.dart';

class CommonClass{

 //  static IosDeviceInfo? iosDeviceInfo;
 //  static AndroidDeviceInfo? androidDeviceInfo;
 //
 //  //DeviceInfo get mobile
 // static getDeviceInformation(buil) async {
 //    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
 //    if (Theme.of().platform == TargetPlatform.iOS) {
 //      // For iOS devices
 //      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
 //      osName = 'ios';
 //      deviceName = iosDeviceInfo.name;
 //      deviceId = iosDeviceInfo.identifierForVendor;
 //    } else {
 //      // For Android devices
 //      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
 //      osName = 'android';
 //      deviceName = androidDeviceInfo.model;
 //      deviceId = androidDeviceInfo.androidId;
 //    }
 //  }
 //
 //  //RerefNumber auto generate
 // static generateReferenceNumber() {
 //    final random = Random.secure();
 //    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
 //    final bytes = List.generate(32, (index) => chars.codeUnitAt(random.nextInt(chars.length)));
 //    referenceNumber = base64Url.encode(bytes).toUpperCase();
 //    return referenceNumber!;
 //  }
 //
 // static getCurrentCity() async {
 //    bool serviceEnabled;
 //    LocationPermission permission;
 //
 //    serviceEnabled = await Geolocator.isLocationServiceEnabled();
 //    if (!serviceEnabled) {
 //      currentCity.value = 'Location services are disabled';
 //      return;
 //    }
 //    permission = await Geolocator.checkPermission();
 //    if (permission == LocationPermission.deniedForever) {
 //      currentCity.value = 'Location permissions are permanently denied, we cannot request permissions.';
 //      return;
 //    }
 //
 //    if (permission == LocationPermission.denied) {
 //      permission = await Geolocator.requestPermission();
 //      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
 //        currentCity.value = 'Location permissions are denied (actual value: $permission).';
 //        return;
 //      }
 //    }
 //    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
 //    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
 //    if (placemarks != null && placemarks.isNotEmpty) {
 //      Placemark placemark = placemarks.first;
 //      String? city = placemark.locality;
 //      currentCity.value = city!;
 //    } else {
 //      currentCity.value = 'City not found';
 //    }
 //  }


  static Future<DateTime?> showCommonDatePicker(BuildContext context, {DateTime? initialDate}) async {
    DateTime currentDate = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? currentDate,
      firstDate: DateTime(currentDate.year - 1),
      lastDate: DateTime(currentDate.year + 1),
    );

    return pickedDate;
  }
}