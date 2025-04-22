import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;

class YandexMapInlinePicker extends StatefulWidget {
  final Function(String address, double lat, double lon) onChanged;

  const YandexMapInlinePicker({Key? key, required this.onChanged})
      : super(key: key);

  @override
  State<YandexMapInlinePicker> createState() => _YandexMapInlinePickerState();
}

class _YandexMapInlinePickerState extends State<YandexMapInlinePicker> {
  final String apiKey = 'fb1a4221-df9c-4784-9b42-0deeac4d0791';

  late YandexMapController mapController;
  Point selectedPoint = const Point(latitude: 42.3154, longitude: 69.5901);
  List<MapObject> mapObjects = [];
  String selectedAddress = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _updateAddress(selectedPoint));
  }

  Future<void> _updateAddress(Point point) async {
    final url =
        'https://geocode-maps.yandex.ru/1.x/?apikey=$apiKey&geocode=${point.longitude},${point.latitude}&format=json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final featureMember =
            data['response']['GeoObjectCollection']['featureMember'];

        if (featureMember != null && featureMember.isNotEmpty) {
          final geoObject = featureMember[0]['GeoObject'];
          final address =
              geoObject['metaDataProperty']['GeocoderMetaData']['text'];
          setState(() {
            selectedAddress = address;
          });
          widget.onChanged(address, point.latitude, point.longitude);
        }
      }
    } catch (e) {
      print('[Address Error] $e');
    }
  }

  void _updateMarker(Point point) {
    setState(() {
      selectedPoint = point;
      mapObjects = [
        PlacemarkMapObject(
          mapId: const MapObjectId('selected_point'),
          point: point,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image:
                  BitmapDescriptor.fromAssetImage('assets/icons/location.png'),
              scale: 0.2,
            ),
          ),
        ),
      ];
    });
    _updateAddress(point);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) async {
              mapController = controller;
              await mapController.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: selectedPoint, zoom: 14),
                ),
              );
              _updateMarker(selectedPoint);
            },
            onMapTap: (point) => _updateMarker(point),
            mapObjects: mapObjects,
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                selectedAddress.isNotEmpty
                    ? selectedAddress
                    : 'Адрес не выбран',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
