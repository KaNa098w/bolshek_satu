import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;

class YandexMapViewPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const YandexMapViewPage({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<YandexMapViewPage> createState() => _YandexMapViewPageState();
}

class _YandexMapViewPageState extends State<YandexMapViewPage> {
  late List<MapObject> mapObjects;
  String currentAddress = 'Определение адреса...';
  final String apiKey = 'fb1a4221-df9c-4784-9b42-0deeac4d0791'; // Ваш API ключ

  @override
  void initState() {
    super.initState();

    // Добавляем плейсмарк на карту
    mapObjects = [
      PlacemarkMapObject(
        mapId: const MapObjectId('selected_location'),
        point: Point(latitude: widget.latitude, longitude: widget.longitude),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/icons/location.png'),
            scale: 0.3,
          ),
        ),
      ),
    ];

    // Получаем адрес для начальных координат
    _updateAddress(widget.latitude, widget.longitude);
  }

  Future<void> _updateAddress(double latitude, double longitude) async {
    final url =
        'https://geocode-maps.yandex.ru/1.x/?apikey=$apiKey&geocode=$longitude,$latitude&format=json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final featureMember =
            data['response']['GeoObjectCollection']['featureMember'];

        if (featureMember != null && featureMember.isNotEmpty) {
          final geoObject = featureMember[0]['GeoObject'];
          final address = geoObject['metaDataProperty']['GeocoderMetaData']
              ['text'] as String?;
          setState(() {
            currentAddress = address ?? 'Не удалось определить адрес';
          });
        } else {
          setState(() {
            currentAddress = 'Адрес не найден';
          });
        }
      } else {
        setState(() {
          currentAddress = 'Ошибка сети';
        });
      }
    } catch (e) {
      setState(() {
        currentAddress = 'Ошибка определения адреса';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final point = Point(latitude: widget.latitude, longitude: widget.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Просмотр адреса на карте'),
      ),
      body: Stack(
        children: [
          YandexMap(
            mapObjects: mapObjects,
            onMapCreated: (controller) async {
              // Перемещаем камеру на выбранный адрес
              await controller.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(target: point, zoom: 17),
                ),
                animation: const MapAnimation(
                    type: MapAnimationType.smooth, duration: 1),
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Text(
                currentAddress,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
