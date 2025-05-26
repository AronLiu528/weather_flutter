import 'package:geolocator/geolocator.dart';

class Location {
  late double latitude;
  late double longitude;

  Future<void> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;

    if (!serviceEnabled) {
      print('未開啟定位功能');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('用戶拒絕授權定位');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('用戶拒絕定位功能');
      return;
    }
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    latitude = position.latitude;
    longitude = position.longitude;
  }
}
