import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:location/location.dart';

const String TAG = "LocationNotifier - ";

final locationStateProvider = StateNotifierProvider<
    LocationNotifier, LocationData?>(
      (ref) => LocationNotifier(ref),
);

class LocationNotifier extends StateNotifier<LocationData?> {
  LocationNotifier(this._ref) : super((null));

  final Ref _ref;
  LocationData? _locationData;
  Location location = Location();

  bool _locServiceEnabled = false;
  bool _locPermissionGranted = false;

  get isLocServiceEnabled => _locServiceEnabled;
  get isLocPermissionGranted => _locPermissionGranted;

  LocationData? get getLoc => _locationData;

  Future<LocationData> refreshLoc() async {
    LocationData locationData = await location.getLocation();
    _locationData = locationData;
    return locationData;
  }

  Future<bool> enableLocService() async {
    bool canGetLoc = false;
    _locServiceEnabled = await location.serviceEnabled();
    if (!_locServiceEnabled) {
      _locServiceEnabled = await location.requestService();
      if (!_locServiceEnabled) {
        canGetLoc = false;
      } else {
        canGetLoc = await _checkPermissions();
      }
    } else {
      canGetLoc = await _checkPermissions();
    }
    return canGetLoc;
  }

  Future<bool> _checkPermissions() async {
    PermissionStatus permissionGranted = PermissionStatus.denied;
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      _locPermissionGranted = false;
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // PermissionStatus not granted
        _locPermissionGranted = false;
        return false;
      }
    }
    // PermissionStatus granted
    _locPermissionGranted = true;
    return true;
  }



  Future<LocationData?> getLocData() async {
    LocationData? loc = getLoc;
    if (_locationData == null && loc != null) {
      _locationData = loc;
    }
    final canGetLoc = await enableLocService();
    if (canGetLoc) {
      loc ??= await refreshLoc();
      _locationData = loc;
    }
    state = _locationData;
    return state;
  }


  Future<String?> getLocAddress(LocationData locationData) async {
    debugPrint("$TAG getLocAddress() Lat = ${locationData.latitude}");
    debugPrint("$TAG getLocAddress() Lng = ${locationData.longitude}");
    double lat = 0.0;
    double lng = 0.0;
    String? userCity;
    try {
      lat = double.parse(locationData.latitude.toString());
      lng = double.parse(locationData.longitude.toString());
    } catch (e, s) {
      debugPrint("$TAG getLocAddress(): ERROR 1 == ${e.toString()}");
    }
    try {
      if (lat != 0.0 && lng != 0.0) {
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
        if (placemarks.isNotEmpty) {
          var pm = placemarks.first;
          debugPrint("$TAG getLocAddress() administrativeArea = ${pm.administrativeArea}");
          debugPrint("$TAG getLocAddress() country = ${pm.country}");
          debugPrint("$TAG getLocAddress() locality = ${pm.locality}");
          debugPrint("$TAG getLocAddress() postalCode = ${pm.postalCode}");
          userCity = pm.locality;
        }
      }
    } catch (e, s) {
      debugPrint("$TAG getLocAddress(): ERROR 2 == ${e.toString()}");
    }
    return userCity;
  }
}