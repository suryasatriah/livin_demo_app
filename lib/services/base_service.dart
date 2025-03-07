import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dolphin_livin_demo/constant.dart';

class BaseService {
  static const int kPortNonGenerative = 9443;
  static const int kPortGenerative = 7182;

  static const String kEndpointNonGenerative = "/dolphin/apiv1/graph";
  static const String kEndpointGenerative = "/dolphin/apiv1/generative";

  String getNonGenerativeUrl(String endpoint) =>
      "$kBaseUrl:$kPortNonGenerative$kEndpointNonGenerative$endpoint";
  
  String getGenerativeUrl(String endpoint) =>
      "$kBaseUrl:$kPortGenerative$kEndpointGenerative$endpoint";

  String generateRandomString() {
    // Get the current date and time
    DateTime now = DateTime.now();
    // Format date and time into a string
    String dateTimeString = now.toIso8601String();
    // Generate a random integer to add more randomness
    int randomInt = Random().nextInt(10000);
    // Combine date, time, and random integer
    String combinedString = '$dateTimeString$randomInt';
    // Hash the combined string using SHA256 for a 32-character result
    String hashString = sha256.convert(utf8.encode(combinedString)).toString();
    // Take the first 32 characters to match the example format
    return hashString.substring(0, 32); // Adjust length as needed
  }
}