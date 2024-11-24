import 'package:bolshek_pro/app/pages/home/home_widgets/add_variant_widget.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/models/properties_response.dart';
import 'package:bolshek_pro/core/service/properties_service.dart';
import 'package:bolshek_pro/app/widgets/custom_input_widget.dart';

class CharacteristicsTab extends StatefulWidget {
  final String? categoryId;
  final List<PropertyItems> cachedProperties;
  final Map<String, String> cachedPropertyValues;

  const CharacteristicsTab({
    Key? key,
    this.categoryId,
    this.cachedProperties = const [],
    this.cachedPropertyValues = const {},
  }) : super(key: key);

  @override
  _CharacteristicsTabState createState() => _CharacteristicsTabState();
}

class _CharacteristicsTabState extends State<CharacteristicsTab> {
  List<PropertyItems> _properties = [];
  Map<String, String> _propertyValues = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.cachedProperties.isNotEmpty &&
        widget.cachedPropertyValues.isNotEmpty) {
      // Используем кэшированные данные
      setState(() {
        _properties = widget.cachedProperties;
        _propertyValues = widget.cachedPropertyValues;
        isLoading = false;
      });
    } else if (widget.categoryId != null) {
      _loadProperties();
    }
  }

  @override
  void didUpdateWidget(covariant CharacteristicsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId) {
      if (widget.cachedProperties.isNotEmpty &&
          widget.cachedPropertyValues.isNotEmpty) {
        // Используем кэш
        setState(() {
          _properties = widget.cachedProperties;
          _propertyValues = widget.cachedPropertyValues;
        });
      } else {
        _loadProperties();
      }
    }
  }

  Future<void> _loadProperties() async {
    if (widget.categoryId == null) return;

    try {
      setState(() {
        isLoading = true;
      });

      // Загрузка свойств через сервис
      final response = await PropertiesService()
          .fetchProperties(context, widget.categoryId!);

      setState(() {
        _properties = response.items ?? [];
        _propertyValues = {
          for (var property in _properties) property.id ?? '': '',
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('Ошибка загрузки свойств: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ОК'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_properties.isEmpty) {
      return const Center(child: Text('Свойства не найдены'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Основные характеристики',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ..._properties.map((property) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputField(
                    title: property.unit == null
                        ? '${property.name}'
                        : '${property.name} (${property.unit})' ?? 'Свойство',
                    value: _propertyValues[property.id ?? ''] ?? '',
                    hint: 'Введите значение ',
                    onChanged: (value) {
                      setState(() {
                        _propertyValues[property.id ?? ''] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
            ProductDetailsWidget(),
            const SizedBox(height: 12),
            Center(
              child: CustomButton(
                text: 'Создать товар',
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
