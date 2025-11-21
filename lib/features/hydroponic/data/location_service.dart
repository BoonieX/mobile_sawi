import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getPlacemarkFromCoordinates(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Format: "City, Country"
        // Sometimes locality is null, try subAdministrativeArea or administrativeArea
        String city = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? '';
        String country = place.country ?? '';
        
        if (city.isNotEmpty && country.isNotEmpty) {
          return "$city, $country";
        } else if (country.isNotEmpty) {
          return country;
        } else {
          return city;
        }
      }
      return "Unknown Location";
    } catch (e) {
      return "Unknown Location";
    }
  }
}
