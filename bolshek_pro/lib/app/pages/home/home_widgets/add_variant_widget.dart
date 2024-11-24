import 'package:bolshek_pro/core/models/manufacturers_response.dart';
import 'package:bolshek_pro/core/service/maufacturers_service.dart';
import 'package:bolshek_pro/app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ProductDetailsWidget extends StatefulWidget {
  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final ManufacturersService _service = ManufacturersService();
  List<Items> _manufacturers = [];
  Items? _selectedManufacturer;
  int _quantity = 0;

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
    String selectedType = 'Оригинал'; // Значение по умолчанию
    String selectedStatus = 'В продаже'; // Значение по умолчанию

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
                child: _buildStyledDropdown(
                  label: 'Тип',
                  items: ['Оригинал', 'Под оригинал', 'Авторазбор'],
                  value: selectedType, // Передаем текущее выбранное значение
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedType = value; // Обновляем выбранное значение
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: _buildStyledDropdown(
                  label: 'Статус товара',
                  items: ['В продаже', 'Ожидает модерации', 'Не активен'],
                  value: selectedStatus, // Передаем текущее выбранное значение
                  onChanged: (valueStatus) {
                    if (valueStatus != null) {
                      setState(() {
                        selectedStatus =
                            valueStatus; // Обновляем выбранное значение
                      });
                    }
                  },
                ),
              ),
              // const SizedBox(width: 8.0),
              // Expanded(
              //   child: _buildQuantityField(),
              // ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Производитель',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(
                        height: 8), // Отступ между текстом и dropdown
                    InkWell(
                      onTap: _showManufacturers,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _selectedManufacturer?.name ??
                              'Выберите производителя',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // const SizedBox(width: 8.0),
              // ElevatedButton(
              //   onPressed: _showManufacturers,
              //   child: const Icon(Icons.search),
              // ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                    label: 'SKU', hint: 'Артикул товара на складе'),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                    label: 'Код запчасти', hint: 'Код запчасти товара'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600)),
        const SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
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
    String? valueStatus,
    ValueChanged<String?>? onChanged,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
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
