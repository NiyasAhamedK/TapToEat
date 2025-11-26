

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Position? position;
List<Placemark>? placeMark;
String fullAddress = "";
SharedPreferences? sharedPreferences;
TextEditingController flatNumber = TextEditingController();
TextEditingController city = TextEditingController();
TextEditingController state = TextEditingController();
TextEditingController completeAddress = TextEditingController();
double latitudeValue = 0.0;
double longitudeValue = 0.0;
String paymentResult = "";
