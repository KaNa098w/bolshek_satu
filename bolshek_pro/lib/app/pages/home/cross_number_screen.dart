import 'dart:async';
import 'package:bolshek_pro/app/pages/home/vehicle_screen.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/app/widgets/custom_editle_drop_down.dart';
import 'package:bolshek_pro/core/models/alternative_cross_response.dart';
import 'package:bolshek_pro/core/models/cross_number_response.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/service/cross_number_service.dart';
import 'package:bolshek_pro/app/widgets/editable_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:provider/provider.dart';

class CarBrandOEM {
  String brand;
  String oem;
  String vehicleId;
  List<Map<String, String>> alternatives;
  CarBrandOEM({
    this.brand = 'Выберите подходящие марки',
    this.oem = '',
    this.vehicleId = '',
    this.alternatives = const [],
  });
}

class CrossNumberInput extends StatefulWidget {
  final CarBrandOEM carData;
  final Function(String) onOEMChanged;

  const CrossNumberInput({
    Key? key,
    required this.carData,
    required this.onOEMChanged,
  }) : super(key: key);

  @override
  _CrossNumberInputState createState() => _CrossNumberInputState();
}

class _CrossNumberInputState extends State<CrossNumberInput> {
  Timer? _debounce;
  List<Items> _suggestedItems = []; // список объектов Items
  AlternativeCrossResponse? _alternativeResponse; // для хранения альтернатив
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _onChanged(String value) {
    widget.onOEMChanged(value);

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      if (value.length > 1) {
        try {
          final response = await CrossNumberGenerateService()
              .getCrossNumber(context: context, crossNumber: value);
          setState(() {
            _suggestedItems = response.items ?? [];
          });
          _updateOverlay();
        } catch (e) {
          print('Ошибка при получении данных: $e');
        }
      } else {
        setState(() {
          _suggestedItems = [];
        });
        _removeOverlay();
      }
    });
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0.0, size.height + 5.0),
          showWhenUnlinked: false,
          child: Material(
            color: Colors.white,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: _suggestedItems.map((item) {
                return ListTile(
                  title: Text(item.crossNumber ?? ''),
                  onTap: () {
                    // Обновляем данные основного кроссномера
                    setState(() {
                      widget.carData.oem = item.crossNumber ?? '';
                      widget.carData.vehicleId = item.vehicleGenerationId ?? '';
                      widget.carData.brand =
                          item.vehicleGeneration?.model?.brand?.name ??
                              'Выберите подходящие марки';
                      _suggestedItems = [];
                    });
                    widget.onOEMChanged(item.crossNumber ?? '');
                    // Вызываем сервис альтернативных номеров, отправляя item.id
                    CrossNumberGenerateService()
                        .getAlternativesCrossNumber(
                      context: context,
                      crossNumberId: item.id ?? '',
                    )
                        .then((altResponse) {
                      setState(() {
                        _alternativeResponse = altResponse;
                        // Сохраняем альтернативные номера (id и crossNumber) в объекте carData
                        widget.carData.alternatives =
                            altResponse.items?.map((altItem) {
                                  return {
                                    'id': altItem.vehicleGenerationId ?? '',
                                    'crossNumber': altItem.crossNumber ?? '',
                                  };
                                }).toList() ??
                                [];
                      });
                    }).catchError((e) {
                      print('Ошибка получения альтернативных номеров: $e');
                    });
                    _removeOverlay();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: CustomEditableDropdownField(
            title: 'Введите OEM номер',
            value: widget.carData.oem,
            onChanged: _onChanged,
          ),
        ),
        if (_alternativeResponse != null &&
            _alternativeResponse!.items?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Альтернативные OEM номера:",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  _alternativeResponse!.items!
                      .map((altItem) => altItem.crossNumber ?? '')
                      .join(', '),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class CrossNumberScreen extends StatefulWidget {
  final String? modelName;
  final String? brandName;
  final String? carName;

  const CrossNumberScreen(
      {Key? key, this.modelName, this.brandName, this.carName})
      : super(key: key);

  @override
  State<CrossNumberScreen> createState() => _CrossNumberScreenState();
}

class _CrossNumberScreenState extends State<CrossNumberScreen> {
  final List<CarBrandOEM> _cars = [];

  @override
  void initState() {
    super.initState();
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);

    if (globalProvider.carMappings.isNotEmpty) {
      _cars.addAll(globalProvider.carMappings.map((mapping) => CarBrandOEM(
            brand: mapping['brandName'] ?? 'Выберите подходящие марки',
            oem: mapping['oem'] ?? '',
            vehicleId: mapping['vehicleId'] ?? '',
            alternatives: mapping['alternatives'] ?? [],
          )));
    } else {
      final initialValue =
          '${widget.carName ?? ''} ${widget.brandName ?? ''} ${widget.modelName ?? ''}'
              .trim();
      if (initialValue.isNotEmpty) {
        _cars.add(CarBrandOEM(brand: initialValue));
      } else {
        _cars.add(CarBrandOEM());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Соответствие с автомобилем',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: List.generate(_cars.length, (index) {
                  final carData = _cars[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (index == 0)
                        // Для первого элемента показываем заголовок и виджет поиска
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Основной OEM номер",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 15),
                            CrossNumberInput(
                              carData: carData,
                              onOEMChanged: (value) {
                                setState(() {
                                  carData.oem = value;
                                });
                              },
                            ),
                          ],
                        )
                      else
                        // Для остальных элементов кнопка закрытия сверху, а поле ввода ниже
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _cars.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                            CustomEditableDropdownField(
                              title: 'OEM номер',
                              value: carData.oem,
                              onChanged: (value) {
                                setState(() {
                                  carData.oem = value;
                                });
                              },
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),
                      CustomDropdownField(
                        rightIcon: true,
                        title: 'Соответствие с автомобилем',
                        value: carData.brand,
                        onTap: () {
                          Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VehicleBrandsPage(),
                            ),
                          ).then((result) {
                            if (result != null) {
                              setState(() {
                                carData.brand = result;
                              });
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }),
              ),
              // Кнопка для добавления нового соответствия
              TextButton(
                  onPressed: () {
                    setState(() {
                      _cars.add(CarBrandOEM());
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Добавить еще соответствие +',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      // const Icon(
                      //   Icons.add,
                      //   color: Colors.grey,
                      // ),
                    ],
                  )),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CustomButton(
                  text: 'Подтвердить',
                  onPressed: () {
                    final brandMappings = _cars.map((car) {
                      // Разбиваем строку brand на части по запятой
                      final brandParts = car.brand.split(',');
                      // Если частей не меньше 4, берем четвертый элемент, иначе оставляем текущее значение vehicleId
                      final vehicleIdExtracted = brandParts.length >= 4
                          ? brandParts[3].trim()
                          : car.vehicleId;
                      return {
                        'brandName': car.brand,
                        'oem': car.oem,
                        'vehicleId': vehicleIdExtracted,
                        'alternatives': car.alternatives,
                      };
                    }).toList();

                    Provider.of<GlobalProvider>(context, listen: false)
                        .setCarMappings(brandMappings);

                    Navigator.pop(context, brandMappings);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
