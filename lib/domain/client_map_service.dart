import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapService {
  final String _baseUrl = "https://router.hereapi.com/v8/";
  final String _apiKey = "DW2EtICUSqlxaWY1Zy2ir8ABPQrq_F6LGh1PDa_qxsc";

  Future<Map<String, dynamic>> getTime(LatLng pickup, LatLng destination) async {
    const String endpoint = "routes";
    final String url = _baseUrl + endpoint;
    final dio = Dio();
    Map<String, dynamic> result = {
      "data": -1
    };
    await dio.get(url, queryParameters: {
    "apiKey": _apiKey,
    "transportMode": "car",
    "origin": "${pickup.latitude},${pickup.longitude}",
    "destination":"${destination.latitude},${destination.longitude}",
    "return":"summary,polyline",
    }).then((value) {
      double time = value.data["routes"][0]["sections"][0]["summary"]["duration"] / 60;
      int distance = value.data["routes"][0]["sections"][0]["summary"]["length"];
      String polylineCode = value.data["routes"][0]["sections"][0]["polyline"];
      result = {
        "time": time.round(),
        "distance": distance,
        "polylineCode": polylineCode,
      };
    });
    return result;
  }

  Future<String> getPolyline(LatLng pickup, LatLng destination) async {
    const String endpoint = "routes";
    final String url = _baseUrl + endpoint;
    final dio = Dio();
    String result = "";
    await dio.get(url, queryParameters: {
    "apiKey": _apiKey,
    "transportMode": "car",
    "origin": "${pickup.latitude},${pickup.longitude}",
    "destination":"${destination.latitude},${destination.longitude}",
    "return":"polyline",
    }).then((value) {
      String polylineCode = value.data["routes"][0]["sections"][0]["polyline"];
      result = polylineCode;
    });
    return result;
  }
}