import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:treveler/domain/entities/location.dart';

class Geolocation {
  static const double _earthRadiusInKm = 6371.0;

  Future<Location> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    final currentPosition = await Geolocator.getCurrentPosition();

    return Location(latitude: currentPosition.latitude, longitude: currentPosition.longitude);
  }

  double calculateDistance(Location locationOne, Location locationTwo) {
    final double lat1Rad = _degreesToRadians(locationOne.latitude);
    final double lng1Rad = _degreesToRadians(locationOne.longitude);
    final double lat2Rad = _degreesToRadians(locationTwo.latitude);
    final double lng2Rad = _degreesToRadians(locationTwo.longitude);

    final double dLat = lat2Rad - lat1Rad;
    final double dLng = lng2Rad - lng1Rad;

    final double a = pow(sin(dLat / 2), 2) + cos(lat1Rad) * cos(lat2Rad) * pow(sin(dLng / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = _earthRadiusInKm * c;

    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
