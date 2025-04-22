import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:bolshek_pro/generated/l10n.dart';

class YandexMapPickerScreen extends StatefulWidget {
  const YandexMapPickerScreen({Key? key}) : super(key: key);

  @override
  State<YandexMapPickerScreen> createState() => _YandexMapPickerScreenState();
}

class _YandexMapPickerScreenState extends State<YandexMapPickerScreen> {
  // Начальная точка на карте (Шымкент)
  Point selectedPoint = const Point(latitude: 42.3154, longitude: 69.5901);

  // Изначальное значение адреса будет установлено через локализацию
  String selectedAddress = '';
  YandexMapController? mapController;
  List<MapObject> mapObjects = [];

  /// ВАЖНО! Убедитесь, что этот ключ валидный и имеет доступ к Geocoder API
  final String apiKey = 'fb1a4221-df9c-4784-9b42-0deeac4d0791';

  @override
  void initState() {
    super.initState();
    // Пока что оставляем пустым — оно будет установлено в didChangeDependencies
    selectedAddress = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Устанавливаем значение по умолчанию при первом обращении к контексту
    if (selectedAddress.isEmpty) {
      selectedAddress = S.of(context).addressNotSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).chooseAddress),
      ),
      body: Stack(
        children: [
          YandexMap(
            mapObjects: mapObjects,
            onMapCreated: (controller) async {
              mapController = controller;
              // Перемещаем камеру на Шымкент при загрузке карты
              await mapController!.moveCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    target: Point(latitude: 42.3154, longitude: 69.5901),
                    zoom: 12,
                  ),
                ),
                animation: const MapAnimation(
                  type: MapAnimationType.smooth,
                  duration: 1,
                ),
              );
            },
            onCameraPositionChanged: (position, reason, finished) async {
              if (finished) {
                final target = position.target;
                setState(() {
                  selectedPoint = target;
                });
              }
            },
            onMapTap: (Point point) async {
              setState(() {
                selectedPoint = point;
              });
              await _updateAddressDetails(point.latitude, point.longitude);
              _updatePointer();
            },
          ),
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).currentAddress,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedAddress,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'address': selectedAddress,
                  'latitude': selectedPoint.latitude,
                  'longitude': selectedPoint.longitude,
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                S.of(context).selectAddress,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 180.0),
        child: FloatingActionButton(
          onPressed: _findMyLocation,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.my_location,
            size: 28,
          ),
        ),
      ),
    );
  }

  /// Запрашиваем у Яндекса адрес по координатам.
  Future<void> _updateAddressDetails(double latitude, double longitude) async {
    final url =
        'https://geocode-maps.yandex.ru/1.x/?apikey=$apiKey&geocode=$longitude,$latitude&format=json';

    print('[GEO REQUEST] => $url');

    try {
      final response = await http.get(Uri.parse(url));

      print('[GEO RESPONSE] Status code => ${response.statusCode}');
      print('[GEO RESPONSE] Body => ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final featureMember =
            data['response']['GeoObjectCollection']['featureMember'];

        if (featureMember != null && featureMember.isNotEmpty) {
          final geoObject = featureMember[0]['GeoObject'];
          final address = geoObject['metaDataProperty']['GeocoderMetaData']
              ['text'] as String?;
          setState(() {
            selectedAddress = address ?? S.of(context).failedToGetAddress;
          });
          print('[GEO] Полученный адрес => $selectedAddress');
        } else {
          setState(() {
            selectedAddress = S.of(context).failedToGetAddress;
          });
          print('[GEO] featureMember пустой => $selectedAddress');
        }
      } else {
        setState(() {
          selectedAddress = S.of(context).failedToGetAddressNetwork;
        });
        print('[GEO] Не 200. Ошибка сети => $selectedAddress');
      }
    } catch (e) {
      setState(() {
        selectedAddress = S.of(context).failedToGetAddressNetwork;
      });
      print('[GEO ERROR] => $e');
    }
  }

  /// Пытаемся найти текущую геолокацию пользователя.
  Future<void> _findMyLocation() async {
    final location = Location();

    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).locationServiceDisabled),
            ),
          );
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied ||
          permissionGranted == PermissionStatus.deniedForever) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).locationPermissionDenied),
            ),
          );
          return;
        }
      }

      final currentLocation = await location.getLocation();
      if (currentLocation.latitude == null ||
          currentLocation.longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).failedToGetCoordinates)),
        );
        return;
      }

      final currentPoint = Point(
        latitude: currentLocation.latitude!,
        longitude: currentLocation.longitude!,
      );

      setState(() {
        selectedPoint = currentPoint;
      });

      // Обновляем адрес и перемещаем камеру.
      await _updateAddressDetails(
          currentPoint.latitude, currentPoint.longitude);

      if (mapController != null) {
        await mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: currentPoint, zoom: 17),
          ),
          animation:
              const MapAnimation(type: MapAnimationType.smooth, duration: 1),
        );
      } else {
        print('[ERROR] mapController is null');
      }

      _updatePointer();
    } catch (e) {
      print('[ERROR] Ошибка при получении местоположения: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).locationError)),
      );
    }
  }

  /// Обновляем плейсмарк на карте, чтобы указать выбранную точку.
  void _updatePointer() {
    setState(() {
      mapObjects = [
        PlacemarkMapObject(
          mapId: const MapObjectId('pointer'),
          point: selectedPoint,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                'assets/icons/location.png',
              ),
              scale: 0.2,
            ),
          ),
        ),
      ];
    });
    print(
        '[MAP] Плейсмарк установлен в => lat: ${selectedPoint.latitude}, lng: ${selectedPoint.longitude}');
  }
}
