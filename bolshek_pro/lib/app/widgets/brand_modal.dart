import 'package:flutter/material.dart';
import 'package:bolshek_pro/core/models/brands_response.dart';

class BrandModal extends StatelessWidget {
  final List<BrandItems> brands;
  final Function(String) onBrandSelected;

  const BrandModal({
    Key? key,
    required this.brands,
    required this.onBrandSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String searchQuery = '';

    return StatefulBuilder(
      builder: (context, setStateModal) {
        final filteredBrands = brands
            .where((brand) =>
                brand.name != null &&
                brand.name!.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Поиск бренда',
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
                    itemCount: filteredBrands.length,
                    itemBuilder: (context, index) {
                      final brand = filteredBrands[index];
                      return ListTile(
                        title: Text(brand.name ?? 'Без названия'),
                        onTap: () {
                          Navigator.pop(context);
                          onBrandSelected(brand.name ?? 'Без названия');
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      // Логика для создания нового бренда
                      _showAddBrandDialog(context);
                    },
                    child: const Text('Создать новый бренд'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddBrandDialog(BuildContext context) {
    String newBrandName = '';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Добавить новый бренд'),
              content: TextField(
                decoration:
                    const InputDecoration(hintText: 'Введите название бренда'),
                onChanged: (value) {
                  newBrandName = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newBrandName.isNotEmpty) {
                      // Логика для добавления бренда
                      // Пример: вызов метода добавления бренда через сервис
                      // _brandsService.createBrand(newBrandName);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Добавить'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
