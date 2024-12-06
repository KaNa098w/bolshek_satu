import 'package:bolshek_pro/app/widgets/custom_dropdown_field.dart';
import 'package:bolshek_pro/app/widgets/editable_dropdown_field.dart';
import 'package:bolshek_pro/core/models/manufacturers_response.dart';
import 'package:bolshek_pro/core/service/maufacturers_service.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsWidget extends StatefulWidget {
  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final ManufacturersService _service = ManufacturersService();
  List<ManufacturersItems> _manufacturers = [];
  ManufacturersItems? _selectedManufacturer;
  int _quantity = 0;
  String selectedType = 'Оригинал'; // Значение по умолчанию
  String selectedDelivery = 'Стандартная';
  String? descriptionText = '';

  @override
  void initState() {
    super.initState();
    _loadManufacturers();
  }

  Future<void> _loadManufacturers() async {
    try {
      final response = await _service.fetchManufacturers(context);
      setState(() {
        _manufacturers = response.items ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки производителей: $e')),
      );
    }
  }

  Future<void> _showAddManufacturerDialog() async {
    final TextEditingController nameController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить производителя'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Название производителя',
              hintText: 'Введите название',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  Navigator.of(context).pop(name);
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      try {
        await _service.createManufacturers(context, result);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Производитель "$result" успешно добавлен')),
        );
        await _loadManufacturers();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка добавления производителя: $e')),
        );
      }
    }
  }

  void _showTypeOptions() {
    final typeOptions = ['Оригинал', 'Под оригинал', 'Авторазбор'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = ''; // Локальная переменная для поиска
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredTypes = typeOptions
                .where((type) =>
                    type.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      children: [Text('Тип товара')],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredTypes.length,
                        itemBuilder: (context, index) {
                          final type = filteredTypes[index];
                          return ListTile(
                            title: Text(type),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                selectedType = type;
                                String kind = '';
                                if (type == 'Оригинал') kind = 'original';
                                if (type == 'Под оригинал')
                                  kind = 'sub_original';
                                if (type == 'Авторазбор') kind = 'autorazbor';
                                context.read<GlobalProvider>().setKind(kind);
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeliveryMethods() {
    final deliveryMethods = ['Эксперт', 'Стандартная', 'Индивидуальная'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = ''; // Локальная переменная для поиска
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredMethods = deliveryMethods
                .where((method) =>
                    method.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      children: [Text('Методы доставки')],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredMethods.length,
                        itemBuilder: (context, index) {
                          final method = filteredMethods[index];
                          return ListTile(
                            title: Text(method),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                selectedDelivery = method;
                                String deliveryType = '';
                                if (method == 'Эксперт')
                                  deliveryType = 'express';
                                if (method == 'Стандартная')
                                  deliveryType = 'standard';
                                if (method == 'Индивидуальная')
                                  deliveryType = 'custom';
                                context
                                    .read<GlobalProvider>()
                                    .setKind(deliveryType);
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      }
    });
  }

  void _showManufacturers() {
    if (_manufacturers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Список производителей пуст')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        String searchQuery = ''; // Локальная переменная для поиска
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final filteredManufacturers = _manufacturers
                .where((manufacturer) =>
                    manufacturer.name != null &&
                    manufacturer.name!
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Поиск производителя',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                            ),
                            onChanged: (value) {
                              setStateModal(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredManufacturers.length,
                        itemBuilder: (context, index) {
                          final manufacturer = filteredManufacturers[index];
                          return ListTile(
                            title: Text(manufacturer.name ?? 'Без названия'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedManufacturer = manufacturer;
                                // Сохраняем ID производителя в AuthProvider
                                context
                                    .read<GlobalProvider>()
                                    .setManufacturerId(manufacturer.id ?? '');
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                        text: 'Добавить производителя',
                        onPressed: () {
                          _showAddManufacturerDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12.0),
      //   border:
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDropdownField(
                  title: 'Тип',
                  value: selectedType ?? 'Выберите тип',
                  onTap: _showTypeOptions,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: CustomDropdownField(
                  title: 'Методы доставки',
                  value: selectedDelivery ?? 'Выберите метод доставки',
                  onTap: _showDeliveryMethods,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          // _buildStyledDropdown(
          //   label: 'Статус',
          //   items: ['В продаже', 'Ожидает модерации', 'Не активен'],
          //   value: 'Ожидает модерации', // Фиксированное значение
          //   onChanged: (value) {
          //     // Никакого действия не требуется
          //   },
          //   isReadOnly: true, // Устанавливаем режим только для чтения
          // ),
          CustomDropdownField(
              title: 'Производитель',
              value: _selectedManufacturer?.name ?? 'Выберите производителя',
              onTap: _showManufacturers),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: EditableDropdownField(
                  title: 'Описание',
                  value: '',
                  hint: 'Описание товара',
                  maxLines: 4, // Поле ввода занимает до 4 строк
                  onChanged: (value) {
                    context.read<GlobalProvider>().setDescriptionText(value);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: EditableDropdownField(
                  title: 'SKU',
                  value: '',
                  hint: 'Введите артикул',
                  maxLines: 1, // Поле для ввода одной строки
                  onChanged: (value) {
                    context.read<GlobalProvider>().setSku(value);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: EditableDropdownField(
                  title: 'Код запчасти',
                  value: '',
                  hint: 'Введите код запчасти',
                  maxLines: 1, // Поле для ввода одной строки
                  onChanged: (value) {
                    context.read<GlobalProvider>().setVendorCode(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    int maxLines = 1,
    ValueChanged<String>? onChanged, // Добавляем параметр onChanged
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8.0),
        TextField(
          maxLines: maxLines,
          onChanged: onChanged, // Подключаем обработчик изменений текста
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true, // Включаем заполнение фона
            fillColor: Colors.grey.shade200, // Устанавливаем серый цвет фона
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0), // Закругляем углы
              borderSide: BorderSide.none, // Убираем границу
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStyledDropdown({
    required String label,
    required List<String> items,
    String? value,
    ValueChanged<String?>? onChanged,
    bool isReadOnly = false, // Новый параметр для управления доступностью
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: value ?? items.first,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            filled: true,
            fillColor: isReadOnly
                ? Colors.grey.shade200 // Серый фон для недоступного
                : Colors.grey.shade200, // Тот же фон, как в текстовом поле
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0), // Закругляем углы
              borderSide: BorderSide.none, // Убираем границу
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: isReadOnly ? null : onChanged, // Блокируем onChanged
          disabledHint: Text(
            value ?? 'Ожидает модерации',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: ElevatedButton(
        onPressed: _showAddManufacturerDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
